//
//  CDDAWhiteScreenTestWebView.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/14.
//

#import "CDDAWhiteScreenTestWebViewController.h"

@interface CDDAWhiteScreenTestWebViewController ()<WKNavigationDelegate>
@property(strong) WKWebView* webView;
@end

@implementation CDDAWhiteScreenTestWebViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    NSURL *local = [NSURL fileURLWithPath:@"/Users/linjinxing493/workspace/Madlab/develop/code/demo/code-demos/html/empty.html"];
//    NSURL *internet = [NSURL URLWithString:@"https://www.baidu.com/"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:local]];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"webView didFinishNavigation");
}

@end
