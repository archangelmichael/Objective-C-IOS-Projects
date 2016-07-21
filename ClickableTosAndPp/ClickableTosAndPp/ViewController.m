//
//  ViewController.m
//  ClickableTosAndPp
//
//  Created by Radi on 7/21/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "ViewController.h"

#import "AcceptLabel.h"
#import "AcceptButton.h"

@interface ViewController () <AcceptLabelDelegate>

@property (weak, nonatomic) IBOutlet AcceptButton *btnAccept;
@property (weak, nonatomic) IBOutlet AcceptLabel *lblAccept;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lblAccept.delegate = self;
}

-(void)tosTapped {
    NSLog(@"tos tapped");
}

-(void)ppTapped {
    NSLog(@"pp tapped");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
