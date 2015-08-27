//
//  MessagesVC.m
//  PushNotifications
//
//  Created by Radi on 8/27/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "MessagesVC.h"
#import <Parse/Parse.h>

@interface MessagesVC ()

@property (weak, nonatomic) IBOutlet UITableView *tvMessages;
@property (weak, nonatomic) IBOutlet UITextView *tvNewMessage;
@property (weak, nonatomic) IBOutlet UILabel *labelGreeting;

@end

@implementation MessagesVC {
    NSMutableArray * currentMessages;
    NSDateFormatter * dateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    currentMessages = [NSMutableArray array];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        self.labelGreeting.text = [NSString stringWithFormat:@"Hi, %@", currentUser.username];
    } else {
        [self onClose];
    }
    
    self.tvMessages.dataSource = self;
    self.tvMessages.delegate = self;
    self.tvMessages.bounces = YES;
    
    self.tvNewMessage.delegate = self;
    [self getMessages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogout:(id)sender {
    [PFUser logOut];
    [self onClose];
}

- (IBAction)onSendMessage:(id)sender {
    PFObject * newMessage = [PFObject objectWithClassName:@"Message"];
    newMessage[@"text"] = self.tvNewMessage.text;
    newMessage[@"date"] = [dateFormatter stringFromDate:[NSDate date]];
    [newMessage saveInBackgroundWithBlock:^(BOOL done, NSError *error) {
        if (!error) {
            
            self.tvNewMessage.text = @"";
            [self getMessages];
        }
        else {
            self.tvNewMessage.text = @"ERROR";
        }
    }];
}

- (void)getMessages {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"date" equalTo:[dateFormatter stringFromDate:[NSDate date]]];
    NSArray * messages = [query findObjects];
    currentMessages = [NSMutableArray arrayWithArray:messages];
    [self.tvMessages reloadData];
}

- (void)onClose {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
    [textView becomeFirstResponder];
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark UITableViewDataSource
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == 1) {
        [self getMessages];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //assuming some_table_data respresent the table data
    if (currentMessages.count == 0) {
        UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                        self.tvMessages.bounds.size.width,
                                                                        self.tvMessages.bounds.size.height)];
        //set the message
        messageLbl.text = @"No messages from today";
        //center the text
        messageLbl.textAlignment = NSTextAlignmentCenter;
        //auto size the text
        [messageLbl sizeToFit];
        //set back to label view
        self.tvMessages.backgroundView = messageLbl;
        //no separator
        self.tvMessages.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return currentMessages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCellId"];
    }
    
    cell.textLabel.text = currentMessages[currentMessages.count - 1 - indexPath.row][@"text"];
    return cell;
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
