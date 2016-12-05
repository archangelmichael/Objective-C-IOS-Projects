//
//  ViewController.m
//  LabelWithLinks
//
//  Created by Radi on 10/20/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "ViewController.h"
#import "TTTAttributedLabel.h"

@interface ViewController () <UITextViewDelegate, TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTappable;
@property (weak, nonatomic) IBOutlet UITextView *tvTappable;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tttLbl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * html = @"<a href=\"#scrum\" class=\"extracted_hashtag\">#scrum</a> <a href=\"#training\" class=\"extracted_hashtag\">#training</a> <a href=\"#scrum\" class=\"extracted_hashtag\">#scrum</a> <a href=\"#training\" class=\"extracted_hashtag\">#training</a>  j kasjklas jjd asjhjashd j kkajs hlajshd ad lkd  <a href=\"www.abv.bg\" class=\"extracted_link\">www.abv.bg</a>  asd as <a href=\"#scrum\" class=\"extracted_hashtag\">#scrum</a> <a href=\"#training\" class=\"extracted_hashtag\">#training</a> das dasd ad as das d <a href=\"www.abv.bg\" class=\"extracted_link\">www.abv.bg</a> da ds da<a href=\"#scrum\" class=\"extracted_hashtag\">#scrum</a> <a href=\"#training\" class=\"extracted_hashtag\">#training</a><a href=\"#scrum\" class=\"extracted_hashtag\">#scrum</a> <a href=\"#training\" class=\"extracted_hashtag\">#training</a> das dasd ad3123 1412412^&^%*&(&$%%#@$ &*^*&&%$^#%#<a href=\"#scrum\" class=\"extracted_hashtag\">#scrum</a> <a href=\"#training\" class=\"extracted_hashtag\">#training</a><a href=\"@scrum\" class=\"extracted_hashtag\">@scrum</a> <a href=\"#training\" class=\"extracted_hashtag\">#training</a><a href=\"#scrum\" class=\"extracted_hashtag\">#scrum</a> \n <a href=\"#training\" class=\"extracted_hashtag\">#training</a> \n <a href=\"@scrum\" class=\"extracted_hashtag\">@scrum</a> \n <a href=\"#training\" class=\"extracted_hashtag\">#training</a> <a href=\"@petko\" class=\"extracted_mention\">@petko</a> take some cold beers";
    
    // cell.lblComment.text = [dataManager getStringWithFontFormat:message.text];
    NSAttributedString * attrHTMLStr = [[NSAttributedString alloc] initWithData:[[self parseDotTags:html] dataUsingEncoding:NSUnicodeStringEncoding]
                                                                        options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                             documentAttributes:nil
                                                                          error:nil];
    [self.tttLbl setLinkAttributes:@{
                                     (id)kCTForegroundColorAttributeName : (id)[UIColor redColor].CGColor,
                                     NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
                                     NSKernAttributeName : [NSNull null],
                                     (id)kTTTBackgroundFillColorAttributeName : (id)[UIColor greenColor].CGColor
                                     }];
    [self.tttLbl setText:attrHTMLStr];
    self.tttLbl.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
    self.tttLbl.delegate = self;
    
    //self.lblTappable.attributedText = attrHTMLStr;
    self.lblTappable.text = [self getText:html];
    
    self.tvTappable.attributedText = attrHTMLStr;
    self.tvTappable.selectable = true;
    self.tvTappable.userInteractionEnabled = true;
    self.tvTappable.delegate = self;
    self.tvTappable.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor redColor],
                                           NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)};
    
}

- (NSString *)parseDotTags:(NSString *)html {
    return [[html stringByReplacingOccurrencesOfString:@"href=\"#" withString:@"href=\"dot#"] stringByReplacingOccurrencesOfString:@"href=\"@" withString:@"href=\"www.dot@"];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    NSString * ulrQuery = url.host;
    
        NSArray<NSString *> * urlParams = url.pathComponents;
        if (urlParams.count == 2 && [urlParams[0] isEqualToString:@"/"]) {
            NSString * dotIDStr = urlParams[1];
            int dotID = dotIDStr.intValue;
        }
    

    int a = 5;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents {
    int a = 5;
}

-(NSString*)getText:(NSString*)text {
    NSString *s = [[text stringByReplacingOccurrencesOfString:@"</a>"
                                                   withString:@""]
                   stringByReplacingOccurrencesOfString:@"<br />\n"
                   withString:@"\n"];
    NSRange r0;
    while((r0 = [s rangeOfString:@"<a href"]).length>0) {
        NSRange r2 = [s rangeOfString:@"class=\"extracted_"
                              options:0
                                range:NSMakeRange(r0.location, s.length-r0.location)];
        if (r2.length <= 0 || r2.location + 21 > s.length)  {
            break;
        }
        
        NSString *next = [s substringWithRange:NSMakeRange(r2.location,21)];
        int len = ([next isEqualToString:@"extracted_link"] ? 23 : [next isEqualToString:@"extracted_has"] ? 22 : 26);
        s = [s stringByReplacingCharactersInRange:NSMakeRange(r0.location, MIN(r2.location + len,s.length) - r0.location)
                                       withString:@""];
    }
    
    return s;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if (![URL.absoluteString isEqualToString:@""]) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@""
                                                                          message:@"2"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"ok"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alertVC addAction:alertAction];
        [self presentViewController:alertVC animated:true completion:nil];
        return true;
    }
    
    return false;
}

//- (void)buildAgreeTextViewFromString:(NSString *)localizedString
//{
//    // 1. Split the localized string on the # sign:
//    NSArray *localizedStringPieces = [localizedString componentsSeparatedByString:@"#"];
//    
//    // 2. Loop through all the pieces:
//    NSUInteger msgChunkCount = localizedStringPieces ? localizedStringPieces.count : 0;
//    CGPoint wordLocation = CGPointMake(0.0, 0.0);
//    for (NSUInteger i = 0; i < msgChunkCount; i++)
//    {
//        NSString *chunk = [localizedStringPieces objectAtIndex:i];
//        if ([chunk isEqualToString:@""])
//        {
//            continue;     // skip this loop if the chunk is empty
//        }
//        
//        // 3. Determine what type of word this is:
//        BOOL isTermsOfServiceLink = [chunk hasPrefix:@"<ts>"];
//        BOOL isPrivacyPolicyLink  = [chunk hasPrefix:@"<pp>"];
//        BOOL isLink = (BOOL)(isTermsOfServiceLink || isPrivacyPolicyLink);
//        
//        // 4. Create label, styling dependent on whether it's a link:
//        UILabel *label = [[UILabel alloc] init];
//        label.font = [UIFont systemFontOfSize:15.0f];
//        label.text = chunk;
//        label.userInteractionEnabled = isLink;
//        
//        if (isLink)
//        {
//            label.textColor = [UIColor colorWithRed:110/255.0f green:181/255.0f blue:229/255.0f alpha:1.0];
//            label.highlightedTextColor = [UIColor yellowColor];
//            
//            // 5. Set tap gesture for this clickable text:
//            SEL selectorAction = isTermsOfServiceLink ? @selector(tapOnTermsOfServiceLink:) : @selector(tapOnPrivacyPolicyLink:);
//            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                         action:selectorAction];
//            [label addGestureRecognizer:tapGesture];
//            
//            // Trim the markup characters from the label:
//            if (isTermsOfServiceLink)
//                label.text = [label.text stringByReplacingOccurrencesOfString:@"<ts>" withString:@""];
//            if (isPrivacyPolicyLink)
//                label.text = [label.text stringByReplacingOccurrencesOfString:@"<pp>" withString:@""];
//        }
//        else
//        {
//            label.textColor = [UIColor whiteColor];
//        }
//        
//        // 6. Lay out the labels so it forms a complete sentence again:
//        
//        // If this word doesn't fit at end of this line, then move it to the next
//        // line and make sure any leading spaces are stripped off so it aligns nicely:
//        
//        [label sizeToFit];
//        
//        if (self.agreeTextContainerView.frame.size.width < wordLocation.x + label.bounds.size.width)
//        {
//            wordLocation.x = 0.0;                       // move this word all the way to the left...
//            wordLocation.y += label.frame.size.height;  // ...on the next line
//            
//            // And trim of any leading white space:
//            NSRange startingWhiteSpaceRange = [label.text rangeOfString:@"^\\s*"
//                                                                options:NSRegularExpressionSearch];
//            if (startingWhiteSpaceRange.location == 0)
//            {
//                label.text = [label.text stringByReplacingCharactersInRange:startingWhiteSpaceRange
//                                                                 withString:@""];
//                [label sizeToFit];
//            }
//        }
//        
//        // Set the location for this label:
//        label.frame = CGRectMake(wordLocation.x,
//                                 wordLocation.y,
//                                 label.frame.size.width,
//                                 label.frame.size.height);
//        // Show this label:
//        [self.agreeTextContainerView addSubview:label];
//        
//        // Update the horizontal position for the next word:
//        wordLocation.x += label.frame.size.width;
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
