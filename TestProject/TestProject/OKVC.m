//
//  OKVC.m
//  TestProject
//
//  Created by Radi on 8/7/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "OKVC.h"

@interface OKVC ()

@end

@implementation OKVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    return YES;
}

// Returns to this VC
-(IBAction)goBackToSurface:(UIStoryboardSegue *)segue {
    //do stuff
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
