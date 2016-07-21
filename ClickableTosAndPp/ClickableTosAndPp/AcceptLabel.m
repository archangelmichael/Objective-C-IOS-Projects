//
//  AcceptLabel.m
//  ClickableTosAndPp
//
//  Created by Radi on 7/21/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "AcceptLabel.h"

@implementation AcceptLabel {
    NSString * start; // I agree with
    NSString * tos; // terms
    NSString * connector; // and
    NSString * pp; // conditions
    
    NSRange tosRange;
    NSRange ppRange;
    UITapGestureRecognizer * lblTap;
} 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    start = @"I agree with ";
    tos = @"terms";
    connector = @" and ";
    pp = @"conditions";
    
    self.userInteractionEnabled = YES;
    tosRange = NSMakeRange(0, 0);
    ppRange = NSMakeRange(0, 0);
    [self setAcceptText];
    
    lblTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                     action:@selector(handleTapOnLabel:)];
    [self addGestureRecognizer:lblTap];
}

- (void)setAcceptText {
    UIColor * normalTextColor = [UIColor darkGrayColor];
    UIColor * linkTextColor = [UIColor blackColor];
    UIColor * backgroundColor = [UIColor clearColor];
    float fontSize = 14.0;
    UIFont * normalFont = [UIFont systemFontOfSize:fontSize];
    UIFont * linkFont = [UIFont boldSystemFontOfSize:fontSize];
    
    NSDictionary * normalAttributes = @{ NSFontAttributeName : normalFont,
                                         NSForegroundColorAttributeName : normalTextColor,
                                         NSBackgroundColorAttributeName: backgroundColor };
    NSDictionary * linkAttributes = @{ NSFontAttributeName : linkFont,
                                       NSForegroundColorAttributeName : linkTextColor,
                                       NSBackgroundColorAttributeName: backgroundColor,
                                       NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
    
    NSMutableAttributedString * attributedStart = [[NSMutableAttributedString alloc] initWithString:start
                                                                                          attributes:normalAttributes];
    NSMutableAttributedString * attributedTOS = [[NSMutableAttributedString alloc] initWithString:tos
                                                                                          attributes:linkAttributes];
    NSMutableAttributedString * attributedAnd = [[NSMutableAttributedString alloc] initWithString:connector
                                                                                          attributes:normalAttributes];
    NSMutableAttributedString * attributedPP = [[NSMutableAttributedString alloc] initWithString:pp
                                                                                          attributes:linkAttributes];
    
    [attributedStart appendAttributedString:attributedTOS];
    tosRange = NSMakeRange(start.length, tos.length);
    
    [attributedStart appendAttributedString:attributedAnd];
    [attributedStart appendAttributedString:attributedPP];
    ppRange = NSMakeRange(attributedStart.length - attributedPP.length, attributedPP.length);
    
    self.attributedText = attributedStart;
}

//-(void)dealloc {
//    [self removeGestureRecognizer:lblTap];
//}

- (void)handleTapOnLabel:(UITapGestureRecognizer *)tapGesture {
    
    BOOL didTapTOS = [self didTapHitTextInRange:tosRange];
    if (didTapTOS) {
        [self.delegate tosTapped];
        return;
    }
    
    BOOL didTapPP = [self didTapHitTextInRange:ppRange];
    if (didTapPP) {
        [self.delegate ppTapped];
        return;
    }
    
    NSLog(@"Label tapped");
}

- (BOOL)didTapHitTextInRange:(NSRange)targetRange {
    CGSize lblSize = self.bounds.size;
    NSLayoutManager * layoutManager = [[NSLayoutManager alloc] init];
    NSTextContainer * textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    NSTextStorage * textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    
    // Configure layoutManager and textStorage
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    
    // Configure textContainer
    textContainer.lineFragmentPadding = 0.0;
    textContainer.lineBreakMode = self.lineBreakMode;
    textContainer.maximumNumberOfLines = self.numberOfLines;
    textContainer.size = lblSize;
    
    // find the tapped character location and compare it to the specified range
    CGPoint locationOfTouchInLabel = [lblTap locationInView:self];
    CGRect textBoundingBox = [layoutManager usedRectForTextContainer:textContainer];
    CGPoint textContainerOffset = CGPointMake((lblSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              (lblSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
    
    CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                         locationOfTouchInLabel.y - textContainerOffset.y);
    
    NSInteger indexOfCharacter = [layoutManager characterIndexForPoint:locationOfTouchInTextContainer
                                                       inTextContainer:textContainer
                              fractionOfDistanceBetweenInsertionPoints:nil];
    
    if (NSLocationInRange(indexOfCharacter, targetRange)) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
