//
//  Person.m
//  ProtocolsExtensionsCategories
//
//  Created by Radi on 4/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "Person.h"
#import "Person_Swimmer.h"

@implementation Person {
    // BOOL isRetired;
}

@synthesize age = _age;

NSString * const PERSON_DEFAULT_NAME = @"Unknown";
const int PERSON_DEFAULT_AGE = 10;

-(int)age {
    return _age;
}

-(void)setAge:(int)age {
    if (age <= 0) {
        [[NSException exceptionWithName:@"Invalid age"
                                reason:@"Age must be positive"
                               userInfo:nil] raise];
    }
    
    self->_age = age;
}

+(id)person {
    return [self personWithName:PERSON_DEFAULT_NAME
                         andAge:PERSON_DEFAULT_AGE];
}
+(id)personWithName:(NSString *)name {
    return [self personWithName:name
                         andAge:PERSON_DEFAULT_AGE];
}
+(id)personWithName:(NSString *)name
             andAge:(int)age{
    Person* someone = [[Person alloc] initWithName:name
                                           andAge:age];
    return someone;
    
}

-(instancetype)init {
    return [self initWithName:PERSON_DEFAULT_NAME
                       andAge:PERSON_DEFAULT_AGE];
}
-(instancetype)initWithName:(NSString *)name{
    return [self initWithName:name
                       andAge:PERSON_DEFAULT_AGE];
}
-(instancetype)initWithName:(NSString *)name
                     andAge:(int)age{
    self = [super init];
    if (self) {
        self.name = name;
        self.age = age;
        self.power = @"hard";
        isRetired = false;
    }
    
    return self;
}

-(void)hit{
    if (isRetired) {
        NSLog(@"%@ wont fight. He is retired", self.name);
    }
    else {
        NSLog(@"%@ just punched you %@", self.name, self.power);
    }
}

-(void)retire {
    isRetired = true;
    NSLog(@"%@ retired", self.name);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ is %i years old", self.name, self.age];
}

@end
