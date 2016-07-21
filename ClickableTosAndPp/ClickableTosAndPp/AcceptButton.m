//
//  AcceptButton.m
//  Dots
//
//  Created by Radi on 7/21/16.
//  Copyright © 2016 VS. All rights reserved.
//

#import "AcceptButton.h"

@implementation AcceptButton {
    BOOL isChecked;
    UIImage * imgChecked;
    UIImage * imgUnchecked;
}

static NSString * checkedImage = @"checked_filled";
static NSString * uncheckedImage = @"checked";

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    imgChecked = [[UIImage imageNamed:checkedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imgUnchecked = [[UIImage imageNamed:uncheckedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    isChecked = NO;
    self.backgroundColor = [UIColor clearColor];
    float inset = (self.frame.size.height - imgChecked.size.height)/2;
    self.contentEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset);
    [self setImage:imgUnchecked forState:UIControlStateNormal];
    
    [self addTarget:self
             action:@selector(onAcceptPressed:)
   forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
}

//-(void)dealloc {
//    [self removeTarget:self
//                action:@selector(onAcceptPressed:)
//      forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
//}

// Change btn checked state when clicked
- (void)onAcceptPressed:(id)sender {
    if(isChecked) {
        [self setImage:imgUnchecked forState:UIControlStateNormal];
    }
    else {
        [self setImage:imgChecked forState:UIControlStateNormal];
    }
    
    isChecked = !isChecked;
}

- (BOOL)checked {
    return isChecked;
}

@end
