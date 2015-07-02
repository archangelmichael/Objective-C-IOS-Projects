//
//  NextViewController.h
//  SimpleTable
//
//  Created by Adeem on 17/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface NextViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) Device * selectedDevice;

@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) IBOutlet UIBarButtonItem * editButton;

@property (retain, nonatomic) IBOutlet UITextField *devTitle;

@property (retain, nonatomic) IBOutlet UITextField *devYear;

@property (retain, nonatomic) IBOutlet UITextField *devManufacturer;
@end
