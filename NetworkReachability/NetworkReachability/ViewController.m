//
//  ViewController.m
//  NetworkReachability
//
//  Created by Radi on 10/12/15.
//  Copyright © 2015 archangel. All rights reserved.
//

#import "ViewController.h"
#import "ReachabilityManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (strong, nonatomic) Reachability *reachability;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.alpha = 0.0;
    self.reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    [self.reachability startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityDidChange:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCheckConnection:(id)sender {
    if (self.reachability.isReachableViaWiFi) {
        self.label.text = @"Reachable via WIFI";
    }
    else if (self.reachability.isReachableViaWWAN) {
        self.label.text = @"Reachable via WWAN";
    }
    else {
        self.label.text = @"No Internet Connection";
    }
    
    [self showMessage];
}

- (void)showMessage {
    [UIView animateWithDuration:2 animations:^{
        self.label.alpha  = 1.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:2
                                  delay:1
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.label.alpha = 0.0;
                             } completion:^(BOOL finished) {
                                 
                             }];
        }
    }];
}

- (void)reachabilityDidChange:(NSNotification *)notification {
    self.reachability = (Reachability *)[notification object];
    
    if ([self.reachability isReachable]) {
        NSLog(@"Reachable");
    } else {
        NSLog(@"Unreachable");
    }
}
@end
