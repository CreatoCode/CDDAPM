//
//  CDDAPMNetworkRequestPlugin.h
//  CDDAPM
//
//  Created by flashgeek on 2024/10/14.
//

#import <Foundation/Foundation.h>
#import "CDDAPMTypes.h"
#import "CDDAPMCoreTypes.h"

FOUNDATION_EXTERN CDDConstString CDDAPMNetworkRequestPluginTag;

NS_ASSUME_NONNULL_BEGIN

@interface CDDAPMNetworkRequestPlugin : NSObject<CDDAPMPluginProtocol>
- (void)recordStartTimeForRequest:(NSString *)requestID urlString:(NSString *)path;
- (void)recordEndTimeForRequest:(NSString *)requestID urlString:(NSString *)path;
//- (NSDictionary *)getNetworkStatistics;
//- (NSDictionary *)getDetailedNetworkStatistics;

+ (instancetype)getInstance;

- (void)monitorTask:(NSURLSessionTask *)task withRequest:(NSURLRequest *)request;
- (void)monitorTask:(NSURLSessionTask *)task withURL:(NSURL *)url;
- (void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))wrapCompletionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler forRequest:(NSURLRequest *)request;
- (void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))wrapCompletionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler forURL:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
