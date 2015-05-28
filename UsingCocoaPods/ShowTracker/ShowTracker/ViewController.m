//
//  RWViewController.m
//  ShowTracker
//
//  Created by Joshua on 3/1/14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

#import "ViewController.h"
#import "TraktAPIClient.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import <SAMCategories/UIScreen+SAMAdditions.h>

@interface ViewController ()
@property (nonatomic, strong) NSArray *jsonResponse;
@property (nonatomic) BOOL pageControlUsed;
@property (nonatomic) NSInteger previousPage;
@end

@implementation ViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    self.previousPage = -1;
    
    TraktAPIClient *client = [TraktAPIClient sharedClient];
    [client getAllShowsFromDate:[NSDate date]
                forNumberOfDays:1
                        success:^(NSURLSessionDataTask *task, id responseObject) {
                            NSLog(@"Success -- %@", responseObject[0]);
                            self.jsonResponse = responseObject;
                            NSInteger shows = self.jsonResponse.count;
                            // Set up page control
                            self.showsPageControl.numberOfPages = shows;
                            self.showsPageControl.currentPage = 0;
                            
                            // Set up scroll view
                            self.showsScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) * shows,
                                                                          CGRectGetHeight(self.showsScrollView.frame));
                            // Load first show
                            [self loadShow:0];
                        }
                        failure:^(NSURLSessionDataTask *task, NSError *error) {
                            NSLog(@"Failure -- %@", error);
                        }];
    [super viewDidLoad];
}

#pragma mark - Actions
- (IBAction)pageChanged:(id)sender {
    // Set flag
    self.pageControlUsed = YES;
    
    // Get previous page number
    NSInteger page = self.showsPageControl.currentPage;
    self.previousPage = page;
    
    // Call loadShow for the new page
    [self loadShow:page];
    
    // Scroll scroll view to new page
    CGRect frame = self.showsScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [UIView animateWithDuration:.5 animations:^{
        [self.showsScrollView scrollRectToVisible:frame animated:NO];
    } completion:^(BOOL finished) {
        self.pageControlUsed = NO;
    }];
}

- (void)loadShow:(NSInteger)index {
    NSDictionary *entry = self.jsonResponse[index];
    
    // Display show title
    NSDictionary *show = entry[@"show"];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(index * CGRectGetWidth(self.showsScrollView.bounds) + 20, 40,
                                                                    CGRectGetWidth(self.showsScrollView.bounds) - 40, 40)];
    titleLabel.text = show[@"title"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.showsScrollView addSubview:titleLabel];
    
    // Display show year
    int year = (show[@"year"] != nil ? [show[@"year"] intValue] : 2015);
    UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(index * CGRectGetWidth(self.showsScrollView.bounds) + 20,
                                                                   titleLabel.frame.size.height + titleLabel.frame.origin.y,
                                                                   CGRectGetWidth(self.showsScrollView.bounds) - 40,
                                                                   40)];
    yearLabel.text = [NSString stringWithFormat:@"%i", year];
    yearLabel.backgroundColor = [UIColor clearColor];
    yearLabel.textColor = [UIColor whiteColor];
    yearLabel.font = [UIFont boldSystemFontOfSize:18];
    yearLabel.textAlignment = NSTextAlignmentCenter;
    [self.showsScrollView addSubview:yearLabel];
    
    
    // Display show first air date
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterLongStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    }
    
    NSTimeInterval showAired = [entry[@"first_aired"] doubleValue];
    NSString *showDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:showAired]];
    
    // Display episode info
    NSDictionary *episode = entry[@"episode"];
    UILabel *episodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(index * CGRectGetWidth(self.showsScrollView.bounds), 360,
                                                                      CGRectGetWidth(self.showsScrollView.bounds), 40)];
    NSString* episodeInfo  = [NSString stringWithFormat:@"%02dx%02d - \"%@\"",
                              (episode[@"season"] ? [episode[@"season"] intValue] : 2015),
                              (episode[@"number"] ? [episode[@"number"] intValue] : 2015),
                              episode[@"title"]];
    episodeLabel.text = [NSString stringWithFormat:@"%@\n%@", episodeInfo, showDate];
    episodeLabel.numberOfLines = 0;
    episodeLabel.textAlignment = NSTextAlignmentCenter;
    episodeLabel.textColor = [UIColor whiteColor];
    episodeLabel.backgroundColor = [UIColor clearColor];
    
    CGSize size = [episodeLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.view.frame),
                                                        CGRectGetHeight(self.view.frame) - CGRectGetMinY(episodeLabel.frame))];
    CGRect frame = episodeLabel.frame;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = size.height;
    episodeLabel.frame = frame;
    [self.showsScrollView addSubview:episodeLabel];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Was the scrolling initiated via page control?
    if (self.pageControlUsed)
        return;
    
    // Figure out page to scroll to
    CGFloat pageWidth = sender.frame.size.width;
    NSInteger page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    // Do not do anything if we're trying to go beyond the available page range
    if (page == self.previousPage || page < 0 || page >= self.showsPageControl.numberOfPages)
        return;
    self.previousPage = page;
    
    // Set the page control page display
    self.showsPageControl.currentPage = page;
    
    // Load the page
    [self loadShow:page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControlUsed = NO;
}
@end
