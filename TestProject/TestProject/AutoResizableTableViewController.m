//
//  AutoResizableTableViewController.m
//  TestProject
//
//  Created by Radi on 9/16/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "AutoResizableTableViewController.h"

#import "AutoResizableTableViewCell.h"

@interface AutoResizableTableViewController ()

@end

@implementation AutoResizableTableViewController

static NSString * shortText = @"<h1> short html text <h1>";
static NSString * longText = @"<div> <div> <h3><a href=\"stackoverflow.com\">current community</a></h3> </div> <a href=\"http://chat.stackoverflow.com\">http://chat.stackoverflow.com</a> <a href=\"http://blog.stackoverflow.com\">http://blog.stackoverflow.com</a> MORE more more reasdk jksllsadlakjshaldskajshd ashd lakshd kasjhd lkashd lkajshd lkjahsd lkajshd lkjashd lkjashd kjashd lkjashd akljsd kjalhd alksjh alkfzbxxbcasdlasdg</div>";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:[AutoResizableTableViewCell reuseId] bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:[AutoResizableTableViewCell reuseId]];
    
    self.tableView.estimatedRowHeight = [AutoResizableTableViewCell defaultHeight];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
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
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AutoResizableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AutoResizableTableViewCell reuseId]
                                                                       forIndexPath:indexPath];
    cell.labelTitle.text = [NSString stringWithFormat:@"ROW %li", (long)indexPath.row];
    cell.labelText.text = indexPath.row % 2 == 0 ? longText : shortText;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
