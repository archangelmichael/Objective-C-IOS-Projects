//
//  PageViewController.m
//  PagingActions
//
//  Created by Radi on 5/7/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()

@end

@implementation PageViewController
@synthesize imagePath;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageView setImage:[UIImage imageNamed:imagePath]];
    // Do any additional setup after loading the view from its nib.
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

@end
