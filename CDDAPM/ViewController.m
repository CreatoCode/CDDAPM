//
//  ViewController.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/11.
//

#import "ViewController.h"
#import "CDDAWhiteScreenTestWebViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CDDAWhiteScreenTestWebViewController* webView = [[CDDAWhiteScreenTestWebViewController alloc] init];
    // [self.navigationController pushViewController:webView animated:YES];
    [self presentViewController:webView animated:YES completion:nil];
}
@end
