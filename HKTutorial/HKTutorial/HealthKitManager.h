//
//  HealthKitManager.h
//  HKTutorial
//
//  Created by Radi on 7/23/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <HealthKit/HealthKit.h>

@interface HealthKitManager : NSObject

@property (nonatomic, retain) NSString * someProperty;

+ (id)sharedManager;
+ (id)sharedManagerGCD;

// HealthKit availability
- (BOOL)checkifHealthKitIsAvailabile;
- (BOOL)checkForHealthKitAuthrization;
- (void)requestAuthorization:(void(^)(BOOL success, NSError *error)) completionHandler;

// HealthKit fetch data requests
- (NSDate *)getUserBirthDate;
- (NSString *)getUserSex;
- (NSString *)getUserBloodType;
- (void)getUserWeight:(void(^)(HKSample * sample, NSError *error))completionHandler;
- (void)getUserHeight:(void(^)(HKSample * sample, NSError *error))completionHandler;
- (void)getUserBodyMassIndex;


// HealthKit update data requests
- (void)changeUserWeightWithValue:(double)weight
                completionHandler:(void(^)(BOOL success, NSError *error)) completionHandler;
- (void)changeUserHeightWithValue:(double)height
                completionHandler:(void(^)(BOOL success, NSError *error)) completionHandler;
@end
