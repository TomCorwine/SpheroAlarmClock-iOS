//
//  SpheroHandler.h
//  RobotUISample
//
//  Created by Thomas Corwine on 6/14/12.
//  Copyright (c) 2012 Orbotix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <RobotKit/RobotKit.h>

@interface SpheroHandler : NSObject
{
	NSTimer *_colorTimer;
	NSTimer *_moveTimer;
	
	BOOL _robotOnline;
}

+ (SpheroHandler *)sharedInstance;

- (void)flashColors;
- (void)stopFlashColors;

- (void)startMoving;
- (void)stopMoving;

@end
