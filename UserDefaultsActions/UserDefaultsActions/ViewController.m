//
//  ViewController.m
//  UserDefaultsActions
//
//  Created by Radi on 6/23/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {// Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *firstName = [defaults objectForKey:@"firstName"];
    NSString *lastName = [defaults objectForKey:@"lastname"];
    
    long age = [defaults integerForKey:@"age"];
    NSString *ageString = [NSString stringWithFormat:@"%li",age];
    
    NSData *imageData = [defaults dataForKey:@"image"];
    UIImage *contactImage = [UIImage imageWithData:imageData];
    
    // Update the UI elements with the saved data
    firstNameTextField.text = firstName;
    lastNameTextField.text = lastName;
    ageTextField.text = ageString;
    if (contactImage != nil) {
        contactImageView.image = contactImage;
    }
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender {
    // Hide the keyboard
    [firstNameTextField resignFirstResponder];
    [lastNameTextField resignFirstResponder];
    [ageTextField resignFirstResponder];
    
    // Create strings and integer to store the text info
    NSString *firstName = [firstNameTextField text];
    NSString *lastName  = [lastNameTextField text];
    long age = [ageTextField.text integerValue];
    
    // Create instances of NSData
    UIImage *contactImage = contactImageView.image;
    NSData *imageData = UIImageJPEGRepresentation(contactImage, 100);
    
    
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:firstName forKey:@"firstName"];
    [defaults setObject:lastName forKey:@"lastname"];
    [defaults setInteger:age forKey:@"age"];
    [defaults setObject:imageData forKey:@"image"];
    
    [defaults synchronize];
    
    NSLog(@"Data saved");
}

- (IBAction)chooseImage:(id)sender {
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    
    contactImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
