//
//  Fighter.h
//  ProtocolsExtensionsCategories
//
//  Created by Radi on 4/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@protocol Fighter

// PROTOCOL ONLY DEFINES PROPERTIES AND METHODS TO BE IMPLEMENTED IN CLASS

@property (nonatomic, strong) NSString* power;

@required
-(void)hit;

@optional
-(void)retire;

@end
