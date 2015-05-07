//
//  PageViewController.h
//  PagingActions
//
//  Created by Radi on 5/7/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageViewController : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString* imagePath;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
