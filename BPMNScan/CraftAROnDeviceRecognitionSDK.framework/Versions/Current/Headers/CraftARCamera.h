// This file is free software. You may use it under the MIT license, which is copied
// below and available at http://opensource.org/licenses/MIT
//
// Copyright (c) 2015 Catchoom Technologies S.L.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
// Software, and to permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "CraftARProtocols.h"

/**
 * Class that allows basic control of the device's camera
 */
@interface CraftARCamera : NSObject

/// Delegate that will receive the camera events
@property (nonatomic, weak) id <CameraEventsProtocol> delegate;

/**
 * Pause the camera video capture.
 * The camera will stop generating didReceivePreviewFrame events.
 */
- (void) pauseCapture;

/**
 * Restart the camera video capture
 * If the camera capture was open, the capture is reinitialized.
 */
- (void) restartCapture;

/**
 * Returns true if the camera capture is running (not paused)
 */
- (BOOL) isCapturing;


/**
 * Triggers the camera's autofocus feature trying to focus at a
 * given point on the capture image.
 */
- (void) triggerFocusAtPoint: (CGPoint)pointOfinterest;

@end
