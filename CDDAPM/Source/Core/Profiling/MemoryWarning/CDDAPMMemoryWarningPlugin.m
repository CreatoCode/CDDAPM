//
//  CDDAPMMemoryWarningPlugin.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/15.
//

#import <UIKit/UIKit.h>
#import "CDDAPMMemoryWarningPlugin.h"
#import "CDDAPMMemoryWarningModel.h"

CDDConstString CDDAPMMemoryWarningPluginTag = @"MemoryWarn";

@interface CDDAPMMemoryWarningPlugin ()

@property (nonatomic, assign) BOOL isMonitoring;

@end

@implementation CDDAPMMemoryWarningPlugin

- (void)destroy {
    
}

+ (NSString * _Nonnull)getTag {
    return (NSString * _Nonnull)CDDAPMMemoryWarningPluginTag;
}

- (BOOL)start {
    if (!self.isMonitoring) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleMemoryWarning:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        self.isMonitoring = YES;
    }
    return true;
}

- (void)stop {
    if (self.isMonitoring) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidReceiveMemoryWarningNotification
                                                      object:nil];
        self.isMonitoring = NO;
    }
}


- (void)handleMemoryWarning:(NSNotification *)notification {
    NSLog(@"Memory warning received with notification: %@", notification);
    if ([self.reportDelegate respondsToSelector:@selector(reportIssue:)]){
        [self.reportDelegate reportIssue:[[CDDAPMMemoryWarningModel alloc] init]];
    }
}

@synthesize reportDelegate;
@end
