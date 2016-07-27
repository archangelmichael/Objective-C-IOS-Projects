//
//  ViewController.m
//  ImageManipulator
//
//  Created by Radi on 7/27/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ivPicture;

@end

@implementation ViewController {
    NSMutableString * log;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTakePicture:(id)sender {
    [self showTakePictureFrom:self];
}

- (IBAction)onSelectPicture:(id)sender {
    [self showSelectPictureFrom:self];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (chosenImage != nil) {
        log = [[NSMutableString alloc] initWithString:@"Image selected \n"];
        
        CGFloat maxSize = 640.0;
        [log appendString:[NSString stringWithFormat:@"Max size %.0fx%.0f \n", maxSize, maxSize]];
        
        [log appendString:[NSString stringWithFormat:@"Original Image \n"]];
        CGFloat width = chosenImage.size.width;
        CGFloat height = chosenImage.size.height;
        [self showImageSize:chosenImage];
        [self showImageSizeInBytes:chosenImage andCompress:NO];
        
        if (width <= maxSize && height <= maxSize) {
            self.ivPicture.image = chosenImage;
            return;
        }
        
        UIImage * resizedImage = nil;
        if (width > height) {
            resizedImage = [self resizeImage:chosenImage newWidth:maxSize];
        }
        else {
            resizedImage = [self resizeImage:chosenImage newHeight:maxSize];
        }

        [log appendString:[NSString stringWithFormat:@"Resized Image \n"]];
        [self showImageSize:resizedImage];
        [self showImageSizeInBytes:resizedImage andCompress:YES];
        self.ivPicture.image = resizedImage;
        NSLog(@"%@", log);
    }
}

-(void)showImageSize:(UIImage *)image{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    //NSLog(@"%f %f", width, height);
    [log appendString:[NSString stringWithFormat:@"Image size : %.0fx%.0f \n", width, height]];
}

-(void)showImageSizeInBytes:(UIImage *)image andCompress:(BOOL)compress {
    NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 1)];
    float imageSize = (float)imageData.length/1024;
    
    if (!compress) {
        [log appendString:[NSString stringWithFormat:@"Size in kb : %.2f kb \n", imageSize]];
        return;
    }
    
    float compressionRate = 1.0f;
    float compressedSize = imageSize;
    NSData * compressedImgData = nil;
    while (compressedSize > 250 && compressionRate >= 0.2) {
        compressionRate -= 0.1f;
        compressedImgData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, compressionRate)];
        compressedSize = (float)compressedImgData.length/1024;
    }
    
    if (compressedImgData != nil) {
        image = [UIImage imageWithData:compressedImgData];
        [log appendString:[NSString stringWithFormat:@"Compressed %.1f size in kb : %.2f kb \n", compressionRate, compressedSize]];
    }
    else {
        [log appendString:[NSString stringWithFormat:@"Size in kb : %.2f kb \n", imageSize]];
    }
    
    
//    NSLog(@"%.2f Mb", imageSize);
    
//    NSString * bites = [NSByteCountFormatter stringFromByteCount:imageData.length
//                                                      countStyle:NSByteCountFormatterCountStyleFile];
//    NSLog(@"%@ bites", bites);
}

-(UIImage *)resizeImage:(UIImage *)image
               newWidth:(CGFloat)newWidth {
    CGFloat scale = newWidth / image.size.width;
    CGFloat newHeight = image.size.height * scale;
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)resizeImage:(UIImage *)image
              newHeight:(CGFloat)newHeight {
    CGFloat scale = newHeight / image.size.height;
    CGFloat newWidth = image.size.width * scale;
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"Image picker cancelled");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)showTakePictureFrom:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegateVC {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@""
                                                                          message:@"Device has no camera"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action)
                                    {
                                    }];
        
        [alertVC addAction:okButton];
        [(UIViewController *)delegateVC presentViewController:alertVC
                                                     animated:YES
                                                   completion:nil];
        return;
    }
    
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.delegate = delegateVC;
    pickerVC.allowsEditing = YES;
    pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [(UIViewController *)delegateVC presentViewController:pickerVC
                                                 animated:YES
                                               completion:NULL];
    
}

-(void)showSelectPictureFrom:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegateVC {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@""
                                                                          message:@"Device has no photos"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action)
                                    {
                                    }];
        
        [alertVC addAction:okButton];
        [(UIViewController *)delegateVC presentViewController:alertVC
                                                     animated:YES
                                                   completion:nil];
        return;
    }
    
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.delegate = delegateVC;
    pickerVC.allowsEditing = YES;
    pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [(UIViewController *)delegateVC presentViewController:pickerVC
                                                 animated:YES
                                               completion:NULL];
}

@end
