//
//  CDDAPMCoreTypes.h
//  CDDAPM
//
//  Created by flashgeek on 2024/10/11.
//

#ifndef CDDAPMCoreTypes_h
#define CDDAPMCoreTypes_h

typedef NS_ENUM(NSUInteger, CDDAPMPIssueDataType) {
    CDDAPMPIssueDataType_Unknown = 0,
    CDDAPMPIssueDataType_Data = 1,
    CDDAPMPIssueDataType_FilePath = 2,
};

@protocol CDDAPMPIssueModelProtocol <NSObject>
@property (readonly, nonatomic, assign) CDDAPMPIssueDataType dataType;
@property (readonly, nonatomic, copy, nonnull) NSString *tag;
- (NSDictionary*_Nonnull)jsonData;
@end


@protocol CDDAPMPluginReportProtocol <NSObject>
- (void)reportIssue:(id<CDDAPMPIssueModelProtocol>_Nullable)issue;
@end

//@protocol CDDAPMPluginStrategyProtocol
//@end

@protocol CDDAPMPluginProtocol <NSObject>

@property(weak, nonatomic)id<CDDAPMPluginReportProtocol> _Nullable reportDelegate;

@required

- (BOOL)start;

- (void)stop;

- (void)destroy;

+ (NSString *_Nonnull)getTag;

@end

#endif /* CDDAPMCoreTypes_h */
