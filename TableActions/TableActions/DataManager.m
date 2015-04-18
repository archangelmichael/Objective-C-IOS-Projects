//
//  DataManager.m
//  TableActions
//
//  Created by Radi on 4/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager {
    NSMutableArray * todoItems;
}


+ (id)sharedGCDManager {
    static DataManager *sharedDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataManager = [[self alloc] init];
    });
    
    return sharedDataManager;
}

+ (id)sharedManager {
    static DataManager *sharedDataManager = nil;
    @synchronized(self) {
        if (sharedDataManager == nil) {
            sharedDataManager = [[self alloc] init];
        }
    }
    
    return sharedDataManager;
}

- (id)init {
    if (self = [super init]) {
        self->todoItems = [NSMutableArray arrayWithArray:@[]];
        [self createItems];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


-(void)createItems{
    self->todoItems = [NSMutableArray arrayWithArray:@[
                                                       [TodoItem todoItem],
                                                       [TodoItem todoItemWithTitle:@"Urgent"],
                                                       [[TodoItem alloc] initWithTitle:@"Homecomming" details:@"Must go home for dinner" ],
                                                       [[TodoItem alloc] init]
                                                       ]];
}

-(TodoItem *)addItem:(TodoItem *)item{
    [self->todoItems addObject:item];
    return item;
}
-(TodoItem *)addItem:(TodoItem *)item
          atPosition:(int)position {
    [self->todoItems insertObject:item atIndex:position];
    return item;
}

-(NSArray *)getItems{
    NSArray *todos = [NSArray arrayWithArray:self->todoItems];
    return todos;
}

-(TodoItem *)getItemById:(int)itemId {
    for( TodoItem *todo in self->todoItems) {
        if ( todo.id == itemId ) {
            return todo;
        }
    }
    
    return nil;
}

-(BOOL)removeItem:(TodoItem *)item {
    if (item) {
        [self->todoItems removeObject:item];
        return YES;
    }
    
    return NO;
}

-(BOOL)removeItemById:(int)itemId {
    TodoItem *todo = [self getItemById:itemId];
    if (todo) {
        [self->todoItems removeObject:todo];
        return YES;
    }
    
    return NO;
}

-(TodoItem *)copyTodo:(TodoItem *)todo {
    if (todo) {
        TodoItem *copy = [TodoItem todoItemWithTitle:todo.title details:todo.details];
        copy.created = todo.created;
        copy.status = todo.status;
        copy.id = todo.id;
        return copy;
    }
    
    return nil;
}

/* Reference the maganer by:
 DataManager *sharedManager = [DataManager sharedManager];
 or
 DataManger *sharedGCDManage = [DataManager sharedGCDManager];
 */
@end
