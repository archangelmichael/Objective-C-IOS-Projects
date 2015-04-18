//
//  DataManager.h
//  TableActions
//
//  Created by Radi on 4/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TodoItem.h"

@interface DataManager : NSObject

+ (id)sharedGCDManager;
+ (id)sharedManager;

-(void)createItems;

-(TodoItem *)addItem:(TodoItem *)item;
-(TodoItem *)addItem:(TodoItem *)item atPosition:(int)position;

-(NSArray *)getItems;
-(TodoItem *)getItemById:(int)itemId;

-(BOOL)removeItem:(TodoItem *)item;
-(BOOL)removeItemById:(int)item;

-(TodoItem *)copyTodo:(TodoItem *)todo;
@end
