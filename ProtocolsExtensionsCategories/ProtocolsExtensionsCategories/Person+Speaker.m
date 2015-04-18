//
//  Person+Speaker.m
//  ProtocolsExtensionsCategories
//
//  Created by Radi on 4/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "Person+Speaker.h"

@implementation Person (Speaker)
-(void)speak {
    NSLog(@"%@ just spoke", self.name);
}
@end
