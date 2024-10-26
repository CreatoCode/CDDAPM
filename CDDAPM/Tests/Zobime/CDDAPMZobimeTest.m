//
//  CDDAPMZobimeTest.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/11.
//

#import "CDDAPMZobimeTest.h"

@implementation CDDAPMZobimeTest
- (void)go
{
    NSLog(@"go:%@", self);
}
+ (void)run
{
    CDDAPMZobimeTest *test = [[CDDAPMZobimeTest alloc] init];
    [test release];
    [test go];
}
@end
