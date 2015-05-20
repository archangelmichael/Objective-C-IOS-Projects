//
//  TableViewCell.m
//  TapInTableCellGestureActions
//
//  Created by Radi on 5/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

@synthesize image, button, web;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
    }
    
    return self; 
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
