//
//  SecondViewController.m
//  SeguesActions
//
//  Created by Radi on 4/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80.0, 210.0, 160.0, 40.0)];
    label.text = self.text;
    // UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // [button addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    // [button setTitle:@"Show View" forState:UIControlStateNormal];
    // button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:label];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(UIStoryboardSegue *)segue {
    
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
