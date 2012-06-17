//
//  ViewController.h
//  RobotUISample
//
//  Created by Jon Carroll on 12/9/11.
//  Copyright (c) 2011 Orbotix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SpheroHandler.h"
#import "AlarmHandler.h"

@interface ViewController : UIViewController <AlarmHandlerDelegate>
{	
	IBOutlet UIDatePicker *_datePicker;
	IBOutlet UILabel *_alarmLabel;
	
	SpheroHandler *_spheroHandler;
	AlarmHandler *_alarmHandler;
}

- (IBAction)setButtonWasPressed:(id)sender;

- (IBAction)testUp:(id)sender;
- (IBAction)testDown:(id)sender;

@end

