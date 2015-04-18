//
//  TableViewController.m
//  TableActions
//
//  Created by Radi on 4/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController {
    NSArray * todos;
    DataManager *manager;
    BOOL editMode;
}

NSString * const CELL_INDENTIFIER = @"TodoCell";

-(void)refreshData {
    todos = [manager getItems];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [DataManager sharedManager];
    editMode = NO;
    
    [self refreshData];
    
    // Place edit button
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [self.editButtonItem setAction:@selector(EditTable:)];
    
    /* Manual edit button creation
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(EditTable:)];
    [self.navigationItem setLeftBarButtonItem:editButton];
    */
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; // Return the number of sections.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    int count = (int)todos.count;
//    if(self.editing)
//        count++;
//    
//    return count;
    return todos.count; // Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER
                                                            forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:CELL_INDENTIFIER];
        cell.editingAccessoryType = UITableViewCellEditingStyleNone;
    }
    
//    int count = 0;
//    if(self.editing)
//        if(indexPath.row != 0)
//            count = 1;
//    
//    if(indexPath.row == todos.count) {
//        if(self.editing){
//            cell.textLabel.text = @"add new todo";
//            cell.editingAccessoryType = UITableViewCellEditingStyleNone;
//            return cell;
//        }
//    }
    
    TodoItem *currentTodo = todos[indexPath.row];
    cell.showsReorderControl = YES;
    cell.textLabel.text = currentTodo.title;
    cell.detailTextLabel.text = currentTodo.details;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view editing
/**
 Change table edit state
 @param Edit button in title bar
 */
- (IBAction) EditTable:(id)sender {
    if(self.editing) {
        [super setEditing:NO animated:NO];
        [self.tableView setEditing:NO animated:NO];
        //[self.tableView reloadData];
        [self refreshData];
        //[self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
        //[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        //[self.tableView reloadData];
        [self refreshData];
        //[self.navigationItem.leftBarButtonItem setTitle:@"Done"];
        //[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.editing == NO || !indexPath) { // No editing style if not editing or the index path is nil.
//        return UITableViewCellEditingStyleNone;
//    }
//    
//    /* Determine the editing style based on whether the cell
//     * is a placeholder for adding content or already
//     * existing content. Existing content can be deleted.
//     */
//    if (self.editing && indexPath.row == (todos.count)) {
//        return UITableViewCellEditingStyleInsert;
//    } else {
//        return UITableViewCellEditingStyleDelete;
//    }
    
    return UITableViewCellEditingStyleNone;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int row = (int)indexPath.row;
        [manager removeItem:todos[row]];
        [self refreshData];
    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        TodoItem *todo = [TodoItem todoItem];
//        [manager addItem:todo atPosition:(int)indexPath.row];
//        [self refreshData];
//    }
}

#pragma mark - Table view rows reordering
// Override to support rearranging the table view.
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    int addRowIndex = (int)todos.count;
    int from = (int)sourceIndexPath.row;
    int to = (int)destinationIndexPath.row;
    
    if (from != addRowIndex && to != addRowIndex && from != to) {
        TodoItem *copyTo = [manager copyTodo:todos[to]];
        TodoItem *copyFrom = [manager copyTodo:todos[from]];
        [manager removeItemById:copyTo.id];
        [manager removeItemById:copyFrom.id];
        if (from > to) {
            [manager addItem:copyFrom atPosition:to];
            [manager addItem:copyTo atPosition:from];
        }
        else {
            [manager addItem:copyTo atPosition:from];
            [manager addItem:copyFrom atPosition:to];
        }
        
        [self refreshData];
    }
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    int row = (int)indexPath.row;
//    if (row == todos.count) {
//        return NO;
//    }
    
    return YES; // Return NO if you do not want the item to be re-orderable.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
@end
