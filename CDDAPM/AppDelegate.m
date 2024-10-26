//
//  AppDelegate.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/11.
//

#import "AppDelegate.h"
#import "CDDAPM.h"
#import "CDDAPMZobimePlugin.h"
#import "CDDAPMZobimeTest.h"
#import "CDDNetworkRequestTest.h"

@interface AppDelegate ()
@property(strong)CDDAPMZobimePlugin* zombime;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    CDDAPMLogDebug(@"sizeof NSUInterger:%lu", sizeof(NSUInteger));
    [CDDNetworkRequestTest run];
//    CDDAPMZobime* zombime = [[CDDAPMZobime alloc] init];
//    [zombime start];
//    [CDDAPMZobimeTest run];
//    self.zombime = zombime;
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
