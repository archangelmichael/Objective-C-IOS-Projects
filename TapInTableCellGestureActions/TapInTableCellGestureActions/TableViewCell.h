//
//  TableViewCell.h
//  TapInTableCellGestureActions
//
//  Created by Radi on 5/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIWebView *web;

@end
