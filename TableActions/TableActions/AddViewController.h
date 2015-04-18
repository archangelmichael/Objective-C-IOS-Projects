//
//  AddViewController.h
//  TableActions
//
//  Created by Radi on 4/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import "DataManager.h"

@interface AddViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailsText;

- (IBAction)saveTodo:(id)sender;
@end
