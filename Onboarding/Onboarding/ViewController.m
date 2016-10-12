//
//  ViewController.m
//  Onboarding
//
//  Created by Radi on 10/12/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "ViewController.h"
#import "OnboardingContentViewController.h"

@interface ViewController () <UIPageViewControllerDataSource, OnboardingDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageImages = @[@"dot_screen_1.png", @"dot_screen_2.png", @"dot_screen_3.png", @"dot_screen_4.png", @"dot_screen_5.png"];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OnboardingPagesVC"];
    self.pageViewController.dataSource = self;
    
    OnboardingContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0,
                                                    0,
                                                    self.view.frame.size.width,
                                                    self.view.frame.size.height);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Onboarding Delegate
- (void)showNextPage:(NSUInteger)currentPage {
    if (currentPage >= self.pageImages.count - 1) { // You are at the last page -> End onboarding
        // Change defaults
        [self.pageViewController.view removeFromSuperview];
        [self.pageViewController removeFromParentViewController];
        // Start the app
        return;
    }
    
    OnboardingContentViewController *startingViewController = [self viewControllerAtIndex:currentPage+1];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:true
                                     completion:nil];
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((OnboardingContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((OnboardingContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageImages count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (OnboardingContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageImages count] == 0) || (index >= [self.pageImages count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    OnboardingContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OnboardingContentVC"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.pageIndex = index;
    pageContentViewController.delegate = self;
    return pageContentViewController;
}

//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
//{
//    return [self.pageImages count];
//}
//
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 0;
//}

@end
