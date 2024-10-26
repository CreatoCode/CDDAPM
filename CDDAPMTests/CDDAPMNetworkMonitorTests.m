#import <XCTest/XCTest.h>
#import "CDDAPMNetworkRequestPlugin.h"

@interface CDDAPMNetworkMonitorTests : XCTestCase
@property(nonatomic, strong)CDDAPMNetworkRequestPlugin *plugin;
@end

@implementation CDDAPMNetworkMonitorTests

- (void)setUp {
    [super setUp];
    self.plugin = [[CDDAPMNetworkRequestPlugin alloc] init];
    [self.plugin start];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testNetworkRequestMonitoring {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Network request completed"];
    
    NSURL *url = [NSURL URLWithString:@"https://baidu.com"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [task resume];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    
    // 给一些时间让 CDDAPMNetworkMonitor 处理统计信息
    [NSThread sleepForTimeInterval:1.0];
    
    NSDictionary *stats = [self.plugin getNetworkStatistics];
    XCTAssertNotNil(stats, @"Network statistics should not be nil");
    XCTAssertEqual([stats[@"totalRequests"] integerValue], 1, @"Total requests should be 1");
    
    NSDictionary *detailedStats = [self.plugin getDetailedNetworkStatistics];
    XCTAssertNotNil(detailedStats, @"Detailed network statistics should not be nil");
    XCTAssertEqual(detailedStats.count, 1, @"There should be one entry in detailed stats");
    
    NSString *expectedURLString = @"https://api.example.com/users";
    XCTAssertNotNil(detailedStats[expectedURLString], @"Statistics for the requested URL should exist");
    XCTAssertEqual([detailedStats[expectedURLString][@"totalRequests"] integerValue], 1, @"Total requests for this URL should be 1");
    XCTAssertGreaterThan([detailedStats[expectedURLString][@"averageDuration"] doubleValue], 0, @"Average duration should be greater than 0");
}

- (void)testMultipleNetworkRequests {
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Network request 1 completed"];
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Network request 2 completed"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url1 = [NSURL URLWithString:@"https://api.example.com/users?page=1"];
    NSURLSessionDataTask *task1 = [session dataTaskWithURL:url1 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [expectation1 fulfill];
    }];
    [task1 resume];
    
    NSURL *url2 = [NSURL URLWithString:@"https://api.example.com/posts?id=123"];
    NSURLSessionDataTask *task2 = [session dataTaskWithURL:url2 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [expectation2 fulfill];
    }];
    [task2 resume];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    
    // 给一些时间让 CDDAPMNetworkMonitor 处理统计信息
    [NSThread sleepForTimeInterval:1.0];
    
    NSDictionary *stats = [self.plugin getNetworkStatistics];
    XCTAssertEqual([stats[@"totalRequests"] integerValue], 2, @"Total requests should be 2");
    
    NSDictionary *detailedStats = [self.plugin getDetailedNetworkStatistics];
    XCTAssertEqual(detailedStats.count, 2, @"There should be two entries in detailed stats");
    
    NSString *expectedURLString1 = @"https://api.example.com/users";
    NSString *expectedURLString2 = @"https://api.example.com/posts";
    XCTAssertNotNil(detailedStats[expectedURLString1], @"Statistics for the first URL should exist");
    XCTAssertNotNil(detailedStats[expectedURLString2], @"Statistics for the second URL should exist");
}

@end
