//
//  ParentViewController.m
//  ContainerView
//
//  Created by Radi on 6/8/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "ParentViewController.h"

@interface ParentViewController ()

@property (weak, nonatomic) IBOutlet UIView *vContainer;
@property (weak, nonatomic) UIViewController * currentVC;
@property (strong, nonatomic) UIViewController * previousVC;

@property (assign, nonatomic) BOOL backPossible;

@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.previousVC = nil;
    self.backPossible = NO;
    
    if (self.loadUser) {
        self.currentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"userVC"];
    }
    else {
        self.currentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"dotVC"];
    }
    
    
    self.currentVC.view.translatesAutoresizingMaskIntoConstraints = NO; // Changed to NO
    [self addChildViewController:self.currentVC];
    
    // Replaces
    // [self.vContainer addSubview:self.currentVC.view];
    [self addSubview:self.currentVC.view toView:self.vContainer]; // NEW
}

// NEW
- (void)addSubview:(UIView *)subView
            toView:(UIView*)parentView {
    [parentView addSubview:subView];
    
    NSDictionary * views = @{@"subView" : subView,};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                   options:0
                                                                   metrics:0
                                                                     views:views];
    [parentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
                                                          options:0
                                                          metrics:0
                                                            views:views];
    [parentView addConstraints:constraints];
}

- (void)goBack {
    if (self.backPossible) {
        UIViewController *newViewController = self.previousVC;
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO; // Changed to NO
        [self cycleFromViewController:self.currentVC
                     toViewController:newViewController];
        
        self.previousVC = nil;
        self.backPossible = NO;
        self.currentVC = newViewController;
    }
    else {
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)swapChildVC:(BOOL)showUser {
    if (showUser) {
        UIViewController *newViewController;
        
            newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"userVC"];
            self.backPossible = YES;
        
        
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO; // CHANGED TO NO
        [self cycleFromViewController:self.currentVC
                     toViewController:newViewController];
        
        NSLog(@"%@", self.previousVC);
        self.previousVC = self.currentVC;
        self.currentVC = newViewController;
    }
    else {
        UIViewController *newViewController;
        
            newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"dotVC"];
            self.backPossible = YES;
        
        
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO; //Changed to no
        [self cycleFromViewController:self.currentVC
                     toViewController:newViewController];
        NSLog(@"%@", self.previousVC);
        self.previousVC = self.currentVC;
        self.currentVC = newViewController;
    }
}

- (void)cycleFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    
    
    [self addSubview:newViewController.view toView:self.vContainer]; // Replaced
   //  [self.vContainer addSubview:newViewController.view];
    [newViewController.view layoutIfNeeded];
    
    // set starting state of the transition
    newViewController.view.alpha = 0;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         newViewController.view.alpha = 1;
                         oldViewController.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [oldViewController.view removeFromSuperview];
                         [oldViewController removeFromParentViewController];
                         [newViewController didMoveToParentViewController:self];
                     }];
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
