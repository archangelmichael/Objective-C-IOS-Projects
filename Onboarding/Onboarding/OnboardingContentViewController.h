//
//  OnboardingContentViewController.h
//  Onboarding
//
//  Created by Radi on 10/12/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OnboardingDelegate <NSObject>

- (void)showNextPage:(NSUInteger)currentPage;

@end

@interface OnboardingContentViewController : UIViewController

@property id<OnboardingDelegate> delegate;
@property NSUInteger pageIndex;
@property NSString *imageFile;

@end
