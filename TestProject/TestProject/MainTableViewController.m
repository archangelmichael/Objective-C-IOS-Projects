//
//  MainTableViewController.m
//  TestProject
//
//  Created by Radi on 7/30/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "MainTableViewController.h"

typedef enum {
    VCPopup = 0,
    VCTypesCount
} VCType;

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return VCTypesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestTaskCellId"
                                                            forIndexPath:indexPath];
    cell.textLabel.text = [self getStringFromVCType:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * segueId = [self getSegueIdForVCType:indexPath.row];
    [self performSegueWithIdentifier:segueId sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSString *)getStringFromVCType:(NSInteger)vcType {
    switch (vcType) {
        case VCPopup: return @"VCPopup";
        default: return @"VCEmpty";
    }
}

-(NSString *)getSegueIdForVCType:(NSInteger)vcType {
    switch (vcType) {
        case VCPopup: return @"goToVCPopup";
        default: return @"goToVCEmpty";
    }
}
@end