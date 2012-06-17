//
//  AlarmHandler.m
//  RobotUISample
//
//  Created by Thomas Corwine on 6/14/12.
//  Copyright (c) 2012 Orbotix, Inc. All rights reserved.
//

#import "AlarmHandler.h"

#define kAlarmHandler_UserDefaultsAlarmDateKey				@"AlarmHandler_UserDefaultsAlarmDateKey"

@interface AlarmHandler ()
- (void)alarmTimer:(NSTimer *)timer;
- (NSDateFormatter *)dateFormatter;
@end

@implementation AlarmHandler

@synthesize delegate = _delegate;

+ (AlarmHandler *)sharedInstance
{
	static AlarmHandler *sharedInstance = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[AlarmHandler alloc] init];
	});
	
	return sharedInstance;
}

- (void)dealloc
{
	[_alarmTimer invalidate];
}

- (id)init
{
	self = [super init];
	
	if (self)
	{
		_alarmDate = [[NSUserDefaults standardUserDefaults] objectForKey:kAlarmHandler_UserDefaultsAlarmDateKey];
		_alarmTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(alarmTimer:) userInfo:nil repeats:YES];
	}
	
	return self;
}

#pragma mark - Accessors

- (void)setAlarmDate:(NSDate *)alarmDate
{
	_alarmDate = alarmDate;
	
	[[NSUserDefaults standardUserDefaults] setObject:alarmDate forKey:kAlarmHandler_UserDefaultsAlarmDateKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate *)alarmDate
{
	return _alarmDate;
}

#pragma mark - Helpers

- (void)alarmTimer:(NSTimer *)timer
{	
	NSString *currentTimeString = [[self dateFormatter] stringFromDate:[NSDate date]];
	NSString *alarmTimeString = [[self dateFormatter] stringFromDate:_alarmDate];

	if ([alarmTimeString isEqualToString:currentTimeString])
	{
		if ([_delegate respondsToSelector:@selector(alarmHandlerSoundAlarm:)])
			[_delegate alarmHandlerSoundAlarm:self];
	}
}

- (NSDateFormatter *)dateFormatter
{
	static NSDateFormatter *dateFormatter = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"h:mm a";
	});
	
	return dateFormatter;
}

@end
