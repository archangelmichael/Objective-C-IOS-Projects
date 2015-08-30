//
//  ImageUploadVC.m
//  TestProject
//
//  Created by Radi on 8/30/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ImageUploadVC.h"
#import "ImageDataRequester.h"

@interface ImageUploadVC () 

@property (weak, nonatomic) IBOutlet UITextView *tvOutput;
@property (weak, nonatomic) IBOutlet UIImageView *ivAvatar;
@end

@implementation ImageUploadVC {
    UIImage * selectedImage;
    UIImage * downloadedImage;
    ImageDataRequester * dataRequester;
    NSString * uploadedImageId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataRequester = [ImageDataRequester sharedGCDManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onSelectImage:(id)sender {
    UIImagePickerController * pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.delegate= self;
    pickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:pickerVC animated:YES completion:nil];
}

- (IBAction)onUploadImage:(id)sender {
    if (selectedImage) {
        NSData *pngData = UIImagePNGRepresentation(selectedImage);
        [dataRequester uploadImageData:pngData
                           withSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            uploadedImageId = responseObject[@"file"];
            NSLog(@"Image UPLOADED");
        }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"UPLOAD ERROR : %@", error.userInfo);
             uploadedImageId = nil;
         }];
    }
}

- (IBAction)onDownloadImage:(id)sender {
    self.ivAvatar.image = nil;
    if (uploadedImageId) {
        [dataRequester downloadImageForID:uploadedImageId
                              withSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSString *s = [[NSString alloc] initWithData:responseObject
                                                encoding:NSUTF8StringEncoding];
            NSDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding]
                                                                      options:0
                                                                        error:nil];
            NSLog(@"UPLOAD OK : %@", jsonData);
            [self getImageFromURL:jsonData[@"original_file_url"]];
        }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"DOWNLOAD ERROR : %@", error.userInfo);
        }];
    }
}

-(void)getImageFromURL:(NSString *)imageURL {
    NSString * documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    NSString * filePath = [documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", uploadedImageId]];
    [dataRequester getImageFromURL:imageURL
                       withSuccess:^(AFHTTPRequestOperation * operation, id responceObject)
    {
        [[NSFileManager defaultManager] createFileAtPath:filePath
                                                contents:(NSData*)responceObject
                                              attributes:nil];
        self.ivAvatar.image = [UIImage imageWithContentsOfFile:filePath];
    }
                           failure:^(AFHTTPRequestOperation * operation, NSError * error)
    {
    }];
}

#pragma mark UIImageViewPickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    selectedImage = info[UIImagePickerControllerEditedImage];
    self.ivAvatar.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSLog(@"PICK OK");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    selectedImage = nil;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSLog(@"PICK CANCELLED");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
