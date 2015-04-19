//
//  ViewController.m
//  ViewsActions
//
//  Created by Radi on 4/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ViewController.h"
#import "CustomUIView.h"

@interface ViewController ()

@end

@implementation ViewController {
    CustomUIView *customUiView;
}

static NSString * tableCellId = @"tableCell";
static NSString * customNibId = @"Custom";
const int rowsCount = 1000;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    customUiView = [[[NSBundle mainBundle] loadNibNamed:customNibId
                                                                owner:self
                                                              options:nil]
                                   objectAtIndex:0];
    // Set source for table view in CustomUIView
    [customUiView.tableView setDataSource:self];
    
    [self.view addSubview:customUiView];
    
    /* LOAD CUSTOM VIEW
    NSArray *nibs =[[NSBundle mainBundle] loadNibNamed:customNibId
                                                 owner:self
                                               options:nil];
    UIView *subview = (UIView *)[nibs objectAtIndex:0];
    [self.view addSubview:subview];
    
     // ADD CUSTO LABEL WITH CODE
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    [label setBackgroundColor:[[UIColor alloc] initWithRed:0 green:222 blue:222 alpha:0.5]];
    label.text = @"Hi";
    label.textColor = [UIColor redColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
     */
    
    /*
     WONT WORK CAUSE UINib is not UIView
     UINib *nib = [UINib nibWithNibName:customNibId bundle:nil];
     [self.view addSubview:nib];
     */
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowsCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    @try {
        cell = [tableView dequeueReusableCellWithIdentifier:tableCellId forIndexPath:indexPath];
    }
    @catch (NSException * exc) {
        
    }
    @finally {
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellId];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%li", indexPath.row];
        
        return cell;

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
