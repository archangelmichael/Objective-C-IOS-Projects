//
//  EditInfoViewController.m
//  SQLite3DBActions
//
//  Created by Radi on 4/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "EditInfoViewController.h"

@interface EditInfoViewController ()

@end

@implementation EditInfoViewController

static NSString * dbName = @"people.sqlite";
static NSString * insertQuery = @"INSERT INTO peopleInfo VALUES(null, '%@', '%@', %d)";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = self.navigationItem.rightBarButtonItem.tintColor;
    
#warning Before setting the delegate add <UITextFieldDelegate> to header file
    // Sets text fields delegate
    self.textFirstname.delegate = self;
    self.textLastname.delegate = self;
    self.textAge.delegate = self;
    
    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:dbName];
    
    // Check if we want to edit or add new
    if (self.recordIDToEdit != -1) {
        // Load the record with the specific ID from the database.
        [self loadInfoToEdit];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 Hides the keyboard when DONE button is clicked
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

/**
 Inserts or updates info in database
 */
- (IBAction)saveInfo:(id)sender {
        // Prepare the query string.
        // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
    NSString *query;
    if (self.recordIDToEdit == -1) {
        query = [NSString stringWithFormat:@"insert into peopleInfo values(null, '%@', '%@', %d)",
                self.textFirstname.text,
                self.textLastname.text,
                [self.textAge.text intValue]];
    }
    else{
        query = [NSString stringWithFormat:@"update peopleInfo set firstname='%@', lastname='%@', age=%d where peopleInfoID=%d",
                    self.textFirstname.text,
                    self.textLastname.text,
                    self.textAge.text.intValue,
                    self.recordIDToEdit];
    }
        
        
    // Execute the query.
    [self.dbManager executeQuery:query];
        
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
        // Inform the delegate that the editing was finished.
        [self.delegate editingInfoWasFinished];
            
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}

-(void)loadInfoToEdit{
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"select * from peopleInfo where peopleInfoID=%d", self.recordIDToEdit];
    
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Set the loaded data to the textfields.
    self.textFirstname.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"firstname"]];
    self.textLastname.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"lastname"]];
    self.textAge.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"age"]];
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
