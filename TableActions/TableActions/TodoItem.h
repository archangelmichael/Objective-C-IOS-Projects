//
//  TodoItem.h
//  TableActions
//
//  Created by Radi on 4/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum TodoStatus {
    DONE,
    INPROGRESS,
    NEW
} TodoStatus;

@interface TodoItem : NSObject
@property int id;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSDate * created;
@property (nonatomic, strong) NSString * details;
@property int status;

+(instancetype)todoItem;
+(instancetype)todoItemWithTitle:(NSString *)title;
+(instancetype)todoItemWithTitle:(NSString *)title
                         details:(NSString *)details;

-(instancetype)init;
-(instancetype)initWithTitle:(NSString *)title;
-(instancetype)initWithTitle:(NSString *)title
                     details:(NSString *)details;

@end
