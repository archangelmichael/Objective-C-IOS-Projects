//
//  ResizableTableViewController.m
//  TestProject
//
//  Created by Radi on 9/15/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ResizableTableViewController.h"

#import "ResizableTableViewCell.h"

@interface ResizableTableViewController ()

@end

@implementation ResizableTableViewController {
    CGRect defaultCellFrame;
    CGRect defaultWebViewFrame;
    
    NSArray * messages;
    NSMutableDictionary * rowHeights;
    UIFont * appFont;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    messages = @[@{ @"id" : @"23",
                    @"html" : @"small text on 23 id"} ,
                 
                 @{ @"id" : @"2",
                    @"html" : @"a little bit longer text to take at least 2 lines in the web view for id 2"},
                 
                 @{ @"id" : @"555555",
                    @"html" : @"small text on 555555 id"},
                 
                 @{ @"id" : @"3333333",
                    @"html" : @"a littcx zcx xzc z z cz c xz c zxle bit longer text to take at least 2 lines in the web view for id 2"},
                 
                 @{ @"id" : @"88888",
                    @"html" : @"s888888 88 88 88 88 8 8 8 8 88 8 88ll text on 555555 id"},
                 
                 @{ @"id" : @"999999",
                    @"html" : @"99999hd lkjashd akljsd kjalhd alksjh alkfkl lk ;aslk kl;as klkls;a klas kl;sakl; kl;dks alas;lk ;aslkd ;askd ;lasdl;ask dlalkd ;lask d;askd ;aslkd ;laskd ;asdk asd ;lask d;lak ;laskd ;als zbxxbcasdalas;lk ;aslkd ;askd ;lasdl;ask dlalkd ;lask d;askd ;aslkd ;laskd ;asdk asd ;lask d;lak ;laskd ;als zbxxbcasdalas;lk ;aslkd ;askd ;lasdl;ask dlalkd ;lask d;askd ;aslkd ;laskd ;asdk asd ;lask d;lak ;laskd ;als zbxxbcasdalas;lk ;aslkd ;askd ;lasdl;ask dlalkd ;lask d;askd ;aslkd ;laskd ;asdk asd ;lask d;lak ;laskd ;als zbxxbcasdlasdg"},
                 
                 @{ @"id" : @"1",
                    @"html" : @"current community asdasdsasdblosom  MORE more more reasdk jksllsadlakjshaldskajshd ashd lakshd kasjhd lkashd lkajshd lkjahsd lkajshd lkjashd lkjashd kjashd lkjashd akljsd kjalhd alksjh alkfkl lk ;aslk kl;as klkls;a klas kl;sakl; kl;dks alas;lk ;aslkd ;askd ;lasdl;ask dlalkd ;lask d;askd ;aslkd ;laskd ;asdk asd ;lask d;lak ;laskd ;als zbxxbcasdalas;lk ;aslkd ;askd ;lasdl;ask dlalkd ;lask d;askd ;aslkd ;laskd ;asdk asd ;lask d;lak ;laskd ;als zbxxbcasdalas;lk ;aslkd ;askd ;lasdl;ask dlalkd ;lask d;askd ;aslkd ;laskd ;asdk asd ;lask d;lak ;laskd ;als zbxxbcasdalas;lk ;aslkd ;askd ;lasdl;ask dlalkd ;lask d;askd ;aslkd ;laskd ;asdk asd ;lask d;lak ;laskd ;als zbxxbcasdlasdg"},
                 
                 @{ @"id" : @"45",
                    @"html" : @"smallasdasd asdasd text on 45 id"},
                 
                 @{ @"id" : @"55553333",
                    @"html" : @"small text on 55553333 id salkdja asdhkjhsdhdshpsd h pfhdsfph phfd psdh \n /n \n \n \n ahsdkajshd ;asajsh askjhas;jkhd asjhd ;ahd ;askh k"},
                 
                 @{ @"id" : @"777",
                    @"html" : @"current community overflow.com ckoverflow.sdsadahsd lkajshd lkjashd lkjashd kjashd lkjashd akljsd kjalhd alksjh alkfzbxxbcasdlasdg"}
                 ];
    
    appFont = [UIFont systemFontOfSize:10];
    rowHeights = [[NSMutableDictionary alloc] initWithCapacity:messages.count];
    UINib *nib = [UINib nibWithNibName:[ResizableTableViewCell reuseId] bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:[ResizableTableViewCell reuseId]];
    ResizableTableViewCell * resizableCell = [self.tableView dequeueReusableCellWithIdentifier:[ResizableTableViewCell reuseId]];
    defaultCellFrame = resizableCell.frame;
    defaultWebViewFrame = resizableCell.wvText.frame;
    
    for (NSDictionary * message in messages) {
        UITextView * textView = [[UITextView alloc] initWithFrame:defaultWebViewFrame];
        [textView setFont:appFont];
        textView.text = [message valueForKey:@"html"];
        
        CGFloat fixedWidth = textView.frame.size.width;
        CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        NSLog(@"TEXT HEIGHT : %f", newSize.height);
        float numberOfLines = newSize.height / appFont.lineHeight;

        [rowHeights setValue:[NSNumber numberWithDouble:newSize.height + defaultWebViewFrame.origin.y]
                      forKey:[message valueForKey:@"id"]];
    }
    
    
    // AUTORESIZE TABLE ROWS
    // self.tableView.estimatedRowHeight = [ResizableTableViewCell defaultHeight];
    // self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResizableTableViewCell * cell = (ResizableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[ResizableTableViewCell reuseId]
                                                                                              forIndexPath:indexPath];
    cell.wvText.delegate = self;
    [cell.wvText setUserInteractionEnabled:NO];
    
    NSDictionary * currentMessage = messages[indexPath.row];
    NSString * messageId = [currentMessage valueForKey:@"id"];
    cell.lblTitle.text = [NSString stringWithFormat:@"%@", messageId];
    
    NSString * html = [currentMessage valueForKey:@"html"];
    [cell.wvText loadHTMLString:[self getHTMLWithFontFrom:html] baseURL:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 0 && indexPath.row < messages.count) {
        NSString * messageId = messages[indexPath.row][@"id"];
        return [rowHeights[messageId] doubleValue];
    }
    
    return [ResizableTableViewCell defaultHeight];
}



 -(void)webViewDidFinishLoad:(UIWebView *)webView {
    // Set webview height to 1
    CGRect webFrame = webView.frame;
    webFrame.size.height = 1;
    webView.frame = webFrame;
    
    // Get text size
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    webFrame.size = fittingSize;
    webView.frame = webFrame;
    NSLog(@"WEB HEIGHT : %f", webFrame.size.height);
//
//    ResizableTableViewCell *cell = (ResizableTableViewCell *)[[webView superview] superview];
//    cell.cstrWebViewHeight.constant = webFrame.size.height;
//    [webView layoutIfNeeded];
//    [cell setNeedsLayout];
    
//        ResizableTableViewCell *cell = (ResizableTableViewCell *)[[webView superview] superview];
//        cell.frame = CGRectMake(cell.frame.origin.x,
//                                cell.frame.origin.y,
//                                cell.frame.size.width,
//                                cell.frame.size.height + webFrame.size.height + 8);
//    [cell setNeedsLayout];
//    [self.tableView beginUpdates];
////    [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]]
////                          withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView endUpdates];
}

-(NSString *)getHTMLWithFontFrom:(NSString *)html {
    return [NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %i\">%@</span>",
                  appFont.fontName,
                  (int) appFont.pointSize,
                  html];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
