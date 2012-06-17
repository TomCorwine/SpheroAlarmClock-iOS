//
//  AlarmHandler.h
//  RobotUISample
//
//  Created by Thomas Corwine on 6/14/12.
//  Copyright (c) 2012 Orbotix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlarmHandler;

@protocol AlarmHandlerDelegate <NSObject>
- (void)alarmHandlerSoundAlarm:(AlarmHandler *)alarmHandler;
@end

@interface AlarmHandler : NSObject
{
	__weak id <AlarmHandlerDelegate> _delegate;
	
	NSDate *_alarmDate;
	NSTimer *_alarmTimer;
}

@property (weak) id <AlarmHandlerDelegate> delegate;
@property (strong) NSDate *alarmDate;

+ (AlarmHandler *)sharedInstance;

@end
