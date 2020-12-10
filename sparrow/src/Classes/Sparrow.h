//
//  Sparrow.h
//  Sparrow
//
//  Created by Daniel Sperl on 21.03.09.
//  Copyright 2011-2014 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import <Availability.h>

#ifndef __IPHONE_5_0
    #warning "This project uses features only available in iOS SDK 5.0 and later."
#endif

#define SPARROW_VERSION @"2.1"

#if SPARROW_SWIFT_PACKAGE
#import <SparrowClass.h>
#import <SPAudioEngine.h>
#import <SPBaseEffect.h>
#import <SPBitmapFont.h>
#import <SPBlendMode.h>
#import <SPBlurFilter.h>
#import <SPButton.h>
#import <SPColorMatrix.h>
#import <SPColorMatrixFilter.h>
#import <SPContext.h>
#import <SPDelayedInvocation.h>
#import <SPDisplacementMapFilter.h>
#import <SPDisplayObject.h>
#import <SPDisplayObjectContainer.h>
#import <SPEnterFrameEvent.h>
#import <SPEvent.h>
#import <SPEventDispatcher.h>
#import <SPGLTexture.h>
#import <SPJuggler.h>
#import <SPImage.h>
#import <SPMacros.h>
#import <SPMatrix.h>
#import <SPMovieClip.h>
#import <SPNSExtensions.h>
#import <SPOpenGL.h>
#import <SPOverlayView.h>
#import <SPPoint.h>
#import <SPProgram.h>
#import <SPPVRData.h>
#import <SPQuad.h>
#import <SPQuadBatch.h>
#import <SPRectangle.h>
#import <SPRenderSupport.h>
#import <SPRenderTexture.h>
#import <SPResizeEvent.h>
#import <SPSound.h>
#import <SPSoundChannel.h>
#import <SPSprite.h>
#import <SPStage.h>
#import <SPSubTexture.h>
#import <SPTextField.h>
#import <SPTexture.h>
#import <SPTextureAtlas.h>
#import <SPTouchEvent.h>
#import <SPTransitions.h>
#import <SPTween.h>
#import <SPURLConnection.h>
#import <SPUtils.h>
#import <SPVertexData.h>
#import <SPViewController.h>
#else
#import "SparrowClass.h"
#import "SPAudioEngine.h"
#import "SPBaseEffect.h"
#import "SPBitmapFont.h"
#import "SPBlendMode.h"
#import "SPBlurFilter.h"
#import "SPButton.h"
#import "SPColorMatrix.h"
#import "SPColorMatrixFilter.h"
#import "SPContext.h"
#import "SPDelayedInvocation.h"
#import "SPDisplacementMapFilter.h"
#import "SPDisplayObject.h"
#import "SPDisplayObjectContainer.h"
#import "SPEnterFrameEvent.h"
#import "SPEvent.h"
#import "SPEventDispatcher.h"
#import "SPGLTexture.h"
#import "SPJuggler.h"
#import "SPImage.h"
#import "SPMacros.h"
#import "SPMatrix.h"
#import "SPMovieClip.h"
#import "SPNSExtensions.h"
#import "SPOpenGL.h"
#import "SPOverlayView.h"
#import "SPPoint.h"
#import "SPProgram.h"
#import "SPPVRData.h"
#import "SPQuad.h"
#import "SPQuadBatch.h"
#import "SPRectangle.h"
#import "SPRenderSupport.h"
#import "SPRenderTexture.h"
#import "SPResizeEvent.h"
#import "SPSound.h"
#import "SPSoundChannel.h"
#import "SPSprite.h"
#import "SPStage.h"
#import "SPSubTexture.h"
#import "SPTextField.h"
#import "SPTexture.h"
#import "SPTextureAtlas.h"
#import "SPTouchEvent.h"
#import "SPTransitions.h"
#import "SPTween.h"
#import "SPURLConnection.h"
#import "SPUtils.h"
#import "SPVertexData.h"
#import "SPViewController.h"
#endif
