//
//  SPEventDispatcherTest.m
//  Sparrow
//
//  Created by Daniel Sperl on 27.04.09.
//  Copyright 2011-2014 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "SPTestCase.h"

#define EVENT_TYPE @"EVENT_TYPE"

@interface SPEventDispatcherTest : SPTestCase 

@end

@implementation SPEventDispatcherTest
{
    int _testCounter;
}

- (void)setUp
{
    _testCounter = 0;
}

- (void)testAddAndRemoveEventListener
{
    SPEventDispatcher *dispatcher = [[SPEventDispatcher alloc] init];
    [dispatcher addEventListener:@selector(onEvent:) atObject:self forType:EVENT_TYPE];    
    XCTAssertTrue([dispatcher hasEventListenerForType:EVENT_TYPE], @"missing event listener");

    [dispatcher removeEventListener:@selector(onEvent:) atObject:self forType:EVENT_TYPE];
    XCTAssertFalse([dispatcher hasEventListenerForType:EVENT_TYPE], @"remove failed");    
}

- (void)testRemoveAllEventListenersOfObject
{
    SPEventDispatcher *dispatcher = [[SPEventDispatcher alloc] init];
    [dispatcher addEventListener:@selector(onEvent:) atObject:self forType:EVENT_TYPE];    
    XCTAssertTrue([dispatcher hasEventListenerForType:EVENT_TYPE], @"missing event listener");
    
    [dispatcher removeEventListenersAtObject:self forType:EVENT_TYPE];
    XCTAssertFalse([dispatcher hasEventListenerForType:EVENT_TYPE], @"remove failed");
}

- (void)testSimpleEvent
{
    SPEventDispatcher *dispatcher = [[SPEventDispatcher alloc] init];
    [dispatcher addEventListener:@selector(onEvent:) atObject:self forType:EVENT_TYPE];    
    [dispatcher dispatchEventWithType:EVENT_TYPE];
    XCTAssertEqual(1, _testCounter, @"event listener not called");    
    
    [dispatcher removeEventListener:@selector(onEvent:) atObject:self forType:EVENT_TYPE];    
}

- (void)testBubblingEvent
{
    SPSprite *sprite1 = [[SPSprite alloc] init];
    [sprite1 addEventListener:@selector(onEvent:) atObject:self forType:EVENT_TYPE];
    
    SPSprite *sprite2 = [[SPSprite alloc] init];
    [sprite2 addEventListener:@selector(stopEvent:) atObject:self forType:EVENT_TYPE];
    
    SPSprite *sprite3 = [[SPSprite alloc] init];
    [sprite3 addEventListener:@selector(onEvent:) atObject:self forType:EVENT_TYPE];
    
    SPSprite *sprite4 = [[SPSprite alloc] init];
    [sprite4 addEventListener:@selector(onEvent:) atObject:self forType:EVENT_TYPE];
    
    [sprite1 addChild:sprite2];
    [sprite2 addChild:sprite3];
    [sprite3 addChild:sprite4];
    
    [sprite4 dispatchEventWithType:EVENT_TYPE];
    
    XCTAssertEqual(1, _testCounter, @"event bubbled, but should not have");
    _testCounter = 0;
    
    [sprite4 dispatchEventWithType:EVENT_TYPE bubbles:YES];
    XCTAssertEqual(2, _testCounter, @"event bubbling incorrect");
    
    [sprite1 removeEventListenersAtObject:self forType:EVENT_TYPE];
    [sprite2 removeEventListenersAtObject:self forType:EVENT_TYPE];
    [sprite3 removeEventListenersAtObject:self forType:EVENT_TYPE];
    [sprite4 removeEventListenersAtObject:self forType:EVENT_TYPE];
}

- (void)testStopImmediatePropagation
{
    SPSprite *sprite = [[SPSprite alloc] init];
    [sprite addEventListener:@selector(onEvent:) atObject:self forType:EVENT_TYPE];
    [sprite addEventListener:@selector(onEvent2:) atObject:self forType:EVENT_TYPE];
    [sprite addEventListener:@selector(stopEventImmediately:) atObject:self forType:EVENT_TYPE];
    [sprite addEventListener:@selector(onEvent3:) atObject:self forType:EVENT_TYPE];
    [sprite dispatchEvent:[SPRWEvent eventWithType:EVENT_TYPE]];    
    
    XCTAssertEqual(2, _testCounter, @"stopEventImmediately did not work correctly");
    
    [sprite removeEventListenersAtObject:self forType:EVENT_TYPE];
}

- (void)testAddAndRemoveBlockEventHandlers
{
    NSString *eventType = @"eventType";
    int __block testCounter = 0;
    
    SPEventBlock block = ^(SPRWEvent *event)
    {
        testCounter++;
    };
    
    SPSprite *sprite = [SPSprite sprite];
    
    [sprite addEventListenerForType:eventType block:block];
    [sprite dispatchEventWithType:eventType];
    
    XCTAssertTrue([sprite hasEventListenerForType:eventType], @"event handler not recognized");
    XCTAssertEqual(1, testCounter, @"event block was not called");
    
    [sprite removeEventListenerForType:eventType block:block];
    [sprite dispatchEventWithType:eventType];
    
    XCTAssertTrue(![sprite hasEventListenerForType:eventType], @"event handler not removed");
    XCTAssertEqual(1, testCounter, @"event block was called, but shouldn't have been");
}

- (void)onEvent:(SPRWEvent *)event
{
    _testCounter++;
}

- (void)onEvent2:(SPRWEvent *)event
{
    _testCounter *= 2;
}

- (void)onEvent3:(SPRWEvent *)event
{
    _testCounter += 3;
}

- (void)stopEvent:(SPRWEvent *)event
{
    [event stopPropagation];
}

- (void)stopEventImmediately:(SPRWEvent *)event
{
    [event stopImmediatePropagation];
}

@end