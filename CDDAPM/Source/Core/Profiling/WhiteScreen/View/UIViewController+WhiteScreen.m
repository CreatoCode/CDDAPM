//
//  WKWebview+delegateProxy.m
//  ProxyDelegate
//
//  Created by flashgeek on 2021/7/6.
//

#import "CDDAPMRuntime.h"
#import "UIViewController+WhiteScreen.h"
#import "UIView+addition.h"
#import "CDDAPMImageDetection.h"
#import "CDDAPMWhiteScreenPlugin.h"
#import "CDDAPMWhiteScreenModel.h"
#import "CDDAPM.h"

@implementation UIViewController (WhiteScreen)
+ (void)cddStartWhiteScreenMonitor
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cddapm_exchangeMethod([UIViewController class], @selector(viewDidAppear:), [UIViewController class], @selector(cddWhiteScreenMonitorViewDidAppear:));
    });
}

- (void)cddWhiteScreenMonitorViewDidAppear:(BOOL)animated
{
    [self cddWhiteScreenMonitorViewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImage * screenshot = [self.view cddTakeScreenshotExcludingNavigationBar];
        if (screenshot) {
            [CDDAPMImageDetection haveWhiteScreen:screenshot completion:^(BOOL isWhiteScreen, NSError* error) {
                if (!error && isWhiteScreen) {
                    CDDAPMWhiteScreenPlugin* plugin = [CDDAPM getPluginInstanceWithTag:[CDDAPMWhiteScreenPlugin getTag]];
                    if ([plugin.reportDelegate respondsToSelector:@selector(reportIssue:)]) {
                        CDDAPMWhiteScreenModel *model = [CDDAPMWhiteScreenModel new];
                        model.viewController = NSStringFromClass(self.class);
                        [plugin.reportDelegate reportIssue:model];
                    }
                }
            }];
        }
    });
}

@end
