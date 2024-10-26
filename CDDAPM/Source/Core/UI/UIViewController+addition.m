//
//  WKWebview+delegateProxy.m
//  ProxyDelegate
//
//  Created by flashgeek on 2021/7/6.
//

#import <objc/runtime.h>
#import <WebKit/WebKit.h>
#import "UIViewController+addition.h"
#import "UIView+addition.h"

@implementation UIViewController (addition)
+ (UIViewController *)cddCurrentViewController
{
    // 获取当前活动的窗口
    UIWindow *window = [UIView cddCurrentActiveWindow];
    if (!window) {
        return nil;
    }
    
    // 获取当前视图控制器
    UIViewController *rootViewController = window.rootViewController;
    UIViewController *currentViewController = [self cddTopMostViewController:rootViewController];
    return currentViewController;
}

+ (UIViewController *)cddTopMostViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController) {
        return [self cddTopMostViewController:rootViewController.presentedViewController];
    }
    
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)rootViewController;
        return [self cddTopMostViewController:navController.visibleViewController];
    }
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self cddTopMostViewController:tabBarController.selectedViewController];
    }
    
    return rootViewController;
}

@end
