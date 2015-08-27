//
//  Candy.h
//  TestProject
//
//  Created by Radi on 8/21/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Candy : NSObject

-(instancetype)init;
-(instancetype)initWithName:(NSString *)name category:(NSString *)category;

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * category;

@end
