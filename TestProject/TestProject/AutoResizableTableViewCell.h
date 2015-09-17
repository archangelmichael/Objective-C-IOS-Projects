//
//  AutoResizableTableViewCell.h
//  TestProject
//
//  Created by Radi on 9/16/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoResizableTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelText;

+(NSString *)reuseId;
+(double)defaultHeight;
@end
