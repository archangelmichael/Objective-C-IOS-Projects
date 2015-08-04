//
//  DetailsViewController.m
//  tabbedSHIT
//
//  Created by Radi on 7/29/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "DetailsViewController.h"
#import "SomeModel.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)onRemoveContent:(id)sender {
    self.firstLabel.hidden = YES;
    self.secondLabel.hidden = YES;
    CGRect frame =  self.secondLabel.frame;
    frame.size.height = 0;
    [self.secondLabel setFrame:frame];
    
    [self.secondLabel setNeedsLayout];
    [self.secondLabel updateConstraints];
    
    
    [self.masterView setNeedsLayout];
    [self.masterView updateConstraints];
    
    [self.masterView layoutSubviews];
    [self.masterView needsUpdateConstraints];
}

- (IBAction)onAddContent:(id)sender {
    self.firstLabel.hidden = NO;
    self.secondLabel.hidden = NO;
    [self.masterView updateConstraints];
    [self.masterView needsUpdateConstraints];
}

- (IBAction)onGetMonth:(id)sender {
    NSDate * now = [NSDate date];
    NSCalendar * currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents * components = [currentCalendar components:NSCalendarUnitMonth
                                                       fromDate:now];
    NSInteger currentMonth = [components month];
    [[[UIAlertView alloc] initWithTitle:@"CURRENT MONTH"
                                message:[NSString stringWithFormat:@"%li", (long)currentMonth]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles: nil] show];
}

- (IBAction)saveArrayToDefaults:(id)sender {
    SomeModel * some1 = [[SomeModel alloc] init];
    some1.title = @"Some Title";
    some1.date = [NSDate date];
    
    NSMutableArray * someArray = [NSMutableArray arrayWithObjects:some1, some1, some1, nil];
    NSMutableArray * archiveArray = [NSMutableArray arrayWithCapacity:someArray.count];
    for (SomeModel * someObject in someArray) {
        NSData * someEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:someObject];
        [archiveArray addObject:someEncodedObject];
    }
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:archiveArray forKey:@"somearray"];
    [defaults synchronize];
}

- (IBAction)loadDefaultsArray:(id)sender {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray * archivedArray = [NSMutableArray arrayWithArray:[defaults arrayForKey:@"somearray"]];
    NSMutableArray * someArray = [NSMutableArray array];
    for (NSData * data in archivedArray) {
        SomeModel * someModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [someArray addObject:someModel];
    }
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    for (SomeModel * model in someArray) {
        NSLog(@"Title : %@", model.title);
        NSLog(@"Date : %@", [dateFormatter stringFromDate:model.date]);
    }
}


@end
