//
//  NSURLRequest+Addition.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/14.
//

#import "NSURLRequest+Addition.h"
#import "NSURL+Addition.h"

@implementation NSURLRequest(Addition)
- (NSString *)cddGetURLStringWithoutQuery {
    return [self.URL cddGetURLStringWithoutQuery];
}
@end
