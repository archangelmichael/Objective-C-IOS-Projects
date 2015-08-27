//
//  SearchVC.m
//  TestProject
//
//  Created by Radi on 8/21/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "SearchVC.h"
#import <MapKit/MapKit.h>

#import "Candy.h"

@interface SearchVC () {
    
    __weak IBOutlet MKMapView *mvMap;
    __weak IBOutlet UISearchBar *sbSearch;
    __weak IBOutlet UITableView *tvSearch;
    CustonSearchController * searchCTRL;
}

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.filteredCandies = [NSMutableArray array];
    self.candies = [NSMutableArray arrayWithObjects:
                    [[Candy alloc] initWithName:@"chocolate Bar" category:@"Chocolate"],
                    [[Candy alloc] initWithName:@"chocolate Chip" category:@"Chocolate"],
                    [[Candy alloc] initWithName:@"ark chocolate" category:@"Chocolate"],
                    [[Candy alloc] initWithName:@"jaw breaker" category:@"Hard"],
                    [[Candy alloc] initWithName:@"candy cane" category:@"Hard"],
                    [[Candy alloc] initWithName:@"lollipop" category:@"Hard"],
                    [[Candy alloc] initWithName:@"caramel" category:@"Other"],
                    [[Candy alloc] initWithName:@"sour chew" category:@"Other"],
                    [[Candy alloc] initWithName:@"gummi bear" category:@"Other"], nil];
    [self.tableView reloadData];
    
    self.searchBar.hidden = YES;

    [self.navigationController setNavigationBarHidden:YES];
    searchCTRL = [[CustonSearchController alloc] initWithSearchResultsController:nil];
    [searchCTRL.searchBar sizeToFit];
    searchCTRL.searchBar.barStyle = UIBarStyleDefault;
    searchCTRL.searchBar.barTintColor = [UIColor clearColor];
    searchCTRL.searchBar.backgroundColor = [UIColor whiteColor];
    [searchCTRL.searchBar setShowsBookmarkButton:YES];
    [searchCTRL.searchBar setShowsCancelButton:NO animated:NO];
    [searchCTRL.searchBar setShowsSearchResultsButton:NO];
    searchCTRL.searchResultsUpdater = self;
    searchCTRL.dimsBackgroundDuringPresentation = NO;
    [self.searchBarView addSubview:searchCTRL.searchBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.filteredCandies removeAllObjects];
    NSPredicate * searchPredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@" ,searchCTRL.searchBar.text];
    NSArray * filteredArr = [self.candies filteredArrayUsingPredicate:searchPredicate];
    self.filteredCandies = [NSMutableArray arrayWithArray:filteredArr];
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (searchCTRL.active) {
        return self.filteredCandies.count;
    }
    else {
        return self.candies.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCellId"
                                                            forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"SearchCellId"];
    }
    
    Candy * currentCandy;
    if (searchCTRL.active) {
        currentCandy = self.filteredCandies[indexPath.row];
    }
    else{
        currentCandy = self.candies[indexPath.row];
    }
    
    cell.textLabel.text = currentCandy.name;
    cell.detailTextLabel.text = currentCandy.category;
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
