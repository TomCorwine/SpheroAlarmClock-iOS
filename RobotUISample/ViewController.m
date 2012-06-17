//
//  ViewController.m
//  RobotUISample
//
//  Created by Jon Carroll on 12/9/11.
//  Copyright (c) 2011 Orbotix, Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (void)updateLabelWithDate:(NSDate *)date;
- (NSDateFormatter *)dateFormatter;
@end

@implementation ViewController

- (void)dealloc
{
	_alarmHandler.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	_spheroHandler = [SpheroHandler sharedInstance];
	_alarmHandler = [AlarmHandler sharedInstance];
	_alarmHandler.delegate = self;
	
	NSDate *date = _alarmHandler.alarmDate;
	
	[self updateLabelWithDate:date];
	
	if (date == nil)
		date = [NSDate date];
	
	_datePicker.date = date;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Button Actions

- (IBAction)setButtonWasPressed:(id)sender
{
	NSDate *date = _datePicker.date;
	
	[self updateLabelWithDate:date];
	
	_alarmHandler.alarmDate = date;
}

#pragma mark - Helpers

- (void)updateLabelWithDate:(NSDate *)date
{
	if (date)
		_alarmLabel.text = [[self dateFormatter] stringFromDate:date];
	else
		_alarmLabel.text = nil;
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

- (IBAction)testUp:(id)sender
{
	[[SpheroHandler sharedInstance] stopFlashColors];
	[[SpheroHandler sharedInstance] stopMoving];
}

- (IBAction)testDown:(id)sender
{
	[[SpheroHandler sharedInstance] flashColors];
	[[SpheroHandler sharedInstance] startMoving];
}

#pragma mark - AlarmHandler Delegate

- (void)alarmHandlerSoundAlarm:(AlarmHandler *)alarmHandler
{
	[[SpheroHandler sharedInstance] flashColors];
	[[SpheroHandler sharedInstance] startMoving];
}

@end
