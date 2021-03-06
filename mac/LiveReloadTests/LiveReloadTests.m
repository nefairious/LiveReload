//
//  LiveReloadTests.m
//  LiveReloadTests
//
//  Created by Andrey Tarantsov on 11.12.2013.
//
//

#import <XCTest/XCTest.h>

#import "LRTest.h"
#import "LiveReloadAppDelegate.h"
#import "AppState.h"
#import "LRPackageManager.h"
#import "PluginManager.h"
#import "Plugin.h"
#import "LRPackageContainer.h"

#import "ATFunctionalStyle.h"


@interface XCTestCase (ATAsyncTest)

- (void)waitWithTimeout:(NSTimeInterval)timeout;
- (void)done;

@end

@implementation XCTestCase (ATAsyncTest)

static volatile BOOL _ATAsyncTest_done;

- (void)waitForCondition:(BOOL(^)())conditionBlock withTimeout:(NSTimeInterval)timeout {
    NSDate *cutoff = [NSDate dateWithTimeIntervalSinceNow:timeout];
    while (!conditionBlock() && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:cutoff])
        NSLog(@"Still waiting...");
    if (!conditionBlock()) {
        NSAssert([[NSDate date] compare:cutoff] == NSOrderedAscending, @"Timeout");
    }
}

- (void)waitWithTimeout:(NSTimeInterval)timeout {
    _ATAsyncTest_done = NO;
    NSDate *cutoff = [NSDate dateWithTimeIntervalSinceNow:timeout];
    while (!_ATAsyncTest_done && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:cutoff])
        NSLog(@"Still waiting...");
    if (!_ATAsyncTest_done) {
        NSAssert([[NSDate date] compare:cutoff] == NSOrderedAscending, @"Timeout");
    }
}

- (dispatch_block_t)completionBlock {
    return ^{
        [self done];
    };
}

- (void)done {
    dispatch_async(dispatch_get_main_queue(), ^{
        _ATAsyncTest_done = YES;
    });
}


@end


@interface LiveReloadTests : XCTestCase

@end


@implementation LiveReloadTests {
    NSURL *_baseFolderURL;
}

+ (void)setUp {
    [super setUp];
}

- (void)setUp {
    [super setUp];

    _baseFolderURL = [NSURL fileURLWithPath:[@"~/dev/livereload/devel/mac/LiveReloadTestProjects" stringByExpandingTildeInPath]];

    NSLog(@"Waiting for initialization to finish...");
    [self waitForCondition:^BOOL{
        NSArray *packageContainers = [[PluginManager sharedPluginManager].plugins valueForKeyPath:@"@unionOfArrays.bundledPackageContainers"];
        return (packageContainers.count > 0) && [packageContainers all:^BOOL(LRPackageContainer *container) {
            return !container.updateInProgress;
        }];
    } withTimeout:3000];
    NSLog(@"Initialization finished.");
}

- (void)tearDown {
    [super tearDown];
}

- (NSError *)runProjectTestNamed:(NSString *)name {
    LRTest *test = [[LRTest alloc] initWithFolderURL:[_baseFolderURL URLByAppendingPathComponent:name]];
    test.completionBlock = self.completionBlock;
    [test run];
    [self waitWithTimeout:3.0];
    return test.error;
}

- (void)testHamlSimple {
    XCTAssertNil([self runProjectTestNamed:@"haml_simple"], @"Failed");
}

- (void)testLessSimple {
    XCTAssertNil([self runProjectTestNamed:@"less_simple"], @"Failed");
}
- (void)testLessImports {
    XCTAssertNil([self runProjectTestNamed:@"less_imports"], @"Failed");
}
- (void)testLessImportsReference {
    XCTAssertNil([self runProjectTestNamed:@"less_imports_reference"], @"Failed");
}
- (void)testLessVersion3 {
    XCTAssertNil([self runProjectTestNamed:@"less_version_3"], @"Failed");
}
- (void)testLessVersion4 {
    XCTAssertNil([self runProjectTestNamed:@"less_version_4"], @"Failed");
}
- (void)testLessVersion5 {
    XCTAssertNil([self runProjectTestNamed:@"less_version_5"], @"Failed");
}

- (void)testEcoSimple {
    XCTAssertNil([self runProjectTestNamed:@"eco_simple"], @"Failed");
}

- (void)testCoffeeScriptSimple {
    XCTAssertNil([self runProjectTestNamed:@"coffeescript_simple"], @"Failed");
}
- (void)testCoffeeScriptLiterate {
    XCTAssertNil([self runProjectTestNamed:@"coffeescript_literate"], @"Failed");
}
- (void)testCoffeeScriptLiterateMd {
    XCTAssertNil([self runProjectTestNamed:@"coffeescript_literate_md"], @"Failed");
}

- (void)testIcedCoffeeScriptSimple {
    XCTAssertNil([self runProjectTestNamed:@"icedcoffeescript_simple"], @"Failed");
}
- (void)testIcedCoffeeScriptLiterate {
    XCTAssertNil([self runProjectTestNamed:@"icedcoffeescript_literate"], @"Failed");
}
- (void)testIcedCoffeeScriptLiterateMd {
    XCTAssertNil([self runProjectTestNamed:@"icedcoffeescript_literate_md"], @"Failed");
}

- (void)testJadeSimple {
    XCTAssertNil([self runProjectTestNamed:@"jade_simple"], @"Failed");
}
- (void)testJadeFilterMarkdown {
    XCTAssertNil([self runProjectTestNamed:@"jade_filter_markdown"], @"Failed");
}

- (void)testSassSimple {
    XCTAssertNil([self runProjectTestNamed:@"sass_simple"], @"Failed");
}
- (void)testSassIndented {
    XCTAssertNil([self runProjectTestNamed:@"sass_indented"], @"Failed");
}

- (void)testSlimSimple {
    XCTAssertNil([self runProjectTestNamed:@"slim_simple"], @"Failed");
}

- (void)testStylusSimple {
    XCTAssertNil([self runProjectTestNamed:@"stylus_simple"], @"Failed");
}
- (void)testStylusNib {
    XCTAssertNil([self runProjectTestNamed:@"stylus_nib"], @"Failed");
}

- (void)testTypeScriptSimple {
    XCTAssertNil([self runProjectTestNamed:@"typescript_simple"], @"Failed");
}

@end
