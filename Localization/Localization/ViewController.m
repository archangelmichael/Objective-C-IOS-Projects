//
//  ViewController.m
//  Localization
//
//  Created by Radi on 10/8/15.
//  Copyright © 2015 archangel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelHi;
@property (weak, nonatomic) IBOutlet UILabel *labelAnswer;
@property (weak, nonatomic) IBOutlet UIButton *buttonAsk;
@property (weak, nonatomic) IBOutlet UIImageView *ivGreeting;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelAnswer.alpha = 0.0;
    
    //self.labelHi.text = [NSString stringWithFormat:NSLocalizedString(@"greeting", nil), @"username"];
    self.labelAnswer.text = NSLocalizedString(@"answer", nil);
    [self.buttonAsk setTitle:NSLocalizedString(@"question", nil) forState:UIControlStateNormal];
    [self.ivGreeting setImage:[UIImage imageNamed:NSLocalizedString(@"greetingImage", nil)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAsk:(id)sender {
   [UIView animateWithDuration:1
                    animations:^{
                        self.labelAnswer.alpha = 1.0;
                    }
                    completion:^(BOOL finished) {
                        [UIView animateWithDuration:1
                                              delay:2
                                            options:UIViewAnimationOptionCurveEaseOut
                                         animations:^{
                                             self.labelAnswer.alpha = 0.0;
                                         }
                                         completion:nil];
                    }];
}

@end
