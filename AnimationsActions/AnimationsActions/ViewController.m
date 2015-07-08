//
//  ViewController.m
//  AnimationsActions
//
//  Created by Radi on 7/8/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    int animationDuration;
}

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    animationDuration = 2.0f;
    
    // Set Explosion Animation On Avatar Image Click
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(onImageTap:)];
    [self.avatarImageView addGestureRecognizer:tapRecognizer];
    [self.avatarImageView setUserInteractionEnabled:YES];
    
    NSMutableArray * images = [NSMutableArray arrayWithCapacity:24];
    for (int i = 0; i <= 23; i++) {
        NSString * imageName = [NSString stringWithFormat:@"explode%i", i + 1];
        [images addObject:[UIImage imageNamed:imageName]];
    }
    
    self.avatarImageView.animationImages = [NSArray arrayWithArray:images];
    [self.avatarImageView setAnimationDuration:animationDuration];
}

- (IBAction)onImageTap:(id)sender{
    static BOOL isAnimating = NO;
    
    if (!isAnimating) {
        [self.avatarImageView startAnimating];
        isAnimating = YES;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.avatarImageView stopAnimating];
            isAnimating = NO;
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
