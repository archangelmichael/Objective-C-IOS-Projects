//
//  LoginVC.m
//  PushNotifications
//
//  Created by Radi on 8/27/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "LoginVC.h"
#import "AppDelegate.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (weak, nonatomic) IBOutlet UITextField *password;
@end

@implementation LoginVC {
    AppDelegate * app;
    PFUser * loggedUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.username.delegate = self.password.delegate = self;
    loggedUser = [app loadUserData];
    if (loggedUser) {
        [self loginUser];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    NSString * enteredUsername = self.username.text;
    NSString * enteredPassword = self.password.text;
    if (enteredUsername.length < 4 || enteredPassword.length < 4) {
        return;
    }
    
    loggedUser = [PFUser user];
    loggedUser.username = enteredUsername;
    loggedUser.password = enteredPassword;
    loggedUser.email = @"email@example.com";
    // user[@"phone"] = @"415-392-0202";
    [self loginUser];
}

-(void)loginUser {
    [self.loading startAnimating];
    [loggedUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [app setUserDefaultUsername:loggedUser.username password:loggedUser.password];
            [self performSegueWithIdentifier:@"goToMessagesVC" sender:self];
            [self.loading stopAnimating];
        } else {
            // NSLog(@"Register error: %@", error.userInfo);
            [PFUser logInWithUsernameInBackground:loggedUser.username
                                         password:loggedUser.password
                                            block:^(PFUser *user, NSError *error) {
                                                if (user) {
                                                    [app setUserDefaultUsername:loggedUser.username password:loggedUser.password];
                                                    [self performSegueWithIdentifier:@"goToMessagesVC" sender:self];
                                                    [self.loading stopAnimating];
                                                } else {
                                                    loggedUser = nil;
                                                    [app setUserDefaultUsername:@"" password:@""];
                                                    NSLog(@"Register error: %@", error.userInfo);
                                                    [self.loading stopAnimating];
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
