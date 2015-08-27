//
//  Candy.m
//  TestProject
//
//  Created by Radi on 8/21/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "Candy.h"

@implementation Candy

-(instancetype)init {
    return [self initWithName:@"Unnamed" category:@"No category"];
}

-(instancetype)initWithName:(NSString *)name category:(NSString *)category {
    self = [super init];
    if (self) {
        self.name = name;
        self.category = category;
    }
    
    return self;
}

@end
