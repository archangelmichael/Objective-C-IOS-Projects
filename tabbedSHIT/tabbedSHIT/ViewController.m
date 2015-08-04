//
//  ViewController.m
//  tabbedSHIT
//
//  Created by Radi on 6/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dotButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.dotButton.frame = CGRectMake(0.f, 0.f, 100.f, 100.f);
    [self.dotButton setBackgroundImage:[UIImage imageNamed:@"dot_button"] forState:UIControlStateNormal];
    CGFloat heightDifference = self.dotButton.frame.size.height - self.tabBar.frame.size.height;
    
    if (heightDifference < 0) {
        self.dotButton.center = self.tabBar.center;
        NSLog(@"heightDifference");
    } else {
        NSLog(@"not heightDifference");
        
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference / 2.f;
        self.dotButton.center = center;
    }
    
    self.selectedIndex = 1;
    [[[self.tabBar items] objectAtIndex:0] setBadgeValue:@"111"];
    
    [self.view addSubview:self.dotButton];
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

@end
