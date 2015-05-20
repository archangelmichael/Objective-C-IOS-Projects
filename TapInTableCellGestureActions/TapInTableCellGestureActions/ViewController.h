//
//  ViewController.h
//  TapInTableCellGestureActions
//
//  Created by Radi on 5/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
#import "AnotherTableViewCell.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIWebViewDelegate> {
    UITapGestureRecognizer * tap;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

