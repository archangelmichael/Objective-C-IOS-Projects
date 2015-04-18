//
//  Person.h
//  ProtocolsExtensionsCategories
//
//  Created by Radi on 4/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fighter.h"

@interface Person : NSObject<Fighter>

@property (nonatomic, strong) NSString* name;
@property int age;

@property (strong, nonatomic) NSString * power;

+(id)person;
+(id)personWithName:(NSString *)name;
+(id)personWithName:(NSString *)name
             andAge:(int)age;

-(instancetype)init;
-(instancetype)initWithName:(NSString *)name;
-(instancetype)initWithName:(NSString *)name
                     andAge:(int)age;
@end
