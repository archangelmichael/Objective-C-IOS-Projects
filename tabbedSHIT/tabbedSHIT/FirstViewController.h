//
//  FirstViewController.h
//  tabbedSHIT
//
//  Created by Radi on 6/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface FirstViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView * subview;

-(IBAction)goBack:(UIStoryboardSegue *)segue;

@end

