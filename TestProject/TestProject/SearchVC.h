//
//  SearchVC.h
//  TestProject
//
//  Created by Radi on 8/21/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustonSearchController.h"

@interface SearchVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray * candies;
@property (nonatomic, strong) NSMutableArray * filteredCandies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *searchBarView;

@end
