//
//  AcceptLabel.h
//  ClickableTosAndPp
//
//  Created by Radi on 7/21/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AcceptLabelDelegate <NSObject>

@required
-(void)tosTapped;

@required
-(void)ppTapped;

@end

@interface AcceptLabel : UILabel

@property (nonatomic, assign) id<AcceptLabelDelegate> delegate;

@end
