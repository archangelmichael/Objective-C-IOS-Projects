//
//  Bunny.h
//  BunnyClasses
//
//  Created by Radi on 4/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bunny : NSObject

@property int jumpSize;

-(id) init;

+(id) bunnyWithJumpLenght:(int)jumpLenght;

@end
