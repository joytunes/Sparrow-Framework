//
//  SPDisplayObjectContainerTest.m
//  Sparrow
//
//  Created by Daniel Sperl on 13.04.09.
//  Copyright 2011-2014 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "SPTestCase.h"

@interface SPDisplayObjectContainerTest : SPTestCase

@end

@implementation SPDisplayObjectContainerTest
{
    int _added;
    int _addedToStage;
    int _removed;
    int _removedFromStage;
    int _eventCount;
    SPSprite *_testSprite;
    SPEventDispatcher *_broadcastTarget;
}

- (void) setUp
{
    _added = _addedToStage = _removed = _removedFromStage = _eventCount = 0;    
    _testSprite = [[SPSprite alloc] init];
}

- (void)testChildParentHandling
{
    SPSprite *parent = [[SPSprite alloc] init];
    SPSprite *child1 = [[SPSprite alloc] init];
    SPSprite *child2 = [[SPSprite alloc] init];
    
    XCTAssertEqual(0, parent.numChildren, @"wrong number of children");
    XCTAssertNil(child1.parent, @"parent not nil");
    
    [parent addChild:child1];
    XCTAssertEqual(1, parent.numChildren, @"wrong number of children");
    XCTAssertEqualObjects(parent, child1.parent, @"invalid parent");
    
    [parent addChild:child2];
    XCTAssertEqual(2, parent.numChildren, @"wrong number of children");
    XCTAssertEqualObjects(parent, child2.parent, @"invalid parent");
    XCTAssertEqualObjects(child1, [parent childAtIndex:0], @"wrong child index");
    XCTAssertEqualObjects(child2, [parent childAtIndex:1], @"wrong child index");
    
    [parent removeChild:child1];
    XCTAssertNil(child1.parent, @"parent not nil");
    XCTAssertEqualObjects(child2, [parent childAtIndex:0], @"wrong child index");
    XCTAssertNoThrow([child1 removeFromParent], @"exception raised");
    
    [child2 addChild:child1];
    XCTAssertTrue([parent containsChild:child1], @"child not found");
    XCTAssertTrue([parent containsChild:child2], @"child not found");
    XCTAssertEqualObjects(child2, child1.parent, @"invalid parent");
    
    [parent addChild:child1 atIndex:0];
    XCTAssertEqualObjects(parent, child1.parent, @"invalid parent");
    XCTAssertFalse([child2 containsChild:child1], @"invalid connection");
    XCTAssertEqualObjects(child1, [parent childAtIndex:0], @"wrong child");
    XCTAssertEqualObjects(child2, [parent childAtIndex:1], @"wrong child");    
}

- (void)testSetChildIndex
{
    SPSprite *parent = [SPSprite sprite];
    SPSprite *childA = [SPSprite sprite];
    SPSprite *childB = [SPSprite sprite];
    SPSprite *childC = [SPSprite sprite];
    
    [parent addChild:childA];
    [parent addChild:childB];
    [parent addChild:childC];
    
    [parent setIndex:0 ofChild:childB];
    XCTAssertEqual(childB, [parent childAtIndex:0], @"wrong child order");
    XCTAssertEqual(childA, [parent childAtIndex:1], @"wrong child order");
    XCTAssertEqual(childC, [parent childAtIndex:2], @"wrong child order");
    
    [parent setIndex:1 ofChild:childB];
    XCTAssertEqual(childA, [parent childAtIndex:0], @"wrong child order");
    XCTAssertEqual(childB, [parent childAtIndex:1], @"wrong child order");
    XCTAssertEqual(childC, [parent childAtIndex:2], @"wrong child order");
    
    [parent setIndex:2 ofChild:childB];
    XCTAssertEqual(childA, [parent childAtIndex:0], @"wrong child order");
    XCTAssertEqual(childC, [parent childAtIndex:1], @"wrong child order");
    XCTAssertEqual(childB, [parent childAtIndex:2], @"wrong child order");
    
    XCTAssertEqual(3, parent.numChildren, @"wrong child count");
}

- (void)testWidthAndHeight
{
    SPSprite *sprite = [[SPSprite alloc] init];
    
    SPQuad *quad1 = [[SPQuad alloc] initWithWidth:10 height:20];    
    quad1.x = -10;
    quad1.y = -15;
    
    SPQuad *quad2 = [[SPQuad alloc] initWithWidth:15 height:25];
    quad2.x = 30;
    quad2.y = 25;
    
    [sprite addChild:quad1];
    [sprite addChild:quad2];
    
    XCTAssertTrue(SP_IS_FLOAT_EQUAL(55.0f, sprite.width), @"wrong width: %f", sprite.width);
    XCTAssertTrue(SP_IS_FLOAT_EQUAL(65.0f, sprite.height), @"wrong height: %f", sprite.height);
    
    quad1.rotation = PI_HALF;
    XCTAssertTrue(SP_IS_FLOAT_EQUAL(75.0f, sprite.width), @"wrong width: %f", sprite.width);
    XCTAssertTrue(SP_IS_FLOAT_EQUAL(65.0f, sprite.height), @"wrong height: %f", sprite.height);
    
    quad1.rotation = PI;
    XCTAssertTrue(SP_IS_FLOAT_EQUAL(65.0f, sprite.width), @"wrong width: %f", sprite.width);
    XCTAssertTrue(SP_IS_FLOAT_EQUAL(85.0f, sprite.height), @"wrong height: %f", sprite.height);
}

- (void)testBounds
{
    SPQuad *quad = [[SPQuad alloc] initWithWidth:10 height:20];
    quad.x = -10;
    quad.y = 10;
    quad.rotation = PI_HALF;
    
    SPSprite *sprite = [[SPSprite alloc] init];
    [sprite addChild:quad];
    
    SPRectangle *bounds = [sprite bounds];
    XCTAssertTrue(SP_IS_FLOAT_EQUAL(-30, bounds.x), @"wrong bounds.x: %f", bounds.x);
    XCTAssertTrue(SP_IS_FLOAT_EQUAL(10, bounds.y), @"wrong bounds.y: %f", bounds.y);
    XCTAssertTrue(SP_IS_FLOAT_EQUAL(20, bounds.width), @"wrong bounds.width: %f", bounds.width);
    XCTAssertTrue(SP_IS_FLOAT_EQUAL(10, bounds.height), @"wrong bounds.height: %f", bounds.height);    
    
    bounds = [sprite boundsInSpace:sprite];
    XCTAssertTrue(SP_IS_FLOAT_EQUAL(-30, bounds.x), @"wrong bounds.x: %f", bounds.x);
    XCTAssertTrue(SP_IS_FLOAT_EQUAL(10, bounds.y), @"wrong bounds.y: %f", bounds.y);
    XCTAssertTrue(SP_IS_FLOAT_EQUAL(20, bounds.width), @"wrong bounds.width: %f", bounds.width);
    XCTAssertTrue(SP_IS_FLOAT_EQUAL(10, bounds.height), @"wrong bounds.height: %f", bounds.height); 
}

- (void)testBoundsInSpace
{
    SPSprite *root = [[SPSprite alloc] init];
    
    SPSprite *spriteA = [[SPSprite alloc] init];
    spriteA.x = 50;
    spriteA.y = 50;
    [self addQuadToSprite:spriteA];
    [root addChild:spriteA];
    
    SPSprite *spriteA1 = [[SPSprite alloc] init];
    spriteA1.x = 150;
    spriteA1.y = 50;
    spriteA1.scaleX = spriteA1.scaleY = 0.5;
    [self addQuadToSprite:spriteA1];
    [spriteA addChild:spriteA1];
    
    SPSprite *spriteA11 = [[SPSprite alloc] init];
    spriteA11.x = 25;
    spriteA11.y = 50;
    spriteA11.scaleX = spriteA11.scaleY = 0.5;
    [self addQuadToSprite:spriteA11];
    [spriteA1 addChild:spriteA11];
    
    SPSprite *spriteA2 = [[SPSprite alloc] init];
    spriteA2.x = 50;
    spriteA2.y = 150;
    spriteA2.scaleX = spriteA2.scaleY = 0.5;
    [self addQuadToSprite:spriteA2];
    [spriteA addChild:spriteA2];
    
    SPSprite *spriteA21 = [[SPSprite alloc] init];
    spriteA21.x = 50;
    spriteA21.y = 25;
    spriteA21.scaleX = spriteA21.scaleY = 0.5;
    [self addQuadToSprite:spriteA21];
    [spriteA2 addChild:spriteA21];    
    
    // ---
    
    SPRectangle *bounds = [spriteA21 boundsInSpace:spriteA11];
    SPRectangle *expectedBounds = [SPRectangle rectangleWithX:-350 y:350 width:100 height:100];
    XCTAssertTrue([bounds isEqualToRectangle:expectedBounds], @"wrong bounds: %@", bounds);
    
    // now rotate as well
    
    spriteA11.rotation = PI/4.0f;
    spriteA21.rotation = -PI/4.0f;
    
    bounds = [spriteA21 boundsInSpace:spriteA11];
    expectedBounds = [SPRectangle rectangleWithX:0 y:394.974762 width:100 height:100];
    XCTAssertTrue([bounds isEqualToRectangle:expectedBounds], @"wrong bounds: %@", bounds);
}

- (void)testSize
{
    SPQuad *quad1 = [SPQuad quadWithWidth:100 height:100];
    SPQuad *quad2 = [SPQuad quadWithWidth:100 height:100];
    quad2.x = quad2.y = 100;
    
    SPSprite *sprite = [SPSprite sprite];
    SPSprite *childSprite = [SPSprite sprite];
    
    [sprite addChild:childSprite];
    [childSprite addChild:quad1];
    [childSprite addChild:quad2];
        
    
    XCTAssertEqualWithAccuracy(200.0f, sprite.width, E, @"wrong width: %f", sprite.width);
    XCTAssertEqualWithAccuracy(200.0f, sprite.height, E, @"wrong height: %f", sprite.height);
        
    sprite.scaleX = 2;
    sprite.scaleY = 2;
    XCTAssertEqualWithAccuracy(400.0f, sprite.width, E, @"wrong width: %f", sprite.width);
    XCTAssertEqualWithAccuracy(400.0f, sprite.height, E, @"wrong height: %f", sprite.height);    
}

- (void)testIllegalRecursion
{
    SPSprite *sprite1 = [SPSprite sprite];
    SPSprite *sprite2 = [SPSprite sprite];
    SPSprite *sprite3 = [SPSprite sprite];
    
    [sprite1 addChild:sprite2];
    [sprite2 addChild:sprite3];
    
    XCTAssertThrows([sprite3 addChild:sprite1], @"container allowed adding child as parent");
}

- (void)testAddAsChildToSelf
{
    SPSprite *sprite = [SPSprite sprite];
    XCTAssertThrows([sprite addChild:sprite], @"container allowed adding self as child");
}

- (void)addQuadToSprite:(SPSprite *)sprite
{
    SPQuad *quad = [[SPQuad alloc] initWithWidth:100 height:100];
    quad.alpha = 0.2f;
    [sprite addChild:quad];
    return;
}

- (void)testDisplayListEvents
{
    SPStage *stage = [[SPStage alloc] init];
    SPSprite *sprite = [[SPSprite alloc] init];
    SPQuad *quad = [[SPQuad alloc] initWithWidth:20 height:20];
    
    [quad addEventListener:@selector(onAdded:) atObject:self forType:SPEventTypeAdded];
    [quad addEventListener:@selector(onAddedToStage:) atObject:self forType:SPEventTypeAddedToStage];
    [quad addEventListener:@selector(onRemoved:) atObject:self forType:SPEventTypeRemoved];
    [quad addEventListener:@selector(onRemovedFromStage:) atObject:self forType:SPEventTypeRemovedFromStage];
    
    [sprite addChild:quad];
    
    XCTAssertEqual(1, _added, @"failure on event 'added'");
    XCTAssertEqual(0, _removed, @"failure on event 'removed'");
    XCTAssertEqual(0, _addedToStage, @"failure on event 'addedToStage'");
    XCTAssertEqual(0, _removedFromStage, @"failure on event 'removedFromStage'");
    
    [stage addChild:sprite];
    
    XCTAssertEqual(1, _added, @"failure on event 'added'");
    XCTAssertEqual(0, _removed, @"failure on event 'removed'");
    XCTAssertEqual(1, _addedToStage, @"failure on event 'addedToStage'");
    XCTAssertEqual(0, _removedFromStage, @"failure on event 'removedFromStage'");
    
    [stage removeChild:sprite];
    
    XCTAssertEqual(1, _added, @"failure on event 'added'");
    XCTAssertEqual(0, _removed, @"failure on event 'removed'");
    XCTAssertEqual(1, _addedToStage, @"failure on event 'addedToStage'");
    XCTAssertEqual(1, _removedFromStage, @"failure on event 'removedFromStage'");
    
    [sprite removeChild:quad];
    
    XCTAssertEqual(1, _added, @"failure on event 'added'");
    XCTAssertEqual(1, _removed, @"failure on event 'removed'");
    XCTAssertEqual(1, _addedToStage, @"failure on event 'addedToStage'");
    XCTAssertEqual(1, _removedFromStage, @"failure on event 'removedFromStage'");
    
    [quad removeEventListenersAtObject:self forType:SPEventTypeAdded];
    [quad removeEventListenersAtObject:self forType:SPEventTypeAddedToStage];
    [quad removeEventListenersAtObject:self forType:SPEventTypeRemoved];
    [quad removeEventListenersAtObject:self forType:SPEventTypeRemovedFromStage];
}

- (void)onAdded:(SPRWEvent *)event { _added++; }
- (void)onRemoved:(SPRWEvent *)event { _removed++; }
- (void)onAddedToStage:(SPRWEvent *)event { _addedToStage++; }
- (void)onRemovedFromStage:(SPRWEvent *)event { _removedFromStage++; }

- (void)testRemovedFromStage
{
    SPStage *stage = [[SPStage alloc] init];
    [stage addChild:_testSprite];    
    [_testSprite addEventListener:@selector(onTestSpriteRemovedFromStage:) atObject:self
                          forType:SPEventTypeRemovedFromStage];    
    [_testSprite removeFromParent];
    [_testSprite removeEventListenersAtObject:self forType:SPEventTypeRemovedFromStage];        
}

- (void)onTestSpriteRemovedFromStage:(SPRWEvent *)event
{
    XCTAssertNotNil(_testSprite.stage, @"stage not accessible in removed from stage event");
}

- (void)testAddExistingChild
{
    SPSprite *sprite = [SPSprite sprite];
    SPQuad *quad = [SPQuad quadWithWidth:100 height:100];
    [sprite addChild:quad];
    XCTAssertNoThrow([sprite addChild:quad], @"Could not add child multiple times");
}

- (void)testRemoveAllChildren
{
    SPSprite *sprite = [SPSprite sprite];
    
    XCTAssertEqual(0, sprite.numChildren, @"wrong number of children");
    [sprite removeAllChildren];
    XCTAssertEqual(0, sprite.numChildren, @"wrong number of children");
    
    [sprite addChild:[SPQuad quadWithWidth:100 height:100]];
    [sprite addChild:[SPQuad quadWithWidth:100 height:100]];    

    XCTAssertEqual(2, sprite.numChildren, @"wrong number of children");
    [sprite removeAllChildren];    
    XCTAssertEqual(0, sprite.numChildren, @"remove all children did not work");    
}

- (void)testChildByName
{
    SPSprite *parent = [SPSprite sprite];
    SPSprite *child1 = [SPSprite sprite];
    SPSprite *child2 = [SPSprite sprite];
    SPSprite *child3 = [SPSprite sprite];
    
    [parent addChild:child1];
    [parent addChild:child2];
    [parent addChild:child3];
    
    child1.name = @"CHILD";
    child3.name = @"child";
    
    XCTAssertEqual(child1, [parent childByName:@"CHILD"], @"wrong child returned");
    XCTAssertEqual(child3, [parent childByName:@"child"], @"wrong child returned");
    XCTAssertNil([parent childByName:@"ChIlD"], @"return child on wrong name");
}

- (void)testSortChildren
{
    SPSprite *s1 = [SPSprite sprite]; s1.y = 8;
    SPSprite *s2 = [SPSprite sprite]; s2.y = 3;
    SPSprite *s3 = [SPSprite sprite]; s3.y = 6;
    SPSprite *s4 = [SPSprite sprite]; s4.y = 1;
    
    SPSprite *parent = [SPSprite sprite];
    [parent addChild:s1];
    [parent addChild:s2];
    [parent addChild:s3];
    [parent addChild:s4];
    
    [parent sortChildren:^(SPDisplayObject *child1, SPDisplayObject *child2) 
    {
        if (child1.y < child2.y) return NSOrderedAscending;
        else if (child1.y > child2.y) return NSOrderedDescending;
        else return NSOrderedSame;
    }];

    XCTAssertEqual(s4, [parent childAtIndex:0], @"incorrect sort");
    XCTAssertEqual(s2, [parent childAtIndex:1], @"incorrect sort");
    XCTAssertEqual(s3, [parent childAtIndex:2], @"incorrect sort");
    XCTAssertEqual(s1, [parent childAtIndex:3], @"incorrect sort");
}

- (void)testBroadcastEvent
{
    SPSprite *parent = [SPSprite sprite];

    SPSprite *child1 = [SPSprite sprite];
    SPSprite *child2 = [SPSprite sprite];
    SPSprite *child3 = [SPSprite sprite];
    
    [parent addChild:child1];
    [parent addChild:child2];
    [parent addChild:child3];
    
    child1.name = @"trigger";
    [child1 addEventListener:@selector(onChildEvent:) atObject:self forType:@"dunno"];
    [child2 addEventListener:@selector(onChildEvent:) atObject:self forType:@"dunno"];
    [child3 addEventListener:@selector(onChildEvent:) atObject:self forType:@"dunno"];
    
    SPRWEvent *event = [SPRWEvent eventWithType:@"dunno"];
    [parent broadcastEvent:event];
    
    // event should have dispatched to all 3 children, even if the event listener
    // removes the children from their parent when it reaches child1. Furthermore, it should
    // not crash.
    
    XCTAssertEqual(3, _eventCount, @"not all children received events!");
}

- (void)testBroadcastEventTarget
{
    SPSprite *parent = [SPSprite sprite];
    SPSprite *childA = [SPSprite sprite];
    SPSprite *childA1 = [SPSprite sprite];
    SPSprite *childA2 = [SPSprite sprite];
    
    [parent addChild:childA];
    [parent addChild:childA1];
    [parent addChild:childA2];
    
    parent.name = @"parent";
    childA.name = @"childA";
    childA1.name = @"childA1";
    childA2.name = @"childA2";
    
    [childA2 addEventListener:@selector(onBroadcastEvent:) atObject:self forType:@"test"];
    [parent broadcastEvent:[SPRWEvent eventWithType:@"test"]];
    
    XCTAssertEqual(parent, _broadcastTarget, @"wrong event.target on broadcast");
}

- (void)onBroadcastEvent:(SPRWEvent *)event
{
    _broadcastTarget = event.target;
}

- (void)onChildEvent:(SPRWEvent *)event
{
    SPDisplayObject *target = (SPDisplayObject *)event.target;
    
    if ([target.name isEqualToString:@"trigger"])
        [target.parent removeAllChildren];
    
    ++_eventCount;
}

- (void)testRemoveWithEventHandler
{
    SPSprite *parent = [SPSprite sprite];
    SPSprite *child0 = [SPSprite sprite];
    SPSprite *child1 = [SPSprite sprite];
    SPSprite *child2 = [SPSprite sprite];
    
    [parent addChild:child0];
    [parent addChild:child1];
    [parent addChild:child2];

    // Remove last child, and in its event listener remove first child.
    // That must work, even though the child changes its index in the event handler.
    
    [child2 addEventListener:@selector(onRemoveChild2:) atObject:self forType:SPEventTypeRemoved];

    XCTAssertNoThrow([parent removeChildAtIndex:2], @"exception raised");
    XCTAssertNil(child2.parent, @"child 2 not properly removed");
    XCTAssertNil(child0.parent, @"child 0 not properly removed");
    XCTAssertEqual(child1, [parent childAtIndex:0], @"unexpected child");
    XCTAssertEqual(1, parent.numChildren, @"wrong number of children");
}

- (void)onRemoveChild2:(SPRWEvent *)event
{
    SPSprite *child2 = (SPSprite *)event.target;
    SPSprite *parent = (SPSprite *)child2.parent;
    [parent removeChildAtIndex:0];
}

@end