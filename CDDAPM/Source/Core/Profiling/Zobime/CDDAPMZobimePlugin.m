//
//  CDDAPMZobime.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/11.
//

//#import <objc/runtime.h>
//#import <objc/message.h>
#import "CDDAPMZobimePlugin.h"
#import "DDZombieMonitor.h"

@implementation CDDAPMZobimePlugin
@synthesize reportDelegate;

- (BOOL)start
{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//    });
//    return true;
    [[DDZombieMonitor sharedInstance] startMonitor];
    return true;
}

- (void)stop
{
    [[DDZombieMonitor sharedInstance] stopMonitor];
}

- (void)destroy
{
    
}

+ (NSString *)getTag
{
    return @"Zobime";
}

@end
