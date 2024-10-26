//
//  WKWebview+delegateProxy.m
//  ProxyDelegate
//
//  Created by flashgeek on 2021/7/6.
//

#import <objc/runtime.h>
#import <WebKit/WebKit.h>
#import "UIView+addition.h"
#import "UIViewController+addition.h"

@implementation UIView (addition)
- (UIViewController*)cddViewController
{
    UIResponder *responder = self;
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

+ (UIWindow *)cddCurrentActiveWindow {
    // 获取当前活动的场景
    if (@available(iOS 13.0, *)) {
        NSArray<UIScene *> *scenes = [[UIApplication sharedApplication] connectedScenes].allObjects;
        for (UIWindowScene *scene in scenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
            }
        }
    } else {
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        return keyWindow;
    }
    return nil;
}

- (UIImage *)cddTakeScreenshot 
{
    // 获取当前活动的窗口
    UIWindow *window = [UIView cddCurrentActiveWindow];
    if (!window) {
        return nil;
    }
    
    // 截取当前屏幕
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, 0.0);
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

- (UIImage *)cddTakeScreenshotExcludingNavigationBar {
    // 获取当前活动的窗口
    UIWindow *window = [UIView cddCurrentActiveWindow];
    if (!window) {
        return nil;
    }
    
    // 获取当前视图控制器
    UIViewController *currentViewController = [UIViewController cddCurrentViewController];
    if (!currentViewController) {
        return nil;
    }
    
    // 获取导航栏高度
    CGFloat navigationBarHeight = 0.0;
    if (currentViewController.navigationController) {
        navigationBarHeight = CGRectGetHeight(currentViewController.navigationController.navigationBar.frame);
    }
    
    // 计算截图区域
    CGRect screenshotFrame = CGRectMake(0, navigationBarHeight, window.bounds.size.width, window.bounds.size.height - navigationBarHeight);
    
    // 截取当前屏幕
    UIGraphicsBeginImageContextWithOptions(screenshotFrame.size, NO, 0.0);
    [window drawViewHierarchyInRect:screenshotFrame afterScreenUpdates:YES];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}


-(CGFloat) cddNavigationBarHeight
{
    CGFloat statusBarHeight =  [[UIApplication sharedApplication] statusBarFrame].size.height; //状态栏高度
    CGFloat navigationHeight = CGRectGetHeight(self.cddViewController.navigationController.navigationBar.frame); //导航栏高度
    return navigationHeight;
}

-(CGFloat)navigationBarAndStatusBarTotalHeight
{
    // 获取当前视图控制器
    UIViewController *currentViewController = [UIViewController cddCurrentViewController];
    
    // 获取状态栏高度
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    // 获取导航栏高度
    CGFloat navigationBarHeight = 0.0;
    if (currentViewController && currentViewController.navigationController) {
        navigationBarHeight = CGRectGetHeight(currentViewController.navigationController.navigationBar.frame);
    }
    
    // 返回总高度
    return statusBarHeight + navigationBarHeight;
}

@end
