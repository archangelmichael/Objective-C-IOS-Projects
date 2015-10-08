//
//  HealthKitManager.m
//  HKTutorial
//
//  Created by Radi on 7/23/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "HealthKitManager.h"

@implementation HealthKitManager {
    HKHealthStore * healthStore;
}

#pragma mark Singleton Methods

+ (id)sharedManager {
    static HealthKitManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

+ (id)sharedManagerGCD {
    static HealthKitManager *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.someProperty = @"Default Property Value";
        healthStore = [[HKHealthStore alloc] init];
    }
    return self;
}

- (BOOL)checkifHealthKitIsAvailabile {
    if(NSClassFromString(@"HKHealthStore") && [HKHealthStore isHealthDataAvailable]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)checkForHealthKitAuthrization {
    NSArray * hkObjectTypes = @[[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                                [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
                                [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
                                [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBloodType],
                                [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                                [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount]];
    for (HKObjectType * objectType in hkObjectTypes) {
        if (![healthStore authorizationStatusForType:objectType]) {
            return NO;
        }
    }
    
    return YES;
}

- (void)requestAuthorization:(void(^)(BOOL success, NSError *error)) completionHandler  {
    // Specify which data types you want to share and read. For this you have to create NSSets  of HKObjectType  objects and each object represents a specific data type (e.g. body weight, biological sex, date of birth, number of steps, etc.). Each data type is represented by one of the concrete subclasses HKCategoryType, HKCharacteristicType, HKCorrelationType, HKQuantityType, or HKWorkoutType . For more information, please have a look at the official HKObjectType class reference.
    
    
    // Share body mass, height and body mass index
    NSSet *shareObjectTypes = [NSSet setWithObjects:
                               [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                               [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                               [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
                               nil];
    
    // Read date of birth, biological sex and step count
    NSSet *readObjectTypes  = [NSSet setWithObjects:
                               [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
                               [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBloodType],
                               [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                               [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                               nil];
    
    // Request access
    [healthStore requestAuthorizationToShareTypes:shareObjectTypes
                                        readTypes:readObjectTypes
                                       completion:completionHandler];
}

- (NSDate *)getUserBirthDate {
    NSError * error;
    NSDate * birthDate;
    
    birthDate = [healthStore dateOfBirthWithError:&error];
    if (error) {
        return nil;
    }
    
    return birthDate;
}

- (NSString *)getUserSex {
    NSError * error;
    HKBiologicalSexObject * bioSex = [healthStore biologicalSexWithError:&error];
    if (error) {
        return @"Sex not available";
    }
    
    switch (bioSex.biologicalSex) {
        case HKBiologicalSexOther: return @"Other"; break;
        case HKBiologicalSexNotSet: return @"Not set"; break;
        case HKBiologicalSexFemale: return @"Male"; break;
        case HKBiologicalSexMale: return @"Female"; break;
    }
}

- (NSString *)getUserBloodType {
    NSError * error;
    HKBloodTypeObject * bloodType = [healthStore bloodTypeWithError:&error];
    if (error) {
        return @"Blood type not available";
    }
    
    switch (bloodType.bloodType) {
        case HKBloodTypeABNegative: return @"AB-"; break;
        case HKBloodTypeANegative: return @"A-"; break;
        case HKBloodTypeBNegative: return @"B-"; break;
        case HKBloodTypeABPositive: return @"AB+"; break;
        case HKBloodTypeAPositive: return @"A+"; break;
        case HKBloodTypeBPositive: return @"B+"; break;
        case HKBloodTypeNotSet: return @"Not set"; break;
        case HKBloodTypeONegative: return @"0-"; break;
        case HKBloodTypeOPositive: return @"0+"; break;
    }
}

- (void)getUserWeight:(void(^)(HKSample * sample, NSError *error))completionHandler {
    HKSampleType * weightType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    [self getMostRecentSample:weightType
                    startDate:nil
                      endDate:nil
            completionHandler:completionHandler];
}

- (void)getUserHeight:(void(^)(HKSample * sample, NSError *error))completionHandler {
    HKSampleType * heightType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    [self getMostRecentSample:heightType
                    startDate:nil
                      endDate:nil
            completionHandler:completionHandler];
}

- (void)getUserBodyMassIndex {
    NSError * error;
    //double bodyMassIndex = [healthStore :&error];
    if (error) {
        //return @"Not available";
    }
}

- (void)getMostRecentSample:(HKSampleType *)sampleType
                  startDate:(NSDate *)startDate
                    endDate:(NSDate *)endDate
          completionHandler:(void(^)(HKSample * sample, NSError *error))completionHandler {
    endDate = endDate ? endDate : [NSDate date];
    if (!startDate) {
        NSDateComponents * componenets = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear
                                                                         fromDate:[NSDate date]];
        componenets.year -= 2;
        startDate = [[NSCalendar currentCalendar] dateFromComponents:componenets];
    }
   
    NSPredicate * predicate = [HKQuery predicateForSamplesWithStartDate:startDate
                                                                endDate:endDate
                                                                options:HKQueryOptionNone];
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate
                                                                      ascending:NO];
    int limit = 4;
    HKSampleQuery * query = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                            predicate:predicate
                                                                limit:limit
                                                      sortDescriptors:@[sortDescriptor]
                                                       resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                           if (error) {
                                                               completionHandler(nil, error);
                                                               return;
                                                           }
                                                           
                                                           HKQuantitySample * mostRecent = [results firstObject];
                                                           if (completionHandler != nil) {
                                                               completionHandler(mostRecent, nil);
                                                           }
                                                       }];
    [healthStore executeQuery:query];
}

- (void)getUserStepCountFrom:(NSDate *)startDate
                          to:(NSDate *)endDate
           completionHandler:(void(^)(HKSampleQuery *query, NSArray *results, NSError *error))completionHandler{
    // Query the step count within a given time span of the user
    
    // Use the sample type for step count
    HKSampleType * sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    // Create a predicate to set start/end date bounds of the query
    NSPredicate * predicate = [HKQuery predicateForSamplesWithStartDate:startDate
                                                                endDate:endDate
                                                                options:HKQueryOptionStrictStartDate];
    
    // Create a sort descriptor for sorting by start date
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    
    HKSampleQuery * sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                                  predicate:predicate
                                                                      limit:HKObjectQueryNoLimit
                                                            sortDescriptors:@[sortDescriptor]
                                                             resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                                 if(!error && results) {
                                                                     for(HKQuantitySample * samples in results) {
                                                                         // your code here
                                                                     }
                                                                 }
                                                             }];
    
    // Execute the query
    [healthStore executeQuery:sampleQuery];
}

- (void)changeUserWeightWithValue:(double)weight
                completionHandler:(void(^)(BOOL success, NSError *error)) completionHandler {
    // Some weight in gram
    double weightInGram = weight * 1000;
    
    // Create an instance of HKQuantityType and
    // HKQuantity to specify the data type and value
    // you want to update
    NSDate          *now = [NSDate date];
    HKQuantityType  *hkQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantity      *hkQuantity = [HKQuantity quantityWithUnit:[HKUnit gramUnit]
                                                   doubleValue:weightInGram];
    
    // Create the concrete sample
    HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:hkQuantityType
                                                                     quantity:hkQuantity
                                                                    startDate:now
                                                                      endDate:now];
    
    // Update the weight in the health store
    [healthStore saveObject:weightSample
             withCompletion:completionHandler];
}

- (void)changeUserHeightWithValue:(double)height
                completionHandler:(void(^)(BOOL success, NSError *error)) completionHandler {
    // Some weight in gram
    double heightInCantimeters = height ? height : 180;
    
    // Create an instance of HKQuantityType and
    // HKQuantity to specify the data type and value
    // you want to update
    NSDate          *now = [NSDate date];
    HKQuantityType  *hkQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantity      *hkQuantity = [HKQuantity quantityWithUnit:[HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitCentimeter]
                                                   doubleValue:heightInCantimeters];
    
    // Create the concrete sample
    HKQuantitySample * heightSample = [HKQuantitySample quantitySampleWithType:hkQuantityType
                                                                      quantity:hkQuantity
                                                                     startDate:now
                                                                       endDate:now];
    
    // Update the weight in the health store
    [healthStore saveObject:heightSample
             withCompletion:completionHandler];
}

@end
