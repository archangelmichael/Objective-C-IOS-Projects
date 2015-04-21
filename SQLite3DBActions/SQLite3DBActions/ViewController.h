//
//  ViewController.h
//  SQLite3DBActions
//
//  Created by Radi on 4/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "EditInfoViewController.h"

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, EditInfoViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tablePeople;

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrPeopleInfo;

-(void)loadData;

- (IBAction)addNewRecord:(id)sender;

@end

