//
//  ViewController.h
//  HKTutorial
//
//  Created by Radi on 7/23/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *f1;

@property (weak, nonatomic) IBOutlet UILabel *f2;

@property (weak, nonatomic) IBOutlet UILabel *f3;

@property (weak, nonatomic) IBOutlet UILabel *f4;

@property (weak, nonatomic) IBOutlet UILabel *f5;

@property (weak, nonatomic) IBOutlet UILabel *f6;

@property (weak, nonatomic) IBOutlet UIButton *b1;

@property (weak, nonatomic) IBOutlet UIButton *b2;

- (IBAction)requestHealthKitAuthorization:(id)sender;

- (IBAction)saveChanges:(id)sender;

@end

