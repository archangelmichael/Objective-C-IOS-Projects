//
//  ResizableTableViewCell.m
//  TestProject
//
//  Created by Radi on 9/15/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ResizableTableViewCell.h"

@implementation ResizableTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSString *)reuseId {
    return @"ResizableTableViewCell";
}

+(double)defaultHeight {
    return 125.0;
}
@end
