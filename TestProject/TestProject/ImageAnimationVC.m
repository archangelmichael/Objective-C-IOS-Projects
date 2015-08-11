//
//  ImageAnimationVC.m
//  TestProject
//
//  Created by Radi on 8/11/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ImageAnimationVC.h"

@interface ImageAnimationVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *pivotLabel;

@end

@implementation ImageAnimationVC

double const BIG_IMAGE_SIZE = 200;
double const SMALL_IMAGE_SIZE = 150;
double BIG_POS_X;
double SMALL_POS_X;


- (void)viewDidLoad {
    [super viewDidLoad];
    double sideOffset = 8;
    double pivotPosX = self.pivotLabel.frame.origin.x;
    BIG_POS_X = pivotPosX - sideOffset - BIG_IMAGE_SIZE;
    SMALL_POS_X = pivotPosX - sideOffset - SMALL_IMAGE_SIZE;
    NSLog(@"BIG POS X: %f", BIG_POS_X);
    NSLog(@"SMALL POS X: %f", SMALL_POS_X);
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    double sideOffset = 8;
    double pivotPosX = self.pivotLabel.frame.origin.x;
    BIG_POS_X = pivotPosX - sideOffset - BIG_IMAGE_SIZE;
    SMALL_POS_X = pivotPosX - sideOffset - SMALL_IMAGE_SIZE;
    NSLog(@"BIG POS X 2: %f", BIG_POS_X);
    NSLog(@"SMALL POS X 2: %f", SMALL_POS_X);
}

-(void)viewDidLayoutSubviews {
    double sideOffset = 8;
    double pivotPosX = self.pivotLabel.frame.origin.x;
    BIG_POS_X = pivotPosX - sideOffset - BIG_IMAGE_SIZE;
    SMALL_POS_X = pivotPosX - sideOffset - SMALL_IMAGE_SIZE;
    NSLog(@"BIG POS X 3: %f", BIG_POS_X);
    NSLog(@"SMALL POS X 3: %f", SMALL_POS_X);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMakeBigger:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    self.imageView.frame = CGRectMake(BIG_POS_X,
                                      self.imageView.frame.origin.y,
                                      BIG_IMAGE_SIZE, BIG_IMAGE_SIZE);
    [UIView commitAnimations];
}

- (IBAction)onMakeSmaller:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    self.imageView.frame = CGRectMake(SMALL_POS_X,
                                      self.imageView.frame.origin.y,
                                      SMALL_IMAGE_SIZE, SMALL_IMAGE_SIZE);
    [UIView commitAnimations];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
