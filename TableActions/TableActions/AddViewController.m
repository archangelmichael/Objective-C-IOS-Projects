//
//  AddViewController.m
//  TableActions
//
//  Created by Radi on 4/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController {
    DataManager * manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    manager = [DataManager sharedManager];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveTodo:(id)sender {
    NSString *title = self.titleLabel.text;
    NSString *details = self.detailsText.text;
    UIAlertView *alert;
    
    if (title == nil || title.length < 2) {
        alert = [[UIAlertView alloc] initWithTitle:@"Invalid Title!"
                                           message:@"Title must be at least 3 symbols."
                                          delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil, nil];
    }
    else if(details == nil || details.length < 20){
        alert = [[UIAlertView alloc] initWithTitle:@"Invalid Category!"
                                           message:@"Details must be at least 20 symbols."
                                          delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil, nil];
    }
    else{
        TodoItem *todo = [TodoItem todoItemWithTitle:title
                                             details:details];
        TableViewController *parentController = [self.navigationController.viewControllers
                                                 objectAtIndex:0];
        [manager addItem:todo];
        
        alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                           message:@"Todo created successfully."
                                          delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil, nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [alert show];
    
}
@end
