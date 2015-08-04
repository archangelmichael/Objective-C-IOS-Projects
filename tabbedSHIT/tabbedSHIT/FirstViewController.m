//
//  FirstViewController.m
//  tabbedSHIT
//
//  Created by Radi on 6/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onShitClicked:(id)sender {
    
    
    self.subview = [[[NSBundle mainBundle] loadNibNamed:@"ShitView" owner:self options:nil] objectAtIndex:0];
    self.subview.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height);
    [self.view addSubview:self.subview];
    
    UIButton * close = (UIButton *)[self.subview viewWithTag:99];
    [close addTarget:self
                 action:@selector(onCloseSubview)
       forControlEvents:UIControlEventTouchUpInside];
    
    [((ViewController *)self.tabBarController).dotButton setBackgroundImage:[UIImage imageNamed:@"dot_info_button"] forState:UIControlStateNormal];
    
}

-(IBAction)goBack:(UIStoryboardSegue *)segue {
    
}

-(void)onCloseSubview {
    self.subview.hidden = YES;
    [((ViewController *)self.tabBarController).dotButton setBackgroundImage:[UIImage imageNamed:@"dot_button"] forState:UIControlStateNormal];

    // [self.subview removeFromSuperview];
}
@end
