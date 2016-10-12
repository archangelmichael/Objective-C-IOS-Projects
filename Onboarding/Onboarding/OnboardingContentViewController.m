//
//  OnboardingContentViewController.m
//  Onboarding
//
//  Created by Radi on 10/12/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "OnboardingContentViewController.h"

@interface OnboardingContentViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ivScreen;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@end

@implementation OnboardingContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ivScreen.image = [UIImage imageNamed:self.imageFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onNext:(id)sender {
    [self.delegate showNextPage:self.pageIndex];
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
