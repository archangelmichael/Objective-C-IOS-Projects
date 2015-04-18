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



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	arryData = [[NSMutableArray alloc] initWithObjects:@"iPhone",@"iPod",@"MacBook",@"MacBook Pro",nil];
	self.title = @"Simple Table Exmaple";
    [super viewDidLoad];
    
#warning Set edit button action to change table edit status
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(EditTable:)];
    [self.navigationItem setLeftBarButtonItem:editButton];
    
    /*
    // ADDS add button on the right side of title bar
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Add"
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(AddButtonAction:)];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    // ADDS delete button on the left side of title bar
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Delete"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(DeleteButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:deleteButton];
    
    [addButton release];
    [deleteButton release];
     */
}

/**
 Adds new element at the end
 @param Add button in Title Bar
 */
- (IBAction)AddButtonAction:(id)sender{
    [arryData addObject:@"Mac Mini"];
    [tblSimpleTable reloadData];
}

/**
 Removes last item
 @param Delete button in title bar
 */
- (IBAction)DeleteButtonAction:(id)sender{
    [arryData removeLastObject];
    [tblSimpleTable reloadData];
}

/**
 Change table edit state
 @param Edit button in title bar
 */
- (IBAction) EditTable:(id)sender {
    if(self.editing) {
        [super setEditing:NO animated:NO];
        [tblSimpleTable setEditing:NO animated:NO];
        [tblSimpleTable reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else {
        [super setEditing:YES animated:YES];
        [tblSimpleTable setEditing:YES animated:YES];
        [tblSimpleTable reloadData];
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


- (void)dealloc {
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Added one row for "+" row in edit mode
    int count = (int)arryData.count;
    if(self.editing) count++;
    return count;
    // return [arryData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.editingAccessoryType = UITableViewCellEditingStyleNone;
    }
    
    int count = 0;
    if(self.editing)
        if(indexPath.row != 0)
            count = 1;
    
    if(indexPath.row == ([arryData count]))
       if(self.editing){
        cell.textLabel.text = @"add new row";
        cell.editingAccessoryType = UITableViewCellEditingStyleNone;
        return cell;
    }
    
    cell.textLabel.text = [arryData objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editing == NO || !indexPath) { // No editing style if not editing or the index path is nil.
        return UITableViewCellEditingStyleNone;
    }
    
    /* Determine the editing style based on whether the cell
     * is a placeholder for adding content or already
     * existing content. Existing content can be deleted.
     */
    if (self.editing && indexPath.row == ([arryData count])) {
        return UITableViewCellEditingStyleInsert;
    } else {
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
        [arryData removeObjectAtIndex:indexPath.row];
        [tblSimpleTable reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [arryData insertObject:@"Mac Mini" atIndex:[arryData count]];
        [tblSimpleTable reloadData];
    }
}

/**
 Allows rows to be reordered
 */
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
     toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.row != arryData.count && destinationIndexPath.row != arryData.count) {
        NSString *item = [[arryData objectAtIndex:sourceIndexPath.row] retain];
        [arryData removeObject:item];
        [arryData insertObject:item atIndex:destinationIndexPath.row];
        [item release];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NextViewController *nextController = [[NextViewController alloc] initWithNibName:@"NextView" bundle:nil];
	[self.navigationController pushViewController:nextController animated:YES];
	[nextController changeProductText:[arryData objectAtIndex:indexPath.row]];
}

@end
