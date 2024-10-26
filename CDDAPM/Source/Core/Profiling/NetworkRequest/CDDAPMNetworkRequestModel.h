//
//  CDDAPMNetworkRequestModel.h
//  CDDAPM
//
//  Created by flashgeek on 2024/10/15.
//

#import <Foundation/Foundation.h>
#import "CDDAPMCoreTypes.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDDAPMNetworkRequestModel :NSObject<CDDAPMPIssueModelProtocol>
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSTimeInterval duration;
@end

NS_ASSUME_NONNULL_END
