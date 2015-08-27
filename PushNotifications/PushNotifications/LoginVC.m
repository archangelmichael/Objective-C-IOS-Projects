//
//  LoginVC.m
//  PushNotifications
//
//  Created by Radi on 8/27/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "LoginVC.h"
#import <Parse/Parse.h>

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.username.delegate = self.password.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.username.text;
    user.password = self.password.text;
    user.email = @"email@example.com";
    if (user.username.length < 4 || user.password.length < 4) {
        return;
    }
    
    // user[@"phone"] = @"415-392-0202";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            [self performSegueWithIdentifier:@"goToMessagesVC" sender:self];
        } else {
            NSLog(@"Register error: %@", error.userInfo);
            // Show the errorString somewhere and let the user try again.
            [PFUser logInWithUsernameInBackground:self.username.text
                                         password:self.password.text
                                            block:^(PFUser *user, NSError *error) {
                                                if (user) {
                                                    // Do stuff after successful login.
                                                    [self performSegueWithIdentifier:@"goToMessagesVC" sender:self];
                                                } else {
                                                    // The login failed. Check error to see why.
                                                    NSLog(@"Register error: %@", error.userInfo);
                                                }
                                            }];
        }
    }];
}

#pragma mark UITextFieldDelegate 
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField becomeFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
