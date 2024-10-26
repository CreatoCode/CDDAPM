//
//  CDDAPMFrameRate.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/11.
//

#import <UIKit/UIKit.h>
#import <pthread/pthread.h>
#import "CDDAPMFrameRatePlugin.h"
#import "CDDAPMFrameRateModel.h"

CDDConstString CDDAPMFrameRatePluginTag = @"FrameRate";

@interface CDDAPMFrameRatePlugin ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSUInteger frameCount;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) CGFloat currentFPS;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *fpsHistory;
@property (nonatomic, assign) CGFloat maxRefreshRate;
@end

@implementation CDDAPMFrameRatePlugin
@synthesize reportDelegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        _fpsHistory = [NSMutableArray arrayWithCapacity:6]; // 存储最近6帧的FPS (100ms / 60Hz ≈ 6)
        _maxRefreshRate = [self getMaxRefreshRate];
    }
    return self;
}

+ (NSString *)getTag
{
    return (NSString *)CDDAPMFrameRatePluginTag;
}

- (BOOL)start {
    if (self.displayLink) {
        return true;
    }
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    return true;
}

- (void)stop {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)displayLinkTick:(CADisplayLink *)link {
    if (self.lastTime == 0) {
        self.lastTime = link.timestamp;
        return;
    }
    
    self.frameCount++;
    NSTimeInterval interval = link.timestamp - self.lastTime;
    if (interval < 1) {
        return;
    }
    
    self.currentFPS = self.frameCount / interval;
    [self.fpsHistory addObject:@(self.currentFPS)];
    if (self.fpsHistory.count > 6) {
        [self.fpsHistory removeObjectAtIndex:0];
    }
    
    self.frameCount = 0;
    self.lastTime = link.timestamp;
    
    [self checkFrameRateLevel];
    // 使用 GCD 异步调用 fpsHandler，避免阻塞主线程
//    if (self.fpsHandler) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.fpsHandler(self.currentFPS);
//        });
//    }
}

- (CGFloat)getMaxRefreshRate {
    if (@available(iOS 10.3, *)) {
        return [UIScreen mainScreen].maximumFramesPerSecond;
    } else {
        return 60.0;
    }
}

- (void)checkFrameRateLevel {
    if (self.fpsHistory.count < 6) {
        return; // 等待收集足够的数据
    }
    
    CGFloat averageFPS = [[self.fpsHistory valueForKeyPath:@"@avg.self"] floatValue];
    CGFloat normalThreshold = self.maxRefreshRate * 0.8; // 80% of max refresh rate
    CGFloat mildThreshold = self.maxRefreshRate * 0.67; // ~40fps for 60Hz, ~80fps for 120Hz
    CGFloat moderateThreshold = self.maxRefreshRate * 0.5; // 30fps for 60Hz, 60fps for 120Hz
    
    CDDAPMFrameRateLevel level;
    
    if (averageFPS > normalThreshold) {
//        level = CDDAPMFrameRateLevelNormal;
        return;
    } else if (averageFPS > mildThreshold) {
        level = CDDAPMFrameRateLevelMild;
    } else if (averageFPS > moderateThreshold) {
        level = CDDAPMFrameRateLevelModerate;
    } else {
        level = CDDAPMFrameRateLevelSevere;
    }
    
    if (level != CDDAPMFrameRateLevelNormal) {
        if ([self.reportDelegate respondsToSelector:@selector(reportIssue:)]) {
            CDDAPMFrameRateModel *model = [[CDDAPMFrameRateModel alloc] init];
            model.FPS = averageFPS;
            model.level = level;
            [self.reportDelegate reportIssue:model];
        }
    }
}

- (void)destroy
{
    [self stop];
}


@end
