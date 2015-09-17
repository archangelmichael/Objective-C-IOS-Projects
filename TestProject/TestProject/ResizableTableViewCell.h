//
//  ResizableTableViewCell.h
//  TestProject
//
//  Created by Radi on 9/15/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResizableTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIWebView *wvText;

+(NSString *)reuseId;
+(double)defaultHeight;

@end
