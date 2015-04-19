//
//  RegistrationUIView.h
//  RegistrationWithCustomView
//
//  Created by Radi on 4/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationUIView : UIView
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end
