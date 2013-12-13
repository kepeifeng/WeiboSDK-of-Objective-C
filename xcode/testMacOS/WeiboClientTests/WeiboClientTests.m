//
//  WeiboClientTests.m
//  WeiboClientTests
//
//  Created by Kent Peifeng Ke on 13-10-25.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import <XCTest/XCTest.h>


@interface WeiboClientTests : XCTestCase

@end

@implementation WeiboClientTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testAKVariableParams{
    
    NSString *source = @"";
    AKParsingObject *obj = [[AKParsingObject alloc]initWithSource:source];
    
    
    
}
@end
