//
//  ViewController.h
//  UserDefaultsActions
//
//  Created by Radi on 6/23/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    IBOutlet UIImageView *contactImageView;
    IBOutlet UITextField *firstNameTextField;
    IBOutlet UITextField *lastNameTextField;
    IBOutlet UITextField *ageTextField;
}

- (IBAction)save:(id)sender;
- (IBAction)chooseImage:(id)sender;


@end

