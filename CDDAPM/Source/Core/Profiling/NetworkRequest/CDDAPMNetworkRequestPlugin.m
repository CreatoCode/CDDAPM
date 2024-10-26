//
//  CDDAPMNetworkRequestPlugin.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/14.
//

#import <objc/runtime.h>
#import <QuartzCore/CABase.h>
#import "CDDAPMNetworkRequestPlugin.h"
#import "NSURLSession+NetworkRequestMonitor.h"
#import "CDDAPM.h"
#import "NSURL+Addition.h"
#import "NSURLRequest+Addition.h"   
#import "CDDAPMNetworkRequestModel.h"

CDDConstString CDDAPMNetworkRequestPluginTag = @"NetworkRequest"; 

@interface CDDAPMNetworkRequestPlugin ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *requestStartTimes;
// @property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<NSNumber *> *> *requestDurations;
@property (nonatomic, assign) NSUInteger totalRequests;
@property (nonatomic, assign) NSTimeInterval totalDuration;
@end

@implementation CDDAPMNetworkRequestPlugin

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestStartTimes = [NSMutableDictionary dictionary];
        // _requestDurations = [NSMutableDictionary dictionary];
        _totalRequests = 0;
        _totalDuration = 0;
    }
    return self;
}

- (BOOL)start {
    [NSURLSession cddStartNetworkRequestMonitor];
    return true;
}

- (void)destroy { 
    
}

+ (NSString * _Nonnull)getTag { 
    return (NSString *)CDDAPMNetworkRequestPluginTag;
}

- (void)stop { 
    
}

- (void)recordStartTimeForRequest:(NSString *)requestID urlString:(NSString *)urlString {
    @synchronized (self) {
        self.requestStartTimes[requestID] = @(CACurrentMediaTime());
    }
}

- (void)recordEndTimeForRequest:(NSString *)requestID urlString:(NSString *)urlString {
    @synchronized (self) {
        NSNumber *startTime = self.requestStartTimes[requestID];
        if (startTime) {
            NSTimeInterval duration = CACurrentMediaTime() - [startTime doubleValue];
            CDDAPMLogDebug(@"url:%@, duration: %f", urlString, duration);
            // if (!self.requestDurations[urlString]) {
            //     self.requestDurations[urlString] = [NSMutableArray array];
            // }
            // [self.requestDurations[urlString] addObject:@(duration)];
            
            self.totalRequests++;
            self.totalDuration += duration;
            [self.requestStartTimes removeObjectForKey:requestID];
            CDDAPMNetworkRequestModel *model = [[CDDAPMNetworkRequestModel alloc] init];
            model.url = urlString;
            model.duration = duration;
            if ([self.reportDelegate respondsToSelector:@selector(reportIssue:)]) {
                [self.reportDelegate reportIssue:model];
            }
        }
    }
}

// - (NSDictionary *)getNetworkStatistics {
//     @synchronized (self) {
//         NSTimeInterval averageDuration = self.totalRequests > 0 ? self.totalDuration / self.totalRequests : 0;
//         NSTimeInterval minDuration = [[self.requestDurations.allValues valueForKeyPath:@"@min.@min.doubleValue"] doubleValue];
//         NSTimeInterval maxDuration = [[self.requestDurations.allValues valueForKeyPath:@"@max.@max.doubleValue"] doubleValue];
        
//         return @{
//             @"totalRequests": @(self.totalRequests),
//             @"averageDuration": @(averageDuration),
//             @"minDuration": @(minDuration),
//             @"maxDuration": @(maxDuration)
//         };
//     }
// }

// - (NSDictionary *)getDetailedNetworkStatistics {
//     @synchronized (self) {
//         NSMutableDictionary *detailedStats = [NSMutableDictionary dictionary];
        
//         for (NSString *path in self.requestDurations.allKeys) {
//             NSArray *durations = self.requestDurations[path];
//             NSTimeInterval totalDuration = [[durations valueForKeyPath:@"@sum.doubleValue"] doubleValue];
//             NSTimeInterval averageDuration = [durations.firstObject doubleValue] > 0 ? totalDuration / durations.count : 0;
//             NSTimeInterval minDuration = [[durations valueForKeyPath:@"@min.doubleValue"] doubleValue];
//             NSTimeInterval maxDuration = [[durations valueForKeyPath:@"@max.doubleValue"] doubleValue];
            
//             detailedStats[path] = @{
//                 @"totalRequests": @(durations.count),
//                 @"averageDuration": @(averageDuration),
//                 @"minDuration": @(minDuration),
//                 @"maxDuration": @(maxDuration)
//             };
//         }
        
//         return detailedStats;
//     }
// }

+ (instancetype)getInstance
{
    return [CDDAPM getPluginInstanceWithTag:[self getTag]];
}

- (void)monitorTask:(NSURLSessionTask *)task withRequest:(NSURLRequest *)request {
    NSString *requestID = [[NSUUID UUID] UUIDString];
    NSString *urlString = [request cddGetURLStringWithoutQuery];
    [self recordStartTimeForRequest:requestID urlString:urlString];
    
    [task addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(requestID)];
}

- (void)monitorTask:(NSURLSessionTask *)task withURL:(NSURL *)url {
    NSString *requestID = [[NSUUID UUID] UUIDString];
    NSString *urlString = [url cddGetURLStringWithoutQuery];
    [self recordStartTimeForRequest:requestID urlString:urlString];
    
    [task addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(requestID)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:[NSURLSessionTask class]] && [keyPath isEqualToString:@"state"]) {
        NSURLSessionTask *task = (NSURLSessionTask *)object;
        NSURLSessionTaskState newState = [change[NSKeyValueChangeNewKey] integerValue];
        
        if (newState == NSURLSessionTaskStateCompleted) {
            NSString *requestID = (__bridge NSString *)context;
            NSString *urlString = [task.originalRequest cddGetURLStringWithoutQuery];
            [self recordEndTimeForRequest:requestID urlString:urlString];
            [task removeObserver:self forKeyPath:@"state"];
        }
    }
}

- (void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))wrapCompletionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler forRequest:(NSURLRequest *)request {
    NSString *requestID = [[NSUUID UUID] UUIDString];
    NSString *urlString = [request cddGetURLStringWithoutQuery];
    [self recordStartTimeForRequest:requestID urlString:urlString];
    
    return ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self recordEndTimeForRequest:requestID urlString:urlString];
        if (completionHandler) {
            completionHandler(data, response, error);
        }
    };
}

- (void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))wrapCompletionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler forURL:(NSURL *)url {
    NSString *requestID = [[NSUUID UUID] UUIDString];
    NSString *urlString = [url cddGetURLStringWithoutQuery];
    [self recordStartTimeForRequest:requestID urlString:urlString];
    
    return ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self recordEndTimeForRequest:requestID urlString:urlString];
        if (completionHandler) {
            completionHandler(data, response, error);
        }
    };
}

@synthesize reportDelegate;

@end
