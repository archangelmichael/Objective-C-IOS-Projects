//
//  ViewController.m
//  TextFieldAutocomplete
//
//  Created by Radi on 6/9/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSArray * allSuggestions;
    NSMutableArray * currentSuggestions;
}

@end

@implementation ViewController

int const TABLE_CELL_HEIGHT = 30;
    
- (void)viewDidLoad {
    [super viewDidLoad];
    allSuggestions = @[@"shop", @"chop", @"color", @"clap", @"clay", @"canyon", @"clip", @"colorful", @"clear", @"cold", @"shop", @"chopshop", @"color", @"clear", @"car"];
    currentSuggestions = [NSMutableArray arrayWithCapacity:10];
    
    self.textField.delegate = self;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.layer.cornerRadius = 10;
    self.tableView.clipsToBounds = YES;
    self.tableView.scrollEnabled = YES;
    self.tableView.hidden = YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.tableView.hidden = YES;
}

-(BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring
                 stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    
    float suggestionsCount = currentSuggestions.count;
    float height = suggestionsCount > 5 ? (5 * TABLE_CELL_HEIGHT) : suggestionsCount * TABLE_CELL_HEIGHT ;
    
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                      self.textField.frame.origin.y + self.textField.frame.size.height,
                                      self.textField.frame.size.width,
                                      height);
    self.tableView.hidden = NO;
    return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [currentSuggestions removeAllObjects];
    for(NSString *curString in allSuggestions) {
        NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
            [currentSuggestions addObject:curString];
        }
    }
    
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return currentSuggestions.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TABLE_CELL_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"TableCell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", currentSuggestions[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.textField.text = currentSuggestions[indexPath.row];
    [self.textField endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
