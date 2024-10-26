//
//  CDDAPMWhiteScreen.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/13.
//

#import "CDDAPMWhiteScreenPlugin.h"

#import "WKWebview+CDDAPMWhiteScreen.h"
#import "UIViewController+WhiteScreen.h"

CDDConstString CDDAPMWhiteScreenPluginTag = @"WhiteScreen";

@implementation CDDAPMWhiteScreenPlugin
- (BOOL)start
{
    [WKWebView cddStartWhiteScreenMonitor];
    [UIViewController cddStartWhiteScreenMonitor];
    return true;
}

- (void)stop
{
    
}

- (void)destroy { 
    
}


+ (NSString * _Nonnull)getTag { 
    return CDDAPMWhiteScreenPluginTag;
}

@synthesize reportDelegate;

@end
