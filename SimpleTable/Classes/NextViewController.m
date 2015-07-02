//
//  NextViewController.m
//  SimpleTable
//
//  Created by Adeem on 17/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NextViewController.h"


@implementation NextViewController {
    BOOL isInEditMode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isInEditMode = NO;
    self.editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(onEditButtonClick:)];
    [self.navigationItem setRightBarButtonItem:self.editButton];

    
    self.devTitle.delegate = self;
    self.devYear.delegate = self;
    self.devManufacturer.delegate = self;
    
    [self setTextFieldsEnabledTo:NO];
    
    if (self.selectedDevice != nil) {
        self.devTitle.text = self.selectedDevice.title;
        self.devYear.text = [NSString stringWithFormat:@"%i", self.selectedDevice.year];
        self.devManufacturer.text = self.selectedDevice.manufacturer;
    }
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(onTapScreen:)];
    self.tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.tapRecognizer];
    
}

- (IBAction)onEditButtonClick:(id)sender {
    if (isInEditMode) {
        [self onSaveChanges:nil];
        [self.editButton setTitle:@"Edit"];
        [self setTextFieldsEnabledTo:NO];
    }
    else {
        [self.editButton setTitle:@"Save Changes"];
        [self setTextFieldsEnabledTo:YES];
    }
    
    isInEditMode = !isInEditMode;
}

- (IBAction)onSaveChanges:(id)sender {
    self.selectedDevice.title = self.devTitle.text;
    self.selectedDevice.year = [self.devYear.text intValue];
    self.selectedDevice.manufacturer = self.devManufacturer.text;
}

-(void)setTextFieldsEnabledTo:(BOOL)areEnabled {
    [self.devTitle setEnabled:areEnabled];
    [self.devYear setEnabled:areEnabled];
    [self.devManufacturer setEnabled:areEnabled];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onTapScreen:(UITapGestureRecognizer *)recognizer {
    [self.devTitle resignFirstResponder];
    [self.devYear resignFirstResponder];
    [self.devManufacturer resignFirstResponder];
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}
@end
