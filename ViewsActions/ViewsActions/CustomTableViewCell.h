//
//  CustomTableViewCell.h
//  ViewsActions
//
//  Created by Radi on 4/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellLabel;

- (IBAction)butttonClick:(id)sender;

@end
