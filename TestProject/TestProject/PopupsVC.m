//
//  PopupsVC.m
//  TestProject
//
//  Created by Radi on 7/30/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "PopupsVC.h"

// Native Popover (Used especially in iPad)
#import "PopoverViewController.h"
#import "UIPopoverController+iPhone.h"

// Custom Library SKTipAlertView
#import "SKTipAlertView.h"

// Custom Libraty FPPopover
#import "FPPopoverController.h"
#import "FPPopoverView.h"
#import "FPTouchView.h"
#import "ARCMacros.h"
#import "TestFPViewController.h"

// Custom Library CMPopTipView
#import "CMPopTipView.h"

@interface PopupsVC () <FPPopoverControllerDelegate, CMPopTipViewDelegate> {
    SKTipAlertView *customAlertView1;
}

@property (nonatomic, strong) UIView * customPopView1;

@property (weak, nonatomic) IBOutlet UIButton *popoverButton;

@property (nonatomic, strong) UIPopoverController *popOver;

@property (nonatomic, strong) CMPopTipView *roundRectButtonPopTipView;

@property (nonatomic, strong) CMPopTipView *navBarLeftButtonPopTipView;


@end

@implementation PopupsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Custom Pop SKTipAlertView
    self.customPopView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    [self.customPopView1 setBackgroundColor:[UIColor redColor]];
    customAlertView1 = [SKTipAlertView sharedTipAlertView];
    
    // Custom CMPopTipView
    self.navBarLeftButtonPopTipView = [[CMPopTipView alloc] initWithTitle:@"Did you know?"
                                                                  message:@"BMW is the best"];
    [self customizeCMPopupView:self.navBarLeftButtonPopTipView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SKTipAlertViewPopover
- (IBAction)onShowSKTipAlertViewPopover:(id)sender {
    static int counter = 0;
    if (counter >= 4) {
        counter = 0;
    }
    switch (counter) {
        case 0: [customAlertView1 showNotificationForView:self.customPopView1
                                              forDuration:2
                                              andPosition:SKTipAlertViewPositionBottom
                                                permanent:YES];
            break;
        case 1:
            [customAlertView1 showBlueNotificationForString:@"Blue Alert"
                                                forDuration:1
                                                andPosition:SKTipAlertViewPositionBottom
                                                  permanent:NO];

            break;
        case 2:
            [customAlertView1 showGreenNotificationForString:@"Green Alert"
                                                 forDuration:1
                                                 andPosition:SKTipAlertViewPositionTop
                                                   permanent:YES];
            break;
        case 3:
            [customAlertView1 showRedNotificationForString:@"Did you know?"
                                               forDuration:1
                                               andPosition:SKTipAlertViewPositionTop
                                                 permanent:NO];
            break;
        default:
            break;
    }
    
    counter ++;
}

#pragma mark - FPPopover
- (IBAction)onShowFPPopover:(id)sender {
    //the view controller you want to present as popover
    TestFPViewController *controller = [[TestFPViewController alloc] init];
    controller.title = @"Popup";
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller];
    // Customize appearance
    popover.contentSize = CGSizeMake(340,140);
    popover.tint = FPPopoverRedTint;
    popover.arrowDirection = FPPopoverArrowDirectionUp; //popover.arrowDirection = FPPopoverNoArrow;
    popover.border = NO;
    popover.alpha = 0.8;
    
    // Set delegate
    popover.delegate = self;
    [popover presentPopoverFromView:(UIView *)sender];
}

// When new popover is displayed
- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController {
    [visiblePopoverController dismissPopoverAnimated:YES];
}

// When popover is dismissed
- (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController {
}

#pragma mark CMPopTipView
// Present a CMPopTipView pointing at a UIBarButtonItem in the nav bar
- (IBAction)onNavBarPopup:(id)sender {
    static BOOL isCMPopTipViewDisplayed = NO;
    if (isCMPopTipViewDisplayed) {
        isCMPopTipViewDisplayed = NO;
        [self.navBarLeftButtonPopTipView dismissAnimated:YES];
    }
    else {
        isCMPopTipViewDisplayed = YES;
        // Custom Pop CMPopTipView
        self.navBarLeftButtonPopTipView.delegate = self;
        [self.navBarLeftButtonPopTipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem
                                                               animated:YES];
    }
}

- (IBAction)onShowCMPopup:(id)sender {
    // Toggle popTipView when a standard UIButton is pressed
    if (nil == self.roundRectButtonPopTipView) {
        self.roundRectButtonPopTipView = [CMPopTipView new];
        [self customizeCMPopupView:self.roundRectButtonPopTipView];
        self.roundRectButtonPopTipView.delegate = self;
        UIButton *button = (UIButton *)sender;
        [self.roundRectButtonPopTipView presentPointingAtView:button inView:self.view animated:YES];
    }
    else {
        // Dismiss
        [self.roundRectButtonPopTipView dismissAnimated:YES];
        self.roundRectButtonPopTipView = nil;
    }
}

- (void)customizeCMPopupView:(CMPopTipView *)view {
    view.backgroundColor = [UIColor lightGrayColor];
    
    view.sidePadding = 5;
    view.topMargin = 0; // Range from target view
    view.pointerSize = 10; // Arrow size
    view.bubblePaddingX = 5;
    view.bubblePaddingY = 5;
    
    view.animation = CMPopTipAnimationPop;
    view.maxWidth = 200; // Total Label width
    view.preferredPointDirection = PointDirectionUp;
    
    view.has3DStyle = YES;
    view.hasShadow = NO;
    view.hasGradientBackground = NO;
    
    view.borderColor = [UIColor blackColor];
    view.cornerRadius = 10;
    view.borderWidth = 2;
    
    view.disableTapToDismiss = NO;
    view.dismissTapAnywhere = YES;
    
    view.title = @"Customized Title";
    view.titleColor = [UIColor darkTextColor];
    view.titleFont = [UIFont systemFontOfSize:20];
    view.titleAlignment = NSTextAlignmentCenter;
    view.textAlignment = NSTextAlignmentRight;
    
    view.message = @"Customized Message";
    view.textColor = [UIColor darkTextColor];
//    UIView *customView = [[[NSBundle mainBundle] loadNibNamed:@"PopoverCell"
//                                                        owner:self
//                                                      options:nil] objectAtIndex:0];
//    view.customView = customView;
}

// CMPopTipViewDelegate method
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    // Any cleanup code, such as releasing a CMPopTipView instance variable, if necessary
    self.roundRectButtonPopTipView = nil;
}

#pragma mark - Native Popover
- (IBAction)onShowPopover:(id)sender {
    PopoverViewController * popoverView =[[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController: popoverView];
    popoverView.popoverPresentationController.sourceView = self.popoverButton;
    popoverView.popoverPresentationController.sourceRect = self.popoverButton.frame;
    
    // [self presentViewController:popoverView animated:YES completion:nil];
    [self.popOver presentPopoverFromRect:((UIView *)self.popoverButton).frame
                                  inView:self.view
permittedArrowDirections:UIPopoverArrowDirectionDown
                                animated:YES];
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
