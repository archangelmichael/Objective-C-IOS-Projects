//
//  EditInfoViewController.h
//  SQLite3DBActions
//
//  Created by Radi on 4/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

// PROTOCOL to inform table view that data has been changed
@protocol EditInfoViewControllerDelegate

-(void)editingInfoWasFinished;

@end

@interface EditInfoViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFirstname;

@property (weak, nonatomic) IBOutlet UITextField *textLastname;

@property (weak, nonatomic) IBOutlet UITextField *textAge;

@property (nonatomic, strong) DBManager *dbManager;

// Delegate meeting EditInfoViewControllerDelegate protocol
@property (nonatomic, strong) id<EditInfoViewControllerDelegate> delegate;

@property (nonatomic) int recordIDToEdit;

-(void)loadInfoToEdit;

- (IBAction)saveInfo:(id)sender;

@end
