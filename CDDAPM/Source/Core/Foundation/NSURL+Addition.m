//
//  NSURLRequest+Addition.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/14.
//

#import "NSURL+Addition.h"

@implementation NSURL(Addition)
- (NSString *)cddGetURLStringWithoutQuery {
    NSURLComponents *components = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO];
    components.query = nil;  // 移除 query 参数
    components.fragment = nil;  // 移除 fragment
    return components.string;
}
@end
