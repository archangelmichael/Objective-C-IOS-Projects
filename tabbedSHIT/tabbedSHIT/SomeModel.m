//
//  SomeModel.m
//  tabbedSHIT
//
//  Created by Radi on 8/3/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "SomeModel.h"

@implementation SomeModel

#pragma mark NSCoding

#define kTitleKey       @"Title"
#define kDateKey      @"Date"

-(id)initWithCoder:(NSCoder *)decoder {
    NSString * title = [decoder decodeObjectForKey:kTitleKey];
    NSDate * date = [decoder decodeObjectForKey:kDateKey];
    SomeModel * someModel = [self init];
    someModel.title = title;
    someModel.date = date;
    return someModel;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_title forKey:kTitleKey];
    [encoder encodeObject:_date forKey:kDateKey];
}
@end
