//
//  DetailsViewController.h
//  CoreDataAdvanced
//
//  Created by Radi on 6/22/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *versionTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;

@property (strong) NSManagedObject *device;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
