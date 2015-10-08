//
//  ViewController.m
//  HKTutorial
//
//  Created by Radi on 7/23/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ViewController.h"

#import <HealthKit/HealthKit.h>
#import "HealthKitManager.h"

@interface ViewController () {
    HealthKitManager * healthManager;
    BOOL healthKitIsAvailable;
    BOOL hasHealthKitAuthorization;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Step 0 - Add project to provision profile and allow HealthKit form 'Capabilities' tab
    
    // Step 1 - Create Singleton instance to work with health kit
    healthManager = [HealthKitManager sharedManager];
    
    // Step 2 - Check if Health Kit is available
    healthKitIsAvailable = [healthManager checkifHealthKitIsAvailabile];
    hasHealthKitAuthorization = [healthManager checkForHealthKitAuthrization];
    
    [self setFieldsVisibilityTo:healthKitIsAvailable];
    
    // Step 3 - Request Authorization
    if (!hasHealthKitAuthorization && healthKitIsAvailable) {
        [healthManager requestAuthorization:^(BOOL success, NSError *error) {
            if(success == YES) {
                hasHealthKitAuthorization = YES;
            }
            else {
                hasHealthKitAuthorization = NO;
            }
        }];
    }
    
    if (healthKitIsAvailable && hasHealthKitAuthorization) {
        [self fetchUserData];
    }
}

- (void)setFieldsVisibilityTo:(BOOL)visible {
    self.f1.hidden = self.f2.hidden = self.f3.hidden = self.f4.hidden = self.f5.hidden =
    self.b1.hidden = self.b2.hidden = !visible;
}

- (void)fetchUserData {
    NSDate * userBirthDate = [healthManager getUserBirthDate];
    int userAge;
    NSString * userBirthDateString;
    if (userBirthDate != nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd MMMM yyyy"];
        userBirthDateString = [formatter stringFromDate:userBirthDate];
        
        NSCalendar * calendar = [NSCalendar currentCalendar];
        NSDateComponents * components = [calendar components:NSCalendarUnitYear
                                                    fromDate:userBirthDate
                                                      toDate:[NSDate date]
                                                     options:0];
        userAge = (int)components.year;
    }
    
    self.f1.text = userAge ? [NSString stringWithFormat:@"%i", userAge] : @"Age not available";
    self.f2.text = userBirthDateString ? userBirthDateString : @"Birthdate not available";
    
    self.f3.text = [healthManager getUserSex];
    self.f4.text = [healthManager getUserBloodType];
    
    [healthManager getUserWeight:^(HKSample * mostRecentWeight, NSError *error) {
        if (error) {
            NSLog(@"Problem fetching weight : %@", error.localizedDescription);
            self.f5.text = @"Weight not available";
            return;
        }
        
        NSString * weightString = @"Weight not available";
        HKQuantitySample * weightSample = (HKQuantitySample *)mostRecentWeight;
        double kilos = [[weightSample quantity] doubleValueForUnit:[HKUnit gramUnitWithMetricPrefix:HKMetricPrefixKilo]];
        if (kilos) {
            NSMassFormatter * weightFormatter = [[NSMassFormatter alloc] init];
            weightFormatter.forPersonMassUse = YES;
            weightString = [weightFormatter stringFromValue:kilos unit:NSMassFormatterUnitKilogram];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.f5.text = weightString;
        });
    }];
    
    [healthManager getUserHeight:^(HKSample * mostRecentHeight, NSError *error) {
        if (error) {
            NSLog(@"Problem fetching height : %@", error.localizedDescription);
            self.f6.text = @"Height not available";
            return;
        }
        
        NSString * heightString = @"Height not available";
        HKQuantitySample * heightSample = (HKQuantitySample *)mostRecentHeight;
        double meters = [[heightSample quantity] doubleValueForUnit:[HKUnit meterUnitWithMetricPrefix:HKMetricPrefixNone]];
        
        if (meters) {
            NSLengthFormatter * heightFormatter = [[NSLengthFormatter alloc] init];
            heightFormatter.forPersonHeightUse = YES;
            heightString = [heightFormatter stringFromValue:meters unit:NSLengthFormatterUnitMeter];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.f6.text = heightString;
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestHealthKitAuthorization:(id)sender {
    if (hasHealthKitAuthorization) {
        [[[UIAlertView alloc] initWithTitle:@"Authorization already received"
                                    message:@""
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];

    }
    else {
        [healthManager requestAuthorization:^(BOOL success, NSError *error) {
            if(success == YES) {
                hasHealthKitAuthorization = YES;
                [[[UIAlertView alloc] initWithTitle:@"Authorization successful"
                                            message:@""
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil] show];
            }
            else {
                hasHealthKitAuthorization = NO;
                [[[UIAlertView alloc] initWithTitle:@"Authorization failed"
                                            message:@""
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil] show];
                
            }
        }];
    }
}

- (IBAction)saveChanges:(id)sender {
    [healthManager changeUserWeightWithValue:100.0
                           completionHandler:^(BOOL success, NSError *error) {
                               if (success) {
                                   [[[UIAlertView alloc] initWithTitle:@"Save successful"
                                                               message:@""
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles: nil] show];
                               }
                               else {
                                   [[[UIAlertView alloc] initWithTitle:@"Save failed"
                                                               message:@""
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles: nil] show];
                               }
                           }];
    
    [healthManager changeUserHeightWithValue:190
                           completionHandler:^(BOOL success, NSError *error) {
                               if (success) {
                                   [[[UIAlertView alloc] initWithTitle:@"Save successful"
                                                               message:@""
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles: nil] show];
                               }
                               else {
                                   [[[UIAlertView alloc] initWithTitle:@"Save failed"
                                                               message:@""
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles: nil] show];
                               }
                           }];
}
@end
