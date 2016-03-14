//
//  ViewController.m
//  LongPressSwipe
//
//  Created by Radi on 3/14/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController {
    
    BOOL rightLongPressSwipe;
    BOOL getTime;
    CGPoint startPoint;
    CGPoint endPoint;
    NSDate *startTime;
    UILongPressGestureRecognizer *longPress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rightLongPressSwipe = YES;
    getTime = NO;
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.2;
    longPress.delegate = self;
    // lpgr.delaysTouchesBegan = YES;
    [self.view addGestureRecognizer:longPress];
    
    UIGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRight.delegate = self;
    [self.view addGestureRecognizer:swipeRight];
}

-(void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"swipe start");
        
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"swipe end");
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        startPoint = [gestureRecognizer locationInView:self.view];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        if (getTime) {
            startTime = [NSDate date];
            getTime = NO;
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled
            || gestureRecognizer.state == UIGestureRecognizerStateFailed
            || gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        endPoint = [gestureRecognizer locationInView:self.view];
        int dy = fabs(endPoint.y - startPoint.y);
        CGFloat dx = rightLongPressSwipe ? endPoint.x - startPoint.x : startPoint.x - endPoint.x ;
        NSDate * now = [NSDate date];
        NSTimeInterval timeDifference =  [now timeIntervalSinceDate:startTime];
        
        if (dy < 100 && dx > 0 && timeDifference < 1) {
            //NSLog(@"Long press drag left");
            [self goNext];
        }
        
        getTime = YES;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer class] == [UILongPressGestureRecognizer class] &&
        [otherGestureRecognizer class] == [UISwipeGestureRecognizer class]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)goNext {
    [self performSegueWithIdentifier:@"goToSecond" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
