//
//  SecondViewController.m
//  tabbedSHIT
//
//  Created by Radi on 6/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "SecondViewController.h"

#import <GameKit/GameKit.h>

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UISlider *sliderView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GKNotificationBanner showBannerWithTitle:@"SOMETHING DONE"
                                      message:@"CONGRATULATIONS"
                                     duration:10
                            completionHandler:nil];
    
    UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"CONGRATULATIONS"
                                                           message:@"You just completed your first task"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
    UIImage * thumbImage = [self imageWithImage:[UIImage imageNamed:@"achievement"] scaledToSize:CGSizeMake(300,200)];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:thumbImage ];
    imageView.backgroundColor = [UIColor clearColor];
    [imageView setImage:thumbImage];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [successAlert setValue:imageView forKey:@"accessoryView"];
    }else{
        [successAlert addSubview:imageView];
    }
    
    [successAlert show];
    
// SET COLORS AS MAX AND MIN TEMPLATES
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context1, [[UIColor redColor] CGColor]);
    CGContextFillRect(context1, rect);
    UIImage *redImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *minImage = redImage;
    CGRect sliderFrame = self.sliderView.frame;
    sliderFrame.size.height = 5;
    UIGraphicsBeginImageContextWithOptions(sliderFrame.size, NO, 0.0);
    [minImage drawInRect:sliderFrame];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[UISlider appearance] setMaximumTrackImage:newImage forState:UIControlStateNormal];
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context2 = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context2, [[UIColor greenColor] CGColor]);
    CGContextFillRect(context2, rect);
    UIImage *greenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *maxImage = greenImage;
    UIGraphicsBeginImageContextWithOptions(sliderFrame.size, NO, 0.0);
    [maxImage drawInRect:sliderFrame];
    UIImage * newImage2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[UISlider appearance] setMaximumTrackImage:newImage2 forState:UIControlStateHighlighted];
    
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"thumb"]
                                forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"thumb-down"]
                                forState:UIControlStateHighlighted];

    
    // SET MAX AND MIN WITH IMAGES
//    UIImage *minImage = [[UIImage imageNamed:@"pattern-min"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//    UIImage *maxImage = [[UIImage imageNamed:@"pattern-max"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
//    [[UISlider appearance] setMaximumTrackImage:minImage
//                                       forState:UIControlStateNormal];
//    [[UISlider appearance] setMinimumTrackImage:maxImage
//                                       forState:UIControlStateNormal];
//    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"thumb"]
//                                forState:UIControlStateNormal];
//    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"thumb-down"]
//                                forState:UIControlStateHighlighted];
    
}

-(UIImage*)imageWithImage:(UIImage*)image
             scaledToSize:(CGSize)newSize; {
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onShowAnimation:(id)sender {
    self.animationView.image = [UIImage animatedImageNamed:@"tmp-" duration:1.0f];
    // self.animationView.image = [UIImage imageNamed:@"tmp-0"];
}
@end
