//
//  MusicPlayUITests.m
//  MusicPlayUITests
//
//  Created by 张建军 on 15/11/2.
//  Copyright © 2015年 张建军. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MusicPlayUITests : XCTestCase

@end

@implementation MusicPlayUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
