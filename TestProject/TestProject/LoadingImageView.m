//
//  LoadingImageView.m
//  TestProject
//
//  Created by Radi on 9/17/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "LoadingImageView.h"

@implementation LoadingImageView {
    BOOL isAnimating;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/** Starts/Stops loading animation. */
-(void)animate:(BOOL)isLoading {
    NSLog( @"showLoading" );
    self.hidden = !isLoading;
    if (isLoading) {
        [self startSpin];
    }
    else {
        [self stopSpin];
    }
}

/**
 Starts indicator animation
 */
- (void) startSpin {
    if (!isAnimating) {
        isAnimating = YES;
        [self spinWithOptions:UIViewAnimationOptionCurveEaseIn];
    }
}

/**
 Stops indicator animation
 */
- (void) stopSpin {
    // set the flag to stop spinning after one last 90 degree increment
    isAnimating = NO;
}

/**
 Sets loading indicator animation
 */
- (void) spinWithOptions: (UIViewAnimationOptions)options {
    [UIImageView animateWithDuration:0.15f
                               delay:0.0f
                             options:options
                          animations:^{
                              self.transform = CGAffineTransformRotate(self.transform, M_PI / 2);
                          } completion:^(BOOL finished) {
                              if (finished) {
                                  if (isAnimating) {
                                      [self spinWithOptions:UIViewAnimationOptionCurveLinear];
                                  }
                              } else {
                                  [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
                              }
                          }];
}


@end
