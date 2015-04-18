//
//  TodoItem.m
//  TableActions
//
//  Created by Radi on 4/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "TodoItem.h"

@implementation TodoItem

static int ids = 0;
NSString * const DEFAULT_TITLE = @"No title";
NSString * const DEFAULT_DETAILS = @"No details";

+(instancetype)todoItem{
    return [self todoItemWithTitle:DEFAULT_TITLE
                           details:DEFAULT_DETAILS];
}
+(instancetype)todoItemWithTitle:(NSString *)title {
    return [self todoItemWithTitle:title
                           details:DEFAULT_DETAILS];
}
+(instancetype)todoItemWithTitle:(NSString *)title
                         details:(NSString *)details {
    TodoItem *item = [[TodoItem alloc] initWithTitle:title
                                             details:details];
    return item;
}

-(instancetype)init {
    return [self initWithTitle:DEFAULT_TITLE
                       details:DEFAULT_DETAILS];
}
-(instancetype)initWithTitle:(NSString *)title{
    return [self initWithTitle:title
                       details:DEFAULT_DETAILS];
}
-(instancetype)initWithTitle:(NSString *)title
                     details:(NSString *)details {
    self = [super init];
    if (self) {
        self.id = ids++;
        self.title = title;
        self.details = details;
        self.created = [NSDate date];
        self.status = NEW;
    }
    
    return self;
}


@end
