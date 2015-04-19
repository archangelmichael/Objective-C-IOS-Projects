//
//  CustomUIView.m
//  ViewsActions
//
//  Created by Radi on 4/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "CustomUIView.h"

@implementation CustomUIView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.label setText:@"Frame Loaded"];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self.label setText:@"Decoder Loaded"];
    }
    
    return self;
}

// This method override awakeFromNib result
//-(void)didMoveToSuperview {
//    [self.label setText: @"Move To Superview Loaded"];
//}

-(void)awakeFromNib {
    NSDate * date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm:ss"];
    self.label.text = [NSString stringWithFormat:@"Loaded at:%@", [formatter stringFromDate:date]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
