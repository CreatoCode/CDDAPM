//
//  WKWebview+delegateProxy.m
//  ProxyDelegate
//
//  Created by flashgeek on 2021/7/6.
//

#import <objc/runtime.h>
#import <WebKit/WebKit.h>

#import "WKWebview+CDDAPMWhiteScreen.h"
#import "CDDAPMRuntime.h"
#import "UIView+addition.h"
#import "CDDAPMImageDetection.h"
#import "CDDAPMWhiteScreenPlugin.h"
#import "CDDAPMWhiteScreenModel.h"
#import "CDDAPM.h"


@implementation WKWebView (delegateProxy)

+ (void)cddStartWhiteScreenMonitor
{
    @synchronized (self) {
        Method originalMethod = class_getInstanceMethod([WKWebView class], @selector(setNavigationDelegate:));
         Method swizzledMethod = class_getInstanceMethod([WKWebView class], @selector(cddSetNavigationDelegate:));
         method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
- (void)cddSetNavigationDelegate:(id<WKNavigationDelegate>)delegate{
    [self cddSetNavigationDelegate:delegate];
    // 获得delegate的实际调用类
    Class aClass = [delegate class];
    // 传递给HookWebViewDelegateMonitor来交互方法
    //    cddapm_exchangeMethod(aClass, @selector(webViewDidStartLoad:), [self class], @selector(replace_webViewDidStartLoad:));
        cddapm_exchangeMethod(aClass, @selector(webView:didFinishNavigation:), [self class], @selector(cddWebView:didFinishNavigation:));
    //    cddapm_exchangeMethod(aClass, @selector(webView:didFailLoadWithError:), [self class], @selector(replace_webView:didFailLoadWithError:));
    //    cddapm_exchangeMethod(aClass, @selector(webView:shouldStartLoadWithRequest:navigationType:), [self class], @selector(replace_webView:shouldStartLoadWithRequest:navigationType:));
}

// 交换后的具体方法实现
- (void)cddWebView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    CDDAPMLogDebug(@"replaced_webView-shouldStartLoadWithRequest, webView:%@", webView);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat statusBarAndnavigationHeight = webView.navigationBarAndStatusBarTotalHeight; //状态栏高度
        WKSnapshotConfiguration *shotConfiguration = [[WKSnapshotConfiguration alloc] init];
        shotConfiguration.rect = CGRectMake(0, statusBarAndnavigationHeight, webView.bounds.size.width, (webView.bounds.size.height - statusBarAndnavigationHeight));
        NSString *url = webView.URL.absoluteString;
        [webView takeSnapshotWithConfiguration:shotConfiguration completionHandler:^(UIImage * _Nullable snapshotImage, NSError * _Nullable error) {
            if (error) {
                CDDAPMLogDebug(@"截图失败: %@", error);
            } else {
                [CDDAPMImageDetection haveWhiteScreen:snapshotImage completion:^(BOOL isWhiteScreen, NSError* error) {
                    if (!error && isWhiteScreen) {
                        CDDAPMWhiteScreenPlugin* plugin = [CDDAPM getPluginInstanceWithTag:[CDDAPMWhiteScreenPlugin getTag]];
                        if ([plugin.reportDelegate respondsToSelector:@selector(reportIssue:)]) {
                            CDDAPMWhiteScreenModel *model = [CDDAPMWhiteScreenModel new];
                            model.viewController = NSStringFromClass(self.cddViewController.class);
                            model.url = url;
                            [plugin.reportDelegate reportIssue:model];
                        }
                    }
                }];
            }
        }];
    });
    return [self cddWebView:webView didFinishNavigation:navigation];
}

@end
