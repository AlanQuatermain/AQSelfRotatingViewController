/*
 * AQSelfRotatingViewController.m
 * AQSelfRotatingViewController
 * 
 * Created by Jim Dovey on 16/02/2011.
 * 
 * Copyright (c) 2011 Jim Dovey
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * 
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 * 
 * Neither the name of the project's author nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#import <UIKit/UIKit.h>
#import "AQSelfRotatingViewController.h"

@implementation AQSelfRotatingViewController

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    
    // register for orientation change notification
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(orientationWillChange:)
												 name: UIApplicationWillChangeStatusBarOrientationNotification
											   object: nil];
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(orientationDidChange:)
												 name: UIApplicationDidChangeStatusBarOrientationNotification
                                               object: nil];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [super viewWillDisappear: animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: UIApplicationWillChangeStatusBarOrientationNotification
                                                  object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: UIApplicationDidChangeStatusBarOrientationNotification
                                                  object: nil];
}

- (void) orientationWillChange: (NSNotification *) note
{
	UIInterfaceOrientation current = [[UIApplication sharedApplication] statusBarOrientation];
	UIInterfaceOrientation orientation = [[[note userInfo] objectForKey: UIApplicationStatusBarOrientationUserInfoKey] integerValue];
	if ( [self shouldAutorotateToInterfaceOrientation: orientation] == NO )
		return;
	
	if ( current == orientation )
		return;
	
	// direction and angle
	CGFloat angle = 0.0;
	switch ( current )
	{
		case UIInterfaceOrientationPortrait:
		{
			switch ( orientation )
			{
				case UIInterfaceOrientationPortraitUpsideDown:
					angle = (CGFloat)M_PI;	// 180.0*M_PI/180.0 == M_PI
					break;
				case UIInterfaceOrientationLandscapeLeft:
					angle = (CGFloat)(M_PI*-90.0)/180.0;
					break;
				case UIInterfaceOrientationLandscapeRight:
					angle = (CGFloat)(M_PI*90.0)/180.0;
					break;
				default:
					return;
			}
			break;
		}
		case UIInterfaceOrientationPortraitUpsideDown:
		{
			switch ( orientation )
			{
				case UIInterfaceOrientationPortrait:
					angle = (CGFloat)M_PI;	// 180.0*M_PI/180.0 == M_PI
					break;
				case UIInterfaceOrientationLandscapeLeft:
					angle = (CGFloat)(M_PI*90.0)/180.0;
					break;
				case UIInterfaceOrientationLandscapeRight:
					angle = (CGFloat)(M_PI*-90.0)/180.0;
					break;
				default:
					return;
			}
			break;
		}
		case UIInterfaceOrientationLandscapeLeft:
		{
			switch ( orientation )
			{
				case UIInterfaceOrientationLandscapeRight:
					angle = (CGFloat)M_PI;	// 180.0*M_PI/180.0 == M_PI
					break;
				case UIInterfaceOrientationPortraitUpsideDown:
					angle = (CGFloat)(M_PI*-90.0)/180.0;
					break;
				case UIInterfaceOrientationPortrait:
					angle = (CGFloat)(M_PI*90.0)/180.0;
					break;
				default:
					return;
			}
			break;
		}
		case UIInterfaceOrientationLandscapeRight:
		{
			switch ( orientation )
			{
				case UIInterfaceOrientationLandscapeLeft:
					angle = (CGFloat)M_PI;	// 180.0*M_PI/180.0 == M_PI
					break;
				case UIInterfaceOrientationPortrait:
					angle = (CGFloat)(M_PI*-90.0)/180.0;
					break;
				case UIInterfaceOrientationPortraitUpsideDown:
					angle = (CGFloat)(M_PI*90.0)/180.0;
					break;
				default:
					return;
			}
			break;
		}
	}

	CGAffineTransform rotation = CGAffineTransformMakeRotation( angle );
	
	[UIView beginAnimations: @"" context: NULL];
	[UIView setAnimationDuration: 0.4];
	self.view.transform = CGAffineTransformConcat(rotation, self.view.transform);
	[UIView commitAnimations];
}

- (void) orientationDidChange: (NSNotification *) note
{
	UIInterfaceOrientation orientation = [[[note userInfo] objectForKey: UIApplicationStatusBarOrientationUserInfoKey] integerValue];
	if ( [self shouldAutorotateToInterfaceOrientation: [[UIApplication sharedApplication] statusBarOrientation]] == NO )
		return;
	
	self.view.frame = [[UIScreen mainScreen] applicationFrame];
	
	[self didRotateFromInterfaceOrientation: orientation];
}

@end