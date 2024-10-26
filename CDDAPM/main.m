//
//  main.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/11.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CDDAPM.h"

int main(int argc, char * argv[]) {
    [[CDDAPM sharedInstance] appDidLaunch];
    [[CDDAPM sharedInstance] startPlugins:CDDAPMProfilingAll];
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
