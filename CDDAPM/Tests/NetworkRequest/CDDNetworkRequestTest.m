//
//  CDDNetworkRequestTest.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/14.
//

#import "CDDAPMLogger.h"
#import "CDDNetworkRequestTest.h"

@implementation CDDNetworkRequestTest
+ (void)run
{
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        CDDAPMLogDebug(@"response:%@, error:%@", response, error);
    }];
    [task resume];
}
@end
