//
//  SimpleTableViewController.m
//  SimpleTable
//
//  Created by Adeem on 17/05/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "NextViewController.h"
@implementation SimpleTableViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

-(void)viewWillAppear:(BOOL)animated {
    [self.devicesTable reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    dataArr = [[NSMutableArray alloc] initWithArray:[Device getInitialDevices]];
    
    self.title = @"Apple Devices";
    [super viewDidLoad];
    
#warning Set edit button action to change table edit status
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(editTable:)];
    [self.navigationItem setLeftBarButtonItem:editButton];
    
    /*
    // ADDS add button on the right side of title bar
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Add"
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(addButtonAction:)];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    // ADDS delete button on the left side of title bar
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Delete"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(deleteButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:deleteButton];
    
    [addButton release];
    [deleteButton release];
     */
}

/**
 Adds new element at the end
 @param Add button in Title Bar
 */
- (IBAction)addButtonAction:(id)sender{
    [dataArr addObject:[Device deviceWithModel:0 year:2013 manufacturer:@"APPLE"]];
    [self.devicesTable reloadData];
}

/**
 Removes last item
 @param Delete button in title bar
 */
- (IBAction)deleteButtonAction:(id)sender{
    [dataArr removeLastObject];
    [self.devicesTable reloadData];
}

/**
 Change table edit state
 @param Edit button in title bar
 */
- (IBAction)editTable:(id)sender {
    if(self.editing) {
        [super setEditing:NO animated:NO];
        [self.devicesTable setEditing:NO animated:NO];
        [self.devicesTable reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else {
        [super setEditing:YES animated:YES];
        [self.devicesTable setEditing:YES animated:YES];
        [self.devicesTable reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = (int)dataArr.count;
    if(self.editing) count++;
    return count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = indexPath.row;
    static NSString *CellIdentifier = @"DeviceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        cell.editingAccessoryType = UITableViewCellEditingStyleNone;
    }
    
    int count = 0;
    if(self.editing)
        if(row != 0)
            count = 1;
    
    if(row == ([dataArr count]))
       if(self.editing){
        cell.textLabel.text = @"add new device";
        cell.editingAccessoryType = UITableViewCellEditingStyleNone;
        return cell;
    }
    
    if (row < [dataArr count]) {
        Device * currentDevice = dataArr[row];
        cell.textLabel.text = currentDevice.title;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", currentDevice.year];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView
          editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editing == NO || !indexPath) { // No editing style if not editing or the index path is nil.
        return UITableViewCellEditingStyleNone;
    }
    
    /* Determine the editing style based on whether the cell
     * is a placeholder for adding content or already
     * existing content. Existing content can be deleted.
     */
    if (indexPath.row < dataArr.count && ((Device *)dataArr[indexPath.row]).year == 2013) {
        return UITableViewCellEditingStyleNone;
    }
    else if (self.editing && indexPath.row == ([dataArr count])) {
        return UITableViewCellEditingStyleInsert;
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

/**
 Adds new entry to the table
 */
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [dataArr removeObjectAtIndex:indexPath.row];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [dataArr insertObject:[Device deviceWithModel:0 year:2013 manufacturer:@"APPLE"]
                      atIndex:dataArr.count];
    }
    
    [self.devicesTable reloadData];
}

/**
 Allows rows to be reordered
 */
- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void) tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    if (sourceIndexPath.row != dataArr.count && destinationIndexPath.row != dataArr.count) {
        Device *item = [dataArr objectAtIndex:sourceIndexPath.row];
        [dataArr removeObject:item];
        [dataArr insertObject:item atIndex:destinationIndexPath.row];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NextViewController *nextVC = [[NextViewController alloc] initWithNibName:@"NextView"
                                                                      bundle:nil];
	[self.navigationController pushViewController:nextVC animated:YES];
    nextVC.selectedDevice = [dataArr objectAtIndex:indexPath.row];
}

@end
