//
//  MessagesVC.m
//  PushNotifications
//
//  Created by Radi on 8/27/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "MessagesVC.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface MessagesVC ()

@property (weak, nonatomic) IBOutlet UITableView *tvMessages;
@property (weak, nonatomic) IBOutlet UITextView *tvNewMessage;
@property (weak, nonatomic) IBOutlet UILabel *labelGreeting;

@end

@implementation MessagesVC {
    AppDelegate * app;
    NSMutableArray * currentMessages;
    NSDateFormatter * dateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onReplyNotificationReceived)
                                                 name:NotificationActionReplyName
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeleteNotificationReceived)
                                                 name:NotificationActionDeleteName
                                               object:nil];
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
    [self.tvMessages setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tvNewMessage.delegate = self;
    [self getMessages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogout:(id)sender {
    [PFUser logOut];
    [app setUserDefaultUsername:@"" password:@""];
    [self onClose];
}

- (IBAction)onSendMessage:(id)sender {
    PFObject * newMessage = [PFObject objectWithClassName:@"Message"];
    newMessage[@"text"] = self.tvNewMessage.text;
    newMessage[@"date"] = [dateFormatter stringFromDate:[NSDate date]];
    [newMessage saveInBackgroundWithBlock:^(BOOL done, NSError *error) {
        if (!error) {
            if (DEVICE_VERSION >= 8) {
                [app scheduleNotificationWithTitle:@"New comment added"
                                              date:[NSDate dateWithTimeIntervalSinceNow:5]];
            }
            else {
                [app scheduleSimpleLocalNotificationWithTitle:@"New comment added"
                                                         date:[NSDate dateWithTimeIntervalSinceNow:5]];
            }
            
            
            // [self sendLocalNotification];
            self.tvNewMessage.text = @"";
            [self getMessages];
        }
        else {
            self.tvNewMessage.text = @"ERROR";
        }
    }];
}

- (void)sendLocalNotification {
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
    localNotification.alertBody = @"Your alert message";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)getMessages {
    [currentMessages removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"date" equalTo:[dateFormatter stringFromDate:[NSDate date]]];
    NSArray * messages = [query findObjects];
    [currentMessages addObjectsFromArray:messages];
    [self.tvMessages reloadData];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)onClose {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark NSNotificationCenter Methods
- (void) onReplyNotificationReceived {
    [self textViewDidBeginEditing:self.tvNewMessage];
}

- (void) onDeleteNotificationReceived {
    // TODO: Delete Item
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(currentMessages.count > 0){
        self.tvMessages.backgroundView = nil;
        return currentMessages.count;
    }
    
    // Display a message when the table is empty
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    messageLabel.text = @"No data, pull to refresh";
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [messageLabel sizeToFit];
    
    self.tvMessages.backgroundView = messageLabel;
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCellId"];
    }
    
    cell.textLabel.text = currentMessages[currentMessages.count - 1 - indexPath.row][@"text"];
    return cell;
}

#pragma mark UITableViewDelegate methods
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Delete me";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject * messageToDelete = currentMessages[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [messageToDelete deleteInBackgroundWithBlock:^(BOOL done, NSError *error) {
            if (!error) {
                [self removeMessageFromTable:tableView atIndexPath:indexPath];
            }
        }];
    }
    
    [tableView setEditing:NO animated:YES];
}

-(void)removeMessageFromTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    [currentMessages removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
