//
//  ParentViewController.h
//  ContainerView
//
//  Created by Radi on 6/8/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentViewController : UIViewController

@property (assign, nonatomic) BOOL loadUser;

- (void)goBack;
- (void)swapChildVC:(BOOL)showUser;

@end
