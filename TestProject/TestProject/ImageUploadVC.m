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

@property (nonatomic, strong) CMPopTipView *alertView;
@end

@implementation ImageUploadVC {
    UIImage * selectedImage;
    UIImage * downloadedImage;
    ImageDataRequester * dataRequester;
    NSString * uploadedImageId;
    NSMutableArray * uploadedImages;
    
    NSString * lastImageURL;
    NSString * lastImageID;
    
    BOOL isCMPopViewDisplayed;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataRequester = [ImageDataRequester sharedGCDManager];
    isCMPopViewDisplayed = NO;
    self.alertView = [[CMPopTipView alloc] initWithTitle:@"Did you know?"
                                                 message:@"BMW is the best"];
    [self customizeCMPopupView:self.alertView];
    
    [self fetchImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)fetchImages {
    [dataRequester getImagesWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSString *s = [[NSString alloc] initWithData:responseObject
                                            encoding:NSUTF8StringEncoding];
        NSDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding]
                                                                  options:0
                                                                    error:nil];
        if ([jsonData[@"total"] integerValue] > 0) {
            lastImageURL = jsonData[@"results"][0][@"original_file_url"];
            [self getImageIdFromURL:lastImageURL];
            [self getImageFromURL:lastImageURL];
        }
    }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [self showAlertWithTitle:@"Cannot get latest image"
                            text:[NSString stringWithFormat:@"%@", error.userInfo]];
    }];
}

- (void)getImageIdFromURL:(NSString *)imageURLString {
    // IMAGE URL TEMPLATE => http://www.ucarecdn.com/4a7a4324-ea82-48b8-a3cf-ae0f082a84a7/avatar.png
    NSRange range = [imageURLString rangeOfString:@"http://www.ucarecdn.com/"];
    if (range.location != NSNotFound) {
        lastImageID = [imageURLString substringFromIndex:range.length];
        NSRange slashRange = [lastImageID rangeOfString:@"/"];
        lastImageID = [lastImageID substringToIndex:slashRange.location];
    }
    else {
        lastImageID = nil;
    }
}

-(void)getImageFromURL:(NSString *)imageURL {
    NSString * documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    NSString * filePath = [documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", uploadedImageId]];
    [dataRequester getImageFromURL:imageURL
                       withSuccess:^(AFHTTPRequestOperation * operation, id responceObject)
     {
         [self showAlertWithTitle:@"Latest image downloaded"
                             text:@""];
         [[NSFileManager defaultManager] createFileAtPath:filePath
                                                 contents:(NSData*)responceObject
                                               attributes:nil];
         self.ivAvatar.image = [UIImage imageWithContentsOfFile:filePath];
     }
                           failure:^(AFHTTPRequestOperation * operation, NSError * error)
     {
         [self showAlertWithTitle:@"Cannot download latest image"
                             text:[NSString stringWithFormat:@"%@", error.userInfo]];
     }];
}

//- (IBAction)onDownloadImage:(id)sender {
//    self.ivAvatar.image = nil;
//    if (uploadedImageId) {
//        [dataRequester downloadImageForID:uploadedImageId
//                              withSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
//         {
//             NSString *s = [[NSString alloc] initWithData:responseObject
//                                                 encoding:NSUTF8StringEncoding];
//             NSDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding]
//                                                                       options:0
//                                                                         error:nil];
//             [self getImageFromURL:jsonData[@"original_file_url"]];
//             [self showAlertWithTitle:@"Latest image downloaded"
//                                 text:[NSString stringWithFormat:@"%@", jsonData]];
//         }
//                                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
//         {
//             [self showAlertWithTitle:@"Cannot download latest image"
//                                 text:[NSString stringWithFormat:@"%@", error.userInfo]];
//         }];
//    }
//}

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

#pragma mark UIImageViewPickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    selectedImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self onUploadImage:nil];
    NSLog(@"PICK OK");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    selectedImage = nil;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSLog(@"PICK CANCELLED");
}

#pragma mark API Methods
- (IBAction)onUploadImage:(id)sender {
    if (selectedImage) {
        NSData *pngData = UIImagePNGRepresentation(selectedImage);
        [dataRequester uploadImageData:pngData
                           withSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             uploadedImageId = responseObject[@"file"];
             [self onDeleteImage:nil];
             self.ivAvatar.image = selectedImage;
         }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self showAlertWithTitle:@"Cannot upload image"
                                 text:[NSString stringWithFormat:@"%@", error.userInfo]];
             uploadedImageId = nil;
         }];
    }
}

- (IBAction)onDeleteImage:(id)sender {
    if (lastImageID) {
        [dataRequester deleteImageForID:lastImageID
                            withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSString *responseString = [[NSString alloc] initWithData:responseObject
                                                                                 encoding:NSUTF8StringEncoding];
                                [self showAlertWithTitle:@"Image uploaded"
                                                    text:responseString];
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                [self showAlertWithTitle:@"Cannot delete old image"
                                                    text:[NSString stringWithFormat:@"%@", error.userInfo]];
                            }];
        
        lastImageID = uploadedImageId;
    }
}

#pragma mark Alert View Methods
- (void)showAlertWithTitle:(NSString *)title
                      text:(NSString *)text {
    if (isCMPopViewDisplayed) {
        isCMPopViewDisplayed = NO;
        [self.alertView dismissAnimated:YES];
    }
    else {
        isCMPopViewDisplayed = YES;
        self.alertView.delegate = self;
        self.alertView.title = title;
        self.alertView.message = text;
        [self.alertView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem
                                              animated:YES];
    }
}

// CMPopTipViewDelegate method
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    // Any cleanup code, such as releasing a CMPopTipView instance variable, if necessary
   // self.roundRectButtonPopTipView = nil;
    isCMPopViewDisplayed = NO;
}

- (void)customizeCMPopupView:(CMPopTipView *)view {
    view.backgroundColor = [UIColor lightGrayColor];
    
    view.sidePadding = 5;
    view.topMargin = 0; // Range from target view
    view.pointerSize = 10; // Arrow size
    view.bubblePaddingX = 5;
    view.bubblePaddingY = 5;
    
    view.animation = CMPopTipAnimationPop;
    view.maxWidth = 200; // Total Label width
    view.preferredPointDirection = PointDirectionUp;
    
    view.has3DStyle = YES;
    view.hasShadow = NO;
    view.hasGradientBackground = NO;
    
    view.borderColor = [UIColor blackColor];
    view.cornerRadius = 10;
    view.borderWidth = 2;
    
    view.disableTapToDismiss = NO;
    view.dismissTapAnywhere = YES;
    
    view.title = @"Customized Title";
    view.titleColor = [UIColor darkTextColor];
    view.titleFont = [UIFont systemFontOfSize:20];
    view.titleAlignment = NSTextAlignmentCenter;
    view.textAlignment = NSTextAlignmentRight;
    
    view.message = @"Customized Message";
    view.textColor = [UIColor darkTextColor];
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
