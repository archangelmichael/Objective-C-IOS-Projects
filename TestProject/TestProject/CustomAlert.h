//
//  CustomAlert.h
//  TestProject
//
//  Created by Radi on 9/22/15.
//  Copyright © 2015 archangel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIImage+Scaled.h"

typedef enum {
    InfoAlert,
    ErrorAlert
} CustomAlertType;

typedef enum {
    PositionTop = 0,
    PositionBottom = 1
} CustomAlertPosition;

@interface CustomAlert : NSObject

+(void)showAlerWithType:(CustomAlertType)alertType
               position:(CustomAlertPosition)alertPosition
                   text:(NSString *)alertText
               duration:(float)alertDuration;

@end
