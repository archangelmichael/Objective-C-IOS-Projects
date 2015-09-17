//
//  AutoResizableTableViewCell.m
//  TestProject
//
//  Created by Radi on 9/16/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "AutoResizableTableViewCell.h"

@implementation AutoResizableTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSString *)reuseId {
    return @"AutoResizableTableViewCell";
}

+(double)defaultHeight {
    return 70.0;
}

@end
