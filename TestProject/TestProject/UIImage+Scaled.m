//
//  UIImage+Scaled.m
//  TestProject
//
//  Created by Radi on 9/22/15.
//  Copyright © 2015 archangel. All rights reserved.
//

#import "UIImage+Scaled.h"

@implementation UIImage (Scaled)

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageScaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageScaledToHeight:(double)height {
    double ratio = self.size.width / self.size.height;
    double width = ratio * height;
    return [self imageScaledToSize:CGSizeMake(width, height)];
}

-(void)setAsPatternImageForNavBar:(UINavigationBar *)navBar {
    UIGraphicsBeginImageContext(navBar.frame.size);
    [self drawInRect:navBar.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    navBar.barTintColor = [UIColor colorWithPatternImage:image];
}

@end
