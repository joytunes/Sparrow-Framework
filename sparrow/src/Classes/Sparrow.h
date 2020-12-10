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
#import <Sparrow/SparrowClass.h>
#import <Sparrow/SPAudioEngine.h>
#import <Sparrow/SPBaseEffect.h>
#import <Sparrow/SPBitmapFont.h>
#import <Sparrow/SPBlendMode.h>
#import <Sparrow/SPBlurFilter.h>
#import <Sparrow/SPButton.h>
#import <Sparrow/SPColorMatrix.h>
#import <Sparrow/SPColorMatrixFilter.h>
#import <Sparrow/SPContext.h>
#import <Sparrow/SPDelayedInvocation.h>
#import <Sparrow/SPDisplacementMapFilter.h>
#import <Sparrow/SPDisplayObject.h>
#import <Sparrow/SPDisplayObjectContainer.h>
#import <Sparrow/SPEnterFrameEvent.h>
#import <Sparrow/SPEvent.h>
#import <Sparrow/SPEventDispatcher.h>
#import <Sparrow/SPGLTexture.h>
#import <Sparrow/SPJuggler.h>
#import <Sparrow/SPImage.h>
#import <Sparrow/SPMacros.h>
#import <Sparrow/SPMatrix.h>
#import <Sparrow/SPMovieClip.h>
#import <Sparrow/SPNSExtensions.h>
#import <Sparrow/SPOpenGL.h>
#import <Sparrow/SPOverlayView.h>
#import <Sparrow/SPPoint.h>
#import <Sparrow/SPProgram.h>
#import <Sparrow/SPPVRData.h>
#import <Sparrow/SPQuad.h>
#import <Sparrow/SPQuadBatch.h>
#import <Sparrow/SPRectangle.h>
#import <Sparrow/SPRenderSupport.h>
#import <Sparrow/SPRenderTexture.h>
#import <Sparrow/SPResizeEvent.h>
#import <Sparrow/SPSound.h>
#import <Sparrow/SPSoundChannel.h>
#import <Sparrow/SPSprite.h>
#import <Sparrow/SPStage.h>
#import <Sparrow/SPSubTexture.h>
#import <Sparrow/SPTextField.h>
#import <Sparrow/SPTexture.h>
#import <Sparrow/SPTextureAtlas.h>
#import <Sparrow/SPTouchEvent.h>
#import <Sparrow/SPTransitions.h>
#import <Sparrow/SPTween.h>
#import <Sparrow/SPURLConnection.h>
#import <Sparrow/SPUtils.h>
#import <Sparrow/SPVertexData.h>
#import <Sparrow/SPViewController.h>
#endif
