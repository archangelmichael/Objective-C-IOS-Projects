//
//  IntroViewController.h
//  PagingActions
//
//  Created by Radi on 5/7/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"

@interface IntroViewController : UIViewController <UIPageViewControllerDataSource> {
    NSMutableArray *images;
}

@property (strong, nonatomic) UIPageViewController *pageController;

@end
