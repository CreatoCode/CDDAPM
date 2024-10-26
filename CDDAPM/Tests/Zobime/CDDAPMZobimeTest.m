//
//  CDDAPMZobimeTest.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/11.
//

#import "CDDAPMZobimeTest.h"
#import "CDDAPMLogger.h"


@implementation CDDAPMZobimeTest
- (void)go
{
    CDDAPMLogDebug(@"go:%@", self);
}
+ (void)run
{
    CDDAPMZobimeTest *test = [[CDDAPMZobimeTest alloc] init];
    [test release];
    [test go];
}
@end
