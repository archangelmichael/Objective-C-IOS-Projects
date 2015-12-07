//
//  AngularWebViewIOS9TestViewController.m
//  TestProject
//
//  Created by Radi on 10/15/15.
//  Copyright © 2015 archangel. All rights reserved.
//

#import "AngularWebViewIOS9TestViewController.h"

@interface AngularWebViewIOS9TestViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AngularWebViewIOS9TestViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlAddress = @"http://localhost/angular-ios-issue/index.html";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
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
