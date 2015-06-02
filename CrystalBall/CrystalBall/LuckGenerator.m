//
//  LuckGenerator.m
//  CrystalBall
//
//  Created by ARCHANGEL on 4/14/15.
//  Copyright (c) 2015 ARCHANGEL. All rights reserved.
//

#import "LuckGenerator.h"

@implementation LuckGenerator
+(NSString *)getrandomPrediction {
    NSArray * predictions = [NSArray arrayWithObjects: @"Do it", @"Think about it", @"Dont do it", @"Leave it", @"Fuck it", @"Rock it", nil];
    int index = arc4random_uniform(predictions.count);
    return predictions[index];
}
@end
