//
//  ViewController.m
//  TapInTableCellGestureActions
//
//  Created by Radi on 5/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
static NSString * customCellId = @"TableCell";
static NSString * customCellNibName = @"TableViewCell";

static NSString * customCell2Id = @"AnotherTableCell";
static NSString * customCell2NibName = @"AnotherTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    tap.delegate = self;
    [tap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tap];
    
    // Load Custom Table Cell From Nib
    UINib *nib = [UINib nibWithNibName:customCellNibName bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:customCellId];
    
    // Load Custom Table 2 Cell From Nib
    UINib *nib2 = [UINib nibWithNibName:customCell2NibName bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:customCell2Id];

}

-(void)singleTap {
    int a = 9;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        TableViewCell * cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:customCellId];
        
        // New cell
        //    TableViewCell * cell = (TableViewCell *) [[[NSBundle mainBundle] loadNibNamed:customCellNibName
        //                                                            owner:self
        //                                                          options:nil] lastObject];
        [cell.image setImage:[UIImage imageNamed:@"user-dot"]];
        [cell.button setTitle:@"DONE" forState:UIControlStateNormal];
        [cell.web loadHTMLString:@"<div> you can click the <a href=\"#\"> link </a> </div>" baseURL:nil];
        return cell;

    }
    else {
        // Reuse cell
        AnotherTableViewCell * cell = (AnotherTableViewCell *)[tableView dequeueReusableCellWithIdentifier:customCell2Id];
        
        // New cell
        //    AnotherTableViewCell * cell = (AnotherTableViewCell *) [[[NSBundle mainBundle] loadNibNamed:customCell2NibName
        //                                                            owner:self
        //                                                          options:nil] lastObject];
        
        [cell.button setTitle:@"DONE" forState:UIControlStateNormal];
        return cell;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer
      shouldReceiveTouch:(UITouch*)touch {
    NSLog(@"%@", gestureRecognizer.description);
    NSLog(@"%@", touch.description);
    BOOL isWebView = [touch.view.superview.superview  isKindOfClass:[UIWebView class]];
    if (isWebView) {
        UIView *cell = touch.view.superview;
        while (![cell isKindOfClass:[UITableViewCell class]]) {
            cell = cell.superview;
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(int)[self.tableView indexPathForCell:(UITableViewCell*)cell].row
                                                    inSection:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }
    
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor blackColor]];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor purpleColor]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
