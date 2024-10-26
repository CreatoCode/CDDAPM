//
//  CDDAPMLag.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/11.
//

#import "CDDAPMFreezesPlugin.h"
#import "CDDAPMFreezesModel.h"

CDDConstString CDDAPMFreezesPluginTag = @"Freezes";

@interface CDDAPMFreezesPlugin()
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) CFRunLoopObserverRef observer;
@property (nonatomic, assign) NSTimeInterval lagThreshold;
@property (nonatomic, strong) dispatch_queue_t lagQueue;
@property (nonatomic, assign) BOOL isMonitoring;
@end



@implementation CDDAPMFreezesPlugin
@synthesize reportDelegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        _lagThreshold = 0.2; // 默认卡顿阈值为0.2秒
        _semaphore = dispatch_semaphore_create(1);
        _lagQueue = dispatch_queue_create("com.yourapp.lagmonitor", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)addObserver
{
    if (self.isMonitoring) {
        return;
    }
    
    self.isMonitoring = YES;
    
    // 创建观察者
    CFRunLoopObserverContext context = {0, (__bridge void*)self, NULL, NULL, NULL};
    self.observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallback, &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), self.observer, kCFRunLoopCommonModes);
    
    // 在子线程中开始监控
    dispatch_async(self.lagQueue, ^{
        while (self.isMonitoring) {
            long semaphoreWait = dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.lagThreshold * NSEC_PER_SEC)));
            dispatch_semaphore_signal(self.semaphore);
            if (semaphoreWait != 0) {
                if (!self.isMonitoring) {
                    return;
                }
                [self handleLag];
            }
            
        }
    });
}

- (BOOL)start {
    [self addObserver];
    return YES;
}

- (void)stop {
    if (!self.isMonitoring) {
        return;
    }
    
    self.isMonitoring = NO;
    
    if (self.observer) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.observer, kCFRunLoopCommonModes);
        CFRelease(self.observer);
        self.observer = NULL;
    }
    
    dispatch_semaphore_signal(self.semaphore);
}

- (void)handleLag {
    if ([self.reportDelegate respondsToSelector:@selector(reportIssue:)]) {
        CDDAPMFreezesModel *model = [[CDDAPMFreezesModel alloc] init];
        [self.reportDelegate reportIssue:model];
    }
}

+ (NSString *_Nonnull)getTag
{
    return (NSString *)CDDAPMFreezesPluginTag;
}

- (void)destroy { 
    
}


- (NSString *)getMainThreadCallStack {
//    PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:[PLCrashReporterConfig defaultConfiguration]];
//    NSData *data = [crashReporter generateLiveReport];
//    PLCrashReport *report = [[PLCrashReport alloc] initWithData:data error:NULL];
//    NSString *reportString = [PLCrashReportTextFormatter stringValueForCrashReport:report withTextFormat:PLCrashReportTextFormatiOS];
//    
//    return reportString;
    return nil;
}

static void runLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
//    PerformanceMonitor *monitor = (__bridge PerformanceMonitor*)info;
//    dispatch_semaphore_signal(monitor.semaphore);
}
@end
