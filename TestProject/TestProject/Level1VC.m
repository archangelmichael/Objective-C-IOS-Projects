//
//  Level1VC.m
//  TestProject
//
//  Created by Radi on 8/7/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "Level1VC.h"

@interface Level1VC ()

@end

@implementation Level1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    return NO;
}

- (IBAction)onGoDeeper:(id)sender {
    if (self.navigationController) {
        [self.navigationController performSegueWithIdentifier:@"goToLevel2" sender:nil];
    }
    else {
        [self performSegueWithIdentifier:@"goToLevel2FromLevel1" sender:nil];
    }
}

- (IBAction)onGoHigher:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES
         ];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
