//
//  main.m
//  ProtocolsExtensionsCategories
//
//  Created by Radi on 4/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "Person+Speaker.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Person *jack = [Person personWithName:@"Jack" andAge:34];
        
        Person *mike = [Person personWithName:@"Michael"];
        
        Person *josh = [Person person];
        
        Person *kris = [Person new];
        
        Person *peter = [[Person alloc] initWithName:@"Peter"];
        
        Person *karl = [[Person alloc]initWithName:@"Karl" andAge:12];
        
        NSArray * guys = [NSArray arrayWithObjects:jack, mike, josh, kris, peter, karl, nil];
        
        for (Person* man in guys) {
            NSLog(@"%@", [man description]);
        }
        
        [mike hit];
        [mike retire];
        [mike hit];
        [mike speak];
        
    }
    return 0;
}
