//
//  WKWebview+delegateProxy.h
//  ProxyDelegate
//
//  Created by flashgeek on 2021/7/6.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIView (addition)
@property(readonly, assign)CGFloat cddNavigationBarHeight;
@property(readonly, assign)CGFloat navigationBarAndStatusBarTotalHeight;
- (UIViewController*)cddViewController;
- (UIImage *)cddTakeScreenshot;
- (UIImage *)cddTakeScreenshotExcludingNavigationBar;
+ (UIWindow *)cddCurrentActiveWindow;
@end

NS_ASSUME_NONNULL_END
