//
//  UIImage+Scaled.h
//  TestProject
//
//  Created by Radi on 9/22/15.
//  Copyright © 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scaled)

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

- (UIImage *)imageScaledToSize:(CGSize)newSize;

- (UIImage *)imageScaledToHeight:(double)height;

- (void)setAsPatternImageForNavBar:(UINavigationBar *)navBar;

@end
