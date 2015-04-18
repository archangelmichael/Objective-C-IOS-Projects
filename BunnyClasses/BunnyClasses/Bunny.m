//
//  Bunny.m
//  BunnyClasses
//
//  Created by Radi on 4/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "Bunny.h"

@implementation Bunny
int _jumpSize;

// OLD
//@synthesize jumpSize;

const int MAX_JUMP_LENGTH;

-(int)jumpSize {
    return _jumpSize;
}

-(void)setJumpSize:(int)jumpSize {
    if (jumpSize < 0) {
        [[NSException exceptionWithName:@"Bad jump size"
                                 reason:@"bunny jump size should be positive"
                               userInfo:nil] raise];
    }
    
    _jumpSize = jumpSize;
}


-(id) init {
    return [self initWithJumpSize:10];
}

-(id) initWithJumpSize: (int) size {
    self = [super init];
    if (self) {
        self.jumpSize = size;
    }
    
    return self;
}

+(id) bunnyWithJumpLenght:(int)jumpLenght {
    Bunny * bunny = [Bunny new];
    bunny.jumpSize = jumpLenght;
    return bunny;
}
@end
