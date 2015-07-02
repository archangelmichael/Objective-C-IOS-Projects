//
//  SimpleTableViewController.h
//  SimpleTable
//
//  Created by Adeem on 17/05/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface SimpleTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *dataArr;
}

@property (retain, nonatomic) IBOutlet UITableView *devicesTable;

- (IBAction)addButtonAction:(id)sender;
- (IBAction)deleteButtonAction:(id)sender;

- (IBAction)editTable:(id)sender;

@end

