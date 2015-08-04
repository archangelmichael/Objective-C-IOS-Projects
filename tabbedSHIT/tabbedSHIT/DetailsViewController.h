//
//  DetailsViewController.h
//  tabbedSHIT
//
//  Created by Radi on 7/29/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIView *masterView;

- (IBAction)onRemoveContent:(id)sender;
- (IBAction)onAddContent:(id)sender;

@end
