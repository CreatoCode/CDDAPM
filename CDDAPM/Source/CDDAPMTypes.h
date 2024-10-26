//
//  CDDAPMProfilingTypes.h
//  CDDAPMProfiling
//
//  Created by flashgeek on 2024/10/11.
//

#ifndef CDDAPMProfilingTypes_h
#define CDDAPMProfilingTypes_h

typedef NS_OPTIONS(NSUInteger, CDDAPMProfilingProfiling) {
    CDDAPMProfilingAppLaunchTime = 1 << 0,      // 应用启动时间
    CDDAPMProfilingFreezes = CDDAPMProfilingAppLaunchTime << 1,  // 卡顿
    CDDAPMProfilingFrameRate = CDDAPMProfilingFreezes << 1,      // 帧率（FPS）
    CDDAPMProfilingZobime = CDDAPMProfilingFrameRate << 1,       // 僵尸对象/野指针
    CDDAPMProfilingWhiteScreen = CDDAPMProfilingZobime << 1,     // 白屏
    CDDAPMProfilingMemoryUsage = CDDAPMProfilingWhiteScreen << 1, // 内存使用量
    CDDAPMProfilingCPUUsage = CDDAPMProfilingMemoryUsage << 1,    // CPU 使用率
    CDDAPMProfilingNetworkError = CDDAPMProfilingCPUUsage << 1,   // 网络请求失败
    CDDAPMProfilingNetworkLatency = CDDAPMProfilingNetworkError << 1, // 网络延迟
    CDDAPMProfilingNetworkThroughput = CDDAPMProfilingNetworkLatency << 1, // 网络吞吐量
    CDDAPMProfilingNetworkRequestTime = CDDAPMProfilingNetworkThroughput << 1, // 网络请求时间
    CDDAPMProfilingNetworkRequestCount = CDDAPMProfilingNetworkRequestTime << 1, // 网络请求数量
    CDDAPMProfilingDiskIO = CDDAPMProfilingNetworkRequestCount << 1, // 磁盘 I/O
    CDDAPMProfilingFileReadTime = CDDAPMProfilingDiskIO << 1, // 文件读取时间
    CDDAPMProfilingFileWriteTime = CDDAPMProfilingFileReadTime << 1, // 文件写入时间
    CDDAPMProfilingThreadCount = CDDAPMProfilingFileWriteTime << 1, // 线程数量
    CDDAPMProfilingWebViewLoadTime = CDDAPMProfilingThreadCount << 1, // WebView 加载时间
    CDDAPMProfilingBatteryLevel = CDDAPMProfilingWebViewLoadTime << 1, // 电池电量
    CDDAPMProfilingSystemMemoryWarning = CDDAPMProfilingBatteryLevel << 1, // 系统内存警告次数
    CDDAPMProfilingMethodExecutionTime = CDDAPMProfilingSystemMemoryWarning << 1, // 方法耗时
    CDDAPMProfilingMemoryLeak = CDDAPMProfilingMethodExecutionTime << 1, // 内存泄露
    CDDAPMProfilingAll = 0xFFFFFFFF, // 所有插件
};


typedef const NSString* CDDConstString;

#endif /* CDDAPMProfilingTypes_h */


