//
//  CDDAPMLogger.h
//  CDDAPM
//
//  Created by flashgeek on 2024/10/15.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CDDAPMLogLevel) {
    CDDAPMLogLevelDebug,
    CDDAPMLogLevelInfo,
    CDDAPMLogLevelWarning,
    CDDAPMLogLevelError
};

NS_ASSUME_NONNULL_BEGIN

@interface CDDAPMLogger : NSObject

+ (instancetype)sharedInstance;

- (void)setLogLevel:(CDDAPMLogLevel)level;
- (void)logWithLevel:(CDDAPMLogLevel)level file:(const char *)file function:(const char *)function line:(int)line format:(NSString *)format arguments:(va_list)args;

// 便捷方法
- (void)debug:(const char *)file function:(const char *)function line:(int)line format:(NSString *)format, ...;
- (void)info:(const char *)file function:(const char *)function line:(int)line format:(NSString *)format, ...;
- (void)warning:(const char *)file function:(const char *)function line:(int)line format:(NSString *)format, ...;
- (void)error:(const char *)file function:(const char *)function line:(int)line format:(NSString *)format, ...;

@end

#ifdef DEBUG
#define CDDAPMLogDebug(format, ...) [[CDDAPMLogger sharedInstance] debug:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__ format:format, ##__VA_ARGS__]
#define CDDAPMLogInfo(format, ...) [[CDDAPMLogger sharedInstance] info:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__ format:format, ##__VA_ARGS__]
#define CDDAPMLogWarning(format, ...) [[CDDAPMLogger sharedInstance] warning:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__ format:format, ##__VA_ARGS__]
#define CDDAPMLogError(format, ...) [[CDDAPMLogger sharedInstance] error:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__ format:format, ##__VA_ARGS__]
#else
// In non-DEBUG mode, these macros do nothing
#define CDDAPMLogDebug(format, ...)
#define CDDAPMLogInfo(format, ...)
#define CDDAPMLogWarning(format, ...)
#define CDDAPMLogError(format, ...)
#endif

NS_ASSUME_NONNULL_END
