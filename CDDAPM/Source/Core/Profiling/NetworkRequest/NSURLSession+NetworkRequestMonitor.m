//
//  WKWebview+delegateProxy.m
//  ProxyDelegate
//
//  Created by flashgeek on 2021/7/6.
//

#import "CDDAPMRuntime.h"
#import "NSURLSession+NetworkRequestMonitor.h"
#import "CDDAPMNetworkRequestPlugin.h"
#import "NSURLRequest+Addition.h"
#import "CDDAPM.h"

@implementation NSURLSession (NetworkRequestMonitor)
+ (void)cddStartNetworkRequestMonitor
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cddapm_exchangeMethod(self, @selector(sessionWithConfiguration:), self, @selector(cddapm_sessionWithConfiguration:));
        cddapm_exchangeMethod(self, @selector(sessionWithConfiguration:delegate:delegateQueue:), self,  @selector(cddapm_sessionWithConfiguration:delegate:delegateQueue:));
        cddapm_exchangeMethod(self, @selector(dataTaskWithRequest:), self, @selector(cddapm_dataTaskWithRequest:));
        cddapm_exchangeMethod(self, @selector(dataTaskWithURL:), self, @selector(cddapm_dataTaskWithURL:));
        cddapm_exchangeMethod(self, @selector(dataTaskWithRequest:completionHandler:), self, @selector(cddapm_dataTaskWithRequest:completionHandler:));
        cddapm_exchangeMethod(self, @selector(dataTaskWithURL:completionHandler:), self, @selector(cddapm_dataTaskWithURL:completionHandler:));
    });
}

+ (NSURLSession *)cddapm_sessionWithConfiguration:(NSURLSessionConfiguration *)configuration {
    NSURLSession *session = [self cddapm_sessionWithConfiguration:configuration];
    // 可以在这里对 session 进行额外的配置
    return session;
}

+ (NSURLSession *)cddapm_sessionWithConfiguration:(NSURLSessionConfiguration *)configuration delegate:(nullable id<NSURLSessionDelegate>)delegate delegateQueue:(nullable NSOperationQueue *)queue {
    NSURLSession *session = [self cddapm_sessionWithConfiguration:configuration delegate:delegate delegateQueue:queue];
    // 可以在这里对 session 进行额外的配置
    return session;
}

- (NSURLSessionDataTask *)cddapm_dataTaskWithRequest:(NSURLRequest *)request {
    NSURLSessionDataTask *task = [self cddapm_dataTaskWithRequest:request];
    [[CDDAPMNetworkRequestPlugin getInstance] monitorTask:task withRequest:request];
    return task;
}

- (NSURLSessionDataTask *)cddapm_dataTaskWithURL:(NSURL *)url {
    NSURLSessionDataTask *task = [self cddapm_dataTaskWithURL:url];
    [[CDDAPMNetworkRequestPlugin getInstance] monitorTask:task withURL:url];
    return task;
}

- (NSURLSessionDataTask *)cddapm_dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    return [self cddapm_dataTaskWithRequest:request completionHandler:[[CDDAPMNetworkRequestPlugin getInstance] wrapCompletionHandler:completionHandler forRequest:request]];
}

- (NSURLSessionDataTask *)cddapm_dataTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    return [self cddapm_dataTaskWithURL:url completionHandler:[[CDDAPMNetworkRequestPlugin getInstance] wrapCompletionHandler:completionHandler forURL:url]];
}

//- (NSURLSessionDataTask *)cddDataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
//    NSString *requestID = [[NSUUID UUID] UUIDString];
//    NSString *urlString = [request cddGetURLStringWithoutQuery];
//    CDDAPMNetworkRequestPlugin* plugin = [CDDAPM getPluginInstanceWithTag:[CDDAPMNetworkRequestPlugin getTag]];
//    [plugin recordStartTimeForRequest:requestID urlString:urlString];
//    
//    return [self cddDataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        [plugin recordEndTimeForRequest:requestID urlString:urlString];
//        
//        if (completionHandler) {
//            completionHandler(data, response, error);
//        }
//    }];
//}



@end
