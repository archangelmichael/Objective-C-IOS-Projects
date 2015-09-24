//
//  CustomAlert.m
//  TestProject
//
//  Created by Radi on 9/22/15.
//  Copyright © 2015 archangel. All rights reserved.
//

#import "CustomAlert.h"

@implementation CustomAlert
static float alertLabelTop = 5;
static float alertLabelSide = 10;
static float alertFontSize = 15;
static float alertImageTopOffset = -5;
static float alertImageSize = 20;
static float alertViewDefaultHeight = 20;

+(void)showAlerWithType:(CustomAlertType)alertType
               position:(CustomAlertPosition)alertPosition
                   text:(NSString *)alertText
               duration:(float)alertDuration {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    float windowWidth = window.frame.size.width;
    float windowHeight = window.frame.size.height;
    float windowTop = window.frame.origin.y;
    if (![[UIApplication sharedApplication] isStatusBarHidden]) {
        windowTop += 20; //for status bar height
    }
    
    UIView * alertView = [[UIView alloc] init];
    float alertViewTop = alertPosition == PositionTop ? windowTop : windowHeight - alertViewDefaultHeight;
    CGRect alertViewDefaultFrame = CGRectMake(0, alertViewTop, windowWidth, alertViewDefaultHeight);
    alertView.frame = alertViewDefaultFrame;
    alertView.backgroundColor = alertType == InfoAlert ? [UIColor greenColor] : [UIColor redColor];
    alertView.alpha = 0.0f;
    
    NSMutableAttributedString * attributedText = [self getAttributedStringWithText:alertText];
    
    UILabel * alertLabel = [[UILabel alloc] init];
    alertLabel.attributedText = attributedText;
    alertLabel.numberOfLines = 0;
    alertLabel.backgroundColor = [UIColor clearColor];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.font = [UIFont systemFontOfSize:alertFontSize];
    alertLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [alertView addSubview:alertLabel];
    
    CGFloat alertLabelHeight = [self getTextHeightIn:alertLabel
                                           withWidth:(alertViewDefaultFrame.size.width - 2 * alertLabelSide - alertImageSize + 20)];
    
    double alertViewNewHeight = alertLabelHeight + alertLabelTop * 2;
    if (alertViewNewHeight < alertViewDefaultHeight) {
        alertViewNewHeight = alertViewDefaultHeight;
    }
    
    float alertViewNewTop = alertPosition == PositionTop ? windowTop : windowHeight - alertViewNewHeight;
    CGRect alertViewUpdatedFrame = alertViewDefaultFrame;
    alertViewUpdatedFrame.size.height = alertViewNewHeight;
    alertViewUpdatedFrame.origin.y = alertViewNewTop;
    alertView.frame = alertViewUpdatedFrame;
    alertLabel.frame = CGRectMake(alertLabelSide,
                                  alertLabelTop,
                                  alertViewUpdatedFrame.size.width - 2 * alertLabelSide,
                                  alertLabelHeight);
    [self showNotificationWithView:alertView
                       forDuration:alertDuration];
}

+(NSMutableAttributedString *)getAttributedStringWithText:(NSString *)alertText {
    float imageTopOffset = alertImageTopOffset;
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [[UIImage imageNamed:@"warning-white.png"] imageScaledToSize:CGSizeMake(alertImageSize, alertImageSize)];
    attachment.bounds = CGRectMake(0, imageTopOffset,
                                   attachment.image.size.width, attachment.image.size.height);
    
    NSAttributedString *alertImage = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString * alertContent = [[NSMutableAttributedString alloc] initWithString:@""];
    [alertContent appendAttributedString:alertImage];
    
    NSMutableAttributedString * alertString = [[NSMutableAttributedString alloc] initWithString:alertText];
    [alertContent appendAttributedString:alertString];
    return alertContent;
}

+(CGFloat)getTextHeightIn:(UILabel *)label
                withWidth:(float)width {
    CGSize sizeOfText = [label.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:[NSDictionary dictionaryWithObject:label.font
                                                                                     forKey:NSFontAttributeName]
                                                 context: nil].size;
    
    return sizeOfText.height;
}

+(void)showNotificationWithView:(UIView*)alertView
                    forDuration:(float)duration {
    if (duration <= 1.0) {
        duration = 2.0;
    }
    
    alertView.alpha = 0.0f;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:alertView];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         alertView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [self performSelector:@selector(hideAlert:)
                                    withObject:alertView
                                    afterDelay:duration];
                     }];
}

+(void)hideAlert:(UIView *)alertView {
    [UIView animateWithDuration:1.0
                     animations:^{
                         alertView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [alertView removeFromSuperview];
                     }];
}

@end
