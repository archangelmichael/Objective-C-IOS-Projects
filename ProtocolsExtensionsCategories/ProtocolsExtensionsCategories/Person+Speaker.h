//
//  Person+Speaker.h
//  ProtocolsExtensionsCategories
//
//  Created by Radi on 4/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "Person.h"

@interface Person (Speaker)

// CATEGORY CAN EXTEND THE BASE CLASS ONLY WITH METHODS
-(void)speak;
@end
