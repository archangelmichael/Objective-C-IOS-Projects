//
//  PickSaveLoadImageViewController.m
//  TestProject
//
//  Created by Radi on 8/11/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "PickSaveLoadImageViewController.h"

@interface PickSaveLoadImageViewController () {
    UIImage * selectedImage;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *buttonTakePic;

@end

@implementation PickSaveLoadImageViewController

NSString * const AVATAR_IMAGE_NAME = @"avatar.png";

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedImage = nil;
    
}

- (IBAction)onPickImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)onTakeImage:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)onSaveImage:(id)sender {
    if (selectedImage == nil) {
        return;
    }
    
    // pulls out PNG data of the image you've captured
    NSData *pngData = UIImagePNGRepresentation(selectedImage);
    [pngData writeToFile:[self documentsPathForFileName:AVATAR_IMAGE_NAME]
              atomically:YES]; //Write the file
}

- (IBAction)onLoadImage:(id)sender {
    NSData *pngData = [NSData dataWithContentsOfFile:[self documentsPathForFileName:AVATAR_IMAGE_NAME]];
    UIImage *image = [UIImage imageWithData:pngData];
    if (image) {
        self.imageView.image = image;
    }
}

- (NSString *)documentsPathForFileName:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:name];
}

#pragma mark UIImageViewPickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    selectedImage = chosenImage;
    [self onSaveImage:nil];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
