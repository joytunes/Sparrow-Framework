//
//  SPMovieClipTest.m
//  Sparrow
//
//  Created by Daniel Sperl on 03.06.10.
//  Copyright 2011-2014 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "SPTestCase.h"

@interface SPMovieClipTest : SPTestCase

@end

@implementation SPMovieClipTest
{
    int _completedCount;
}

- (void) setUp
{
    _completedCount = 0;
}

- (void)onMovieCompleted:(SPRWEvent *)event
{
    _completedCount++;
}

- (void)testFrameManipulation
{    
    float fps = 4.0;
    double frameDuration = 1.0 / fps;
    
    SPTexture *frame0 = [[SPTexture alloc] init];
    SPTexture *frame1 = [[SPTexture alloc] init];
    SPTexture *frame2 = [[SPTexture alloc] init];
    SPTexture *frame3 = [[SPTexture alloc] init];
    
    SPMovieClip *movie = [SPMovieClip movieWithFrame:frame0 fps:fps];    
    
    XCTAssertEqualWithAccuracy(frame0.width, movie.width, E, @"wrong size");
    XCTAssertEqualWithAccuracy(frame0.height, movie.height, E, @"wrong size");

    XCTAssertEqual(1, movie.numFrames, @"wrong number of frames");
    XCTAssertEqual(0, movie.currentFrame, @"wrong start value");
    XCTAssertEqual(YES, movie.loop, @"wrong default value");
    XCTAssertEqual(YES, movie.isPlaying, @"wrong default value");
    XCTAssertEqualWithAccuracy(frameDuration, movie.totalTime, E, @"wrong totalTime");
    
    [movie pause];
    XCTAssertFalse(movie.isPlaying, @"property returns wrong value");
    
    [movie play];
    XCTAssertTrue(movie.isPlaying, @"property returns wrong value");
    
    movie.loop = NO;
    XCTAssertFalse(movie.loop, @"property returns wrong value");    
    
    [movie addFrameWithTexture:frame1];
    
    XCTAssertEqual(2, movie.numFrames, @"wrong number of frames");
    XCTAssertEqualWithAccuracy(2 * frameDuration, movie.totalTime, E, @"wrong totalTime");
    
    XCTAssertEqualObjects(frame0, [movie textureAtIndex:0], @"wrong frame");
    XCTAssertEqualObjects(frame1, [movie textureAtIndex:1], @"wrong frame");
    
    XCTAssertEqualWithAccuracy(frameDuration, [movie durationAtIndex:0] , E, @"wrong frame duration");
    XCTAssertEqualWithAccuracy(frameDuration, [movie durationAtIndex:1] , E, @"wrong frame duration");
    
    XCTAssertNil([movie soundAtIndex:0], @"sound not nil");
    XCTAssertNil([movie soundAtIndex:1], @"sound not nil");
    
    [movie addFrameWithTexture:frame2 duration:0.5];
    XCTAssertEqualWithAccuracy(0.5, [movie durationAtIndex:2], E, @"wrong frame duration");
    XCTAssertEqualWithAccuracy(1.0, movie.totalTime, E, @"wrong totalTime");
    
    [movie addFrameWithTexture:frame3 atIndex:2]; // -> 0, 1, 3, 2
    XCTAssertEqual(4, movie.numFrames, @"wrong number of frames");
    XCTAssertEqualWithAccuracy(1.0 + frameDuration, movie.totalTime, E, @"wrong totalTime");
    XCTAssertEqualObjects(frame1, [movie textureAtIndex:1], @"wrong frame");
    XCTAssertEqualObjects(frame3, [movie textureAtIndex:2], @"wrong frame");
    XCTAssertEqualObjects(frame2, [movie textureAtIndex:3], @"wrong frame");
    
    [movie removeFrameAtIndex:0]; // -> 1, 3, 2
    XCTAssertEqual(3, movie.numFrames, @"wrong number of frames");
    XCTAssertEqualObjects(frame1, [movie textureAtIndex:0], @"wrong frame");
    XCTAssertEqualWithAccuracy(1.0, movie.totalTime, E, @"wrong totalTime");
    
    [movie removeFrameAtIndex:1]; // -> 1, 2
    XCTAssertEqual(2, movie.numFrames, @"wrong number of frames");
    XCTAssertEqualObjects(frame1, [movie textureAtIndex:0], @"wrong frame");
    XCTAssertEqualObjects(frame2, [movie textureAtIndex:1], @"wrong frame");
    XCTAssertEqualWithAccuracy(0.75, movie.totalTime, E, @"wrong totalTime");
    
    [movie setTexture:frame3 atIndex:1];
    XCTAssertEqualObjects(frame3, [movie textureAtIndex:1], @"wrong frame");    
    
    [movie setDuration:0.75 atIndex:1];
    XCTAssertEqualWithAccuracy(1.0, movie.totalTime, E, @"wrong totalTime");
    
    [movie addFrameWithTexture:frame3 atIndex:2];
    XCTAssertEqual(frame3, [movie textureAtIndex:2], @"wrong frame");
}

- (void)testAdvanceTime
{
    float fps = 4.0;
    double frameDuration = 1.0 / fps;
    
    SPTexture *frame0 = [[SPTexture alloc] init];
    SPTexture *frame1 = [[SPTexture alloc] init];
    SPTexture *frame2 = [[SPTexture alloc] init];
    SPTexture *frame3 = [[SPTexture alloc] init];
    
    SPMovieClip *movie = [SPMovieClip movieWithFrame:frame0 fps:fps];
    
    [movie addFrameWithTexture:frame1];
    [movie addFrameWithTexture:frame2 duration:0.5];
    [movie addFrameWithTexture:frame3];
    
    XCTAssertEqual(0, movie.currentFrame, @"wrong current frame");
    [movie advanceTime:frameDuration / 2.0];
    XCTAssertEqual(0, movie.currentFrame, @"wrong current frame");
    [movie advanceTime:frameDuration];
    XCTAssertEqual(1, movie.currentFrame, @"wrong current frame");
    [movie advanceTime:frameDuration];
    XCTAssertEqual(2, movie.currentFrame, @"wrong current frame");
    [movie advanceTime:frameDuration];
    XCTAssertEqual(2, movie.currentFrame, @"wrong current frame");
    [movie advanceTime:frameDuration];
    XCTAssertEqual(3, movie.currentFrame, @"wrong current frame");
    [movie advanceTime:frameDuration];
    XCTAssertEqual(0, movie.currentFrame, @"movie did not loop");
    
    movie.loop = NO;
    [movie advanceTime:movie.totalTime + frameDuration];
    XCTAssertEqual(3, movie.currentFrame, @"movie looped");
    XCTAssertFalse(movie.isPlaying, @"movie returned true for 'isPlaying' after reaching end");
    
    movie.currentFrame = 0;
    XCTAssertEqual(0, movie.currentFrame, @"wrong current frame");
    [movie advanceTime:frameDuration * 1.1];
    XCTAssertEqual(1, movie.currentFrame, @"wrong current frame");
    
    [movie stop];
    XCTAssertFalse(movie.isPlaying, @"movie returned true for 'isPlaying' after reaching end");
    XCTAssertEqual(0, movie.currentFrame, @"movie did not reset playhead on stop");
}

- (void)testChangeFps
{
    NSArray *frames = @[[[SPTexture alloc] init], [[SPTexture alloc] init],
                        [[SPTexture alloc] init]];
        
    SPMovieClip *movie = [SPMovieClip movieWithFrames:frames fps:4.0f];    
    XCTAssertEqual(4.0f, movie.fps, @"wrong fps");
    
    movie.fps = 3.0f;
    XCTAssertEqual(3.0f, movie.fps, @"wrong fps");    
    XCTAssertEqualWithAccuracy(1.0 / 3.0, [movie durationAtIndex:0], E, @"wrong frame duration");
    XCTAssertEqualWithAccuracy(1.0 / 3.0, [movie durationAtIndex:1], E, @"wrong frame duration");
    XCTAssertEqualWithAccuracy(1.0 / 3.0, [movie durationAtIndex:2], E, @"wrong frame duration");
    
    [movie setDuration:1.0 atIndex:1];
    XCTAssertEqualWithAccuracy(1.0, [movie durationAtIndex:1], E, @"wrong frame duration");
    
    movie.fps = 6.0f;
    XCTAssertEqualWithAccuracy(0.5,       [movie durationAtIndex:1], E, @"wrong frame duration");
    XCTAssertEqualWithAccuracy(1.0 / 6.0, [movie durationAtIndex:0], E, @"wrong frame duration");
    
    movie.fps = 0.0f;
    XCTAssertEqualWithAccuracy(0.0f, movie.fps, E, @"wrong fps");
}

- (void)testCompletedEvent
{
    float fps = 4.0f;
    double frameDuration = 1.0 / fps;
    
    NSArray *frames = @[[[SPTexture alloc] init], [[SPTexture alloc] init],
                        [[SPTexture alloc] init], [[SPTexture alloc] init]];
    NSInteger numFrames = frames.count;
    
    SPMovieClip *movie = [SPMovieClip movieWithFrames:frames fps:fps];    
    [movie addEventListener:@selector(onMovieCompleted:) atObject:self 
                    forType:SPEventTypeCompleted];
    
    movie.loop = NO;
    
    [movie advanceTime:frameDuration];
    XCTAssertEqual(0, _completedCount, @"completed event fired too soon");
    [movie advanceTime:frameDuration];
    XCTAssertEqual(0, _completedCount, @"completed event fired too soon");
    [movie advanceTime:frameDuration];
    XCTAssertEqual(0, _completedCount, @"completed event fired too soon");
    [movie advanceTime:frameDuration];
    XCTAssertEqual(1, _completedCount, @"completed event not fired");    
    [movie advanceTime:numFrames * 2 * frameDuration];
    XCTAssertEqual(1, _completedCount, @"too many completed events fired");
    
    movie.loop = YES;
    
    [movie advanceTime:frameDuration];
    XCTAssertEqual(1, _completedCount, @"completed event fired too soon");
    [movie advanceTime:frameDuration];
    XCTAssertEqual(1, _completedCount, @"completed event fired too soon");
    [movie advanceTime:frameDuration];
    XCTAssertEqual(1, _completedCount, @"completed event fired too soon");
    [movie advanceTime:frameDuration];
    XCTAssertEqual(2, _completedCount, @"completed event not fired");    
    [movie advanceTime:numFrames * 2 * frameDuration];
    XCTAssertEqual(4, _completedCount, @"wrong number of events dispatched");
}

@end