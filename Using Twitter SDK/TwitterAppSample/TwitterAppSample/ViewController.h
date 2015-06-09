//
//  ViewController.h
//  TwitterAppSample
//
//  Created by Radi on 6/8/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;

@property (strong, nonatomic) NSArray *dataSource;

@end

