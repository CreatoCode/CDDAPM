//
//  CDDAPMAppLaunchTime.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/11.
//

#import <sys/sysctl.h>
#import "CDDAPMAppLaunchTimePlugin.h"
#import "CDDAPMAppLaunchTimeModel.h"

NSString *const CDDAPMAppLaunchTimePluginTag = @"AppLaunchTime"; 

static CFAbsoluteTime s_processStartTime;
static CFAbsoluteTime s_firstFrameRenderTime;

@interface CDDAPMAppLaunchTimePlugin()

@end

#define MIB_SIZE 2

@implementation CDDAPMAppLaunchTimePlugin
@synthesize reportDelegate;

+ (CFAbsoluteTime)processStartTime {
    if (s_processStartTime == 0) {
        struct kinfo_proc procInfo;
        int pid = [[NSProcessInfo processInfo] processIdentifier];
        int cmd[4] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, pid};
        size_t size = sizeof(procInfo);
        if (sysctl(cmd, sizeof(cmd)/sizeof(*cmd), &procInfo, &size, NULL, 0) == 0) {
            // 创建一个 NSDate 对象，表示当前时间
            NSTimeInterval tmp = procInfo.kp_proc.p_un.__p_starttime.tv_sec;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:tmp];
            // 输出本地时间
            NSLog(@"process start time: %@", date);
            s_processStartTime = tmp ;
            //* 1000.0 + procInfo.kp_proc.p_un.__p_starttime.tv_usec / 1000.0;
        }
    }
    return s_processStartTime;
}

- (void)firstFrame
{
    // Timers
    CFRunLoopRef mainRunloop = [[NSRunLoop mainRunLoop] getCFRunLoop];
    CFRunLoopActivity activities = kCFRunLoopAllActivities;
    if (@available(iOS 13.0, *)) {
        CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, activities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
            if (activity == kCFRunLoopBeforeTimers) {
                s_firstFrameRenderTime = CFAbsoluteTimeGetCurrent();
                NSLog(@"----------App启动---------BeforeTimers时间: %@",@(s_firstFrameRenderTime));
                CFRunLoopRemoveObserver(mainRunloop, observer, kCFRunLoopCommonModes);
                [self report];
            }
        });
        CFRunLoopAddObserver(mainRunloop, observer, kCFRunLoopCommonModes);
    } else {
        // block
        CFRunLoopPerformBlock(mainRunloop,NSDefaultRunLoopMode,^(){
            s_firstFrameRenderTime = CFAbsoluteTimeGetCurrent();
            NSLog(@"----------App启动---------PerformBlock时间: %@",@(s_firstFrameRenderTime));
            [self report];
        });
    }


}

- (void)report
{
    if ([self.reportDelegate respondsToSelector:@selector(reportIssue:)]) {
        CDDAPMAppLaunchTimeModel *model = [[CDDAPMAppLaunchTimeModel alloc] init];
        model.processStartTime = s_processStartTime;
        model.firstFrameRenderTime = s_firstFrameRenderTime;
        NSTimeInterval diff = s_firstFrameRenderTime - [[NSDate dateWithTimeIntervalSince1970:s_processStartTime] timeIntervalSinceReferenceDate];
        NSLog(@"diff:%@", @(diff));
        [self.reportDelegate reportIssue:model];
    }
}

- (BOOL)start
{
    [[self class] processStartTime];
    [self firstFrame];
    return true;
}

- (void)stop
{
    
}

- (void)destroy
{
    
}

+ (NSString *)getTag
{
    return CDDAPMAppLaunchTimePluginTag;
}



@end
