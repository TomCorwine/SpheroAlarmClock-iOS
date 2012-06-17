//
//  SpheroHandler.m
//  RobotUISample
//
//  Created by Thomas Corwine on 6/14/12.
//  Copyright (c) 2012 Orbotix, Inc. All rights reserved.
//

#import "SpheroHandler.h"

@interface SpheroHandler ()
- (void)setupRobotConnection;
- (void)handleRobotOnline;
- (void)updateColors:(NSTimer *)timer;
- (void)updateMotion:(NSTimer *)timer;
@end

@implementation SpheroHandler

+ (SpheroHandler *)sharedInstance
{
	static SpheroHandler *sharedInstance = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[SpheroHandler alloc] init];
	});
	
	return sharedInstance;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
	self = [super init];
	
	if (self)
	{
		_robotOnline = NO;
		[self setupRobotConnection];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
	}
	
	return self;
}

#pragma mark - Application State

- (void)appWillResignActive:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RKDeviceConnectionOnlineNotification object:nil];
    
	[self stopMoving];
	[self stopFlashColors];
	
    [[RKRobotProvider sharedRobotProvider] closeRobotConnection];
	
	_robotOnline = NO;
}

- (void)appDidBecomeActive:(NSNotification*)notification
{
    [self setupRobotConnection];
}

#pragma mark - 

- (void)flashColors
{
	if (_colorTimer || _robotOnline == NO)
		return;
	
	_colorTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateColors:) userInfo:nil repeats:YES];
}

- (void)stopFlashColors
{
	[_colorTimer invalidate];
	_colorTimer = nil;
	
	[RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:0.0 blue:0.0];
}

- (void)startMoving
{
	if (_moveTimer || _robotOnline == NO)
		return;
	
	_moveTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(updateMotion:) userInfo:nil repeats:YES];
}

- (void)stopMoving
{
	[_moveTimer invalidate];
	_moveTimer = nil;
	
	[[RKDriveControl sharedDriveControl].robotControl stopMoving];
}

#pragma mark - Helpers

- (void)setupRobotConnection
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
    
	if ([[RKRobotProvider sharedRobotProvider] isRobotUnderControl])
        [[RKRobotProvider sharedRobotProvider] openRobotConnection];        
}

- (void)handleRobotOnline
{
	_robotOnline = YES;
	
	[RKDriveControl sharedDriveControl].joyStickSize = CGSizeMake(1, 1);
	[RKDriveControl sharedDriveControl].driveTarget = nil;
	[RKDriveControl sharedDriveControl].driveConversionAction = nil;
	[[RKDriveControl sharedDriveControl] startDriving:RKDriveControlJoyStick];
	[RKDriveControl sharedDriveControl].velocityScale = 0.6;
}

- (void)updateColors:(NSTimer *)timer
{	
	float randomRed = (arc4random() % 99) + 1;
	float randomGreen = (arc4random() % 99) + 1;
	float randomBlue = (arc4random() % 79) + 21;
	
	[RKRGBLEDOutputCommand sendCommandWithRed:randomRed*0.1 green:randomGreen*0.1 blue:randomBlue*0.1];
}

- (void)updateMotion:(NSTimer *)timer
{
	float horizontalPosition = (arc4random() % 4) * 25;
	float verticalPosition = (arc4random() % 4) * 25;
	
	[[RKDriveControl sharedDriveControl] driveWithJoyStickPosition:CGPointMake(1.0 / horizontalPosition, 1.0 / verticalPosition)];
}

@end
