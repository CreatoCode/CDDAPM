//
//  CDDAPMLogger.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/15.
//

#import "CDDAPMLogger.h"

@interface CDDAPMLogger ()

@property (nonatomic, assign) CDDAPMLogLevel currentLogLevel;

@end

@implementation CDDAPMLogger

+ (instancetype)sharedInstance {
    static CDDAPMLogger *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentLogLevel = CDDAPMLogLevelInfo; // 默认日志级别
    }
    return self;
}

- (void)setLogLevel:(CDDAPMLogLevel)level {
    self.currentLogLevel = level;
}

- (void)logWithLevel:(CDDAPMLogLevel)level file:(const char *)file function:(const char *)function line:(int)line format:(NSString *)format arguments:(va_list)args {
    if (level < self.currentLogLevel) {
        return;
    }
    
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    
    NSString *levelString;
    switch (level) {
        case CDDAPMLogLevelDebug:
            levelString = @"DEBUG";
            break;
        case CDDAPMLogLevelInfo:
            levelString = @"INFO";
            break;
        case CDDAPMLogLevelWarning:
            levelString = @"WARNING";
            break;
        case CDDAPMLogLevelError:
            levelString = @"ERROR";
            break;
    }
    
    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
    NSLog(@"[CDDAPM] [%@] %@:%d %s | %@", levelString, fileName, line, function, message);
}

- (void)debug:(const char *)file function:(const char *)function line:(int)line format:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [self logWithLevel:CDDAPMLogLevelDebug file:file function:function line:line format:format arguments:args];
    va_end(args);
}

- (void)info:(const char *)file function:(const char *)function line:(int)line format:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [self logWithLevel:CDDAPMLogLevelInfo file:file function:function line:line format:format arguments:args];
    va_end(args);
}

- (void)warning:(const char *)file function:(const char *)function line:(int)line format:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [self logWithLevel:CDDAPMLogLevelWarning file:file function:function line:line format:format arguments:args];
    va_end(args);
}

- (void)error:(const char *)file function:(const char *)function line:(int)line format:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [self logWithLevel:CDDAPMLogLevelError file:file function:function line:line format:format arguments:args];
    va_end(args);
}

@end
