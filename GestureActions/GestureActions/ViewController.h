//
//  ViewController.h
//  GestureActions
//
//  Created by Radi on 4/20/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)swipe:(UISwipeGestureRecognizer *)recognizer;

- (IBAction)pich:(UIPinchGestureRecognizer *)sender;
- (IBAction)pan:(UIPanGestureRecognizer *)sender;

@end

