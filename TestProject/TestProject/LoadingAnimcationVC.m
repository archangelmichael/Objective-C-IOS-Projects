//
//  LoadingAnimcationVC.m
//  TestProject
//
//  Created by Radi on 9/17/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "LoadingAnimcationVC.h"
#import "LoadingImageView.h"

@interface LoadingAnimcationVC ()

@property (weak, nonatomic) IBOutlet LoadingImageView *ivLoading;

@end

@implementation LoadingAnimcationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ivLoading.layer.cornerRadius = self.ivLoading.frame.size.width/2;
    self.ivLoading.clipsToBounds = YES;
    [self.ivLoading animate:NO];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onStartAnimation:(id)sender {
    [self.ivLoading animate:YES];
}

- (IBAction)onStopAnimation:(id)sender {
    [self.ivLoading animate:NO];
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
