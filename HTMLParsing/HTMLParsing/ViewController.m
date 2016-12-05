//
//  ViewController.m
//  HTMLParsing
//
//  Created by Radi on 10/24/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblHTML;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblHTML.attributedText = [self getAttributedDotHtmlManually:@""];
    self.lblHTML.userInteractionEnabled = true;
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSAttributedString *)getAttributedDotHtmlManually:(NSString *)noNewLinesStr {
    
    NSMutableAttributedString * attrHtml = [[NSMutableAttributedString alloc] init];
    
    NSDictionary * normalAttr = @{
                                  NSForegroundColorAttributeName : [UIColor lightGrayColor],
                                  NSFontAttributeName : [UIFont systemFontOfSize:16],
                                  };
    NSDictionary * linkAttr = @{
                                NSForegroundColorAttributeName : [UIColor blackColor],
                                NSFontAttributeName : [UIFont systemFontOfSize:18]
                                };
    
    noNewLinesStr = @"<a href=\"@dog\" class=\"extracted_mension\">@dog</a> <a href=\"#dotisfun\" class=\"extracted_link\">www.abv.bg</a>First silent Facebook share <a href=\"#dotisfun\" class=\"extracted_hashtag\">#dotisfun</a> the best!!!";
    // First silent Facebook share <a href="#dotisfun" class="extracted_hashtag">#dotisfun</a> the best!!!
    NSRange rangeOpenLink = [noNewLinesStr rangeOfString:@"<a href=\""];
    NSRange rangeLinkEnd = [noNewLinesStr rangeOfString:@"</a>"];
    while (rangeOpenLink.length > 0 && rangeLinkEnd.length > 0) {
        // Get text before link
        NSString * plainText = [noNewLinesStr substringToIndex:rangeOpenLink.location];
        if (plainText.length > 0) {
            NSAttributedString * attrPlainText = [[NSAttributedString alloc] initWithString:plainText
                                                                                 attributes:normalAttr];
            [attrHtml appendAttributedString:attrPlainText];
        }
        
        NSString * linkContent = [noNewLinesStr substringWithRange:NSMakeRange(rangeOpenLink.location, rangeLinkEnd.location - rangeOpenLink.location)];
        
        NSRange rangeCloseLink = [linkContent rangeOfString:@">"];
        NSString * linkText = [linkContent substringFromIndex:rangeCloseLink.location + rangeCloseLink.length];
        
        NSMutableAttributedString * attrLinkText = [[NSMutableAttributedString alloc] initWithString:linkText
                                                                                          attributes:linkAttr];
        [attrLinkText addAttribute:NSLinkAttributeName
                             value:[NSString stringWithFormat:@"https://dotisfun.com/%@", linkContent]
                             range:NSMakeRange(0, linkText.length)];
        [attrHtml appendAttributedString:attrLinkText];
        
        noNewLinesStr = [noNewLinesStr substringFromIndex:rangeLinkEnd.location + rangeLinkEnd.length];
        rangeOpenLink = [noNewLinesStr rangeOfString:@"<a href=\""];
        rangeLinkEnd = [noNewLinesStr rangeOfString:@"</a>"];
    }
    
    if (noNewLinesStr.length > 0) {
        NSAttributedString * attrPlainText = [[NSAttributedString alloc] initWithString:noNewLinesStr
                                                                             attributes:normalAttr];
        [attrHtml appendAttributedString:attrPlainText];
    }
    
    return attrHtml;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
