//
//  ShareViewController.m
//  Image
//
//  Created by Radi on 11/4/16.
//  Copyright © 2016 Oryx. All rights reserved.
//

#import "ShareViewController.h"

// Comment this line to show post screen
#define HIDE_POST_DIALOG
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface ShareViewController ()

@end

@implementation ShareViewController
// Keeps track of the number of attachments we have opened asynchronously.
NSUInteger m_inputItemCount = 0;

// A string to be passed to your AIR app with information about the attachments.
NSString * m_invokeArgs = nil;

NSString * APP_SHARE_GROUP = @"group.com.oryx.testapp";
NSString * APP_SHARE_URL_SCHEME = @"testapp";

// Keeps the original transparency of the Post dialog for when we want to hide it.
CGFloat m_oldAlpha = 1.0;

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
#ifdef HIDE_POST_DIALOG
    return;
#endif
    
    [self passSelectedItemsToApp];
    
    // Note: This call is expected to be made here. Ignore it. We'll tell the host we are done after we've invoked the app.
    //    [ self.extensionContext completeRequestReturningItems: @[] completionHandler: nil ];
}

#ifdef HIDE_POST_DIALOG
- (NSArray *) configurationItems {
    // Comment out this whole function if you want the Post dialog to show.
    [self passSelectedItemsToApp];
    
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}
#endif

#ifdef HIDE_POST_DIALOG
- (id) init {
    if (self = [ super init ]) {
        // Subscribe to the notification which will tell us when the keyboard is about to pop up:
        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( keyboardWillShow: )
                                                        name: UIKeyboardWillShowNotification
                                                      object: nil ];
    }
    
    return self;
}
#endif

#ifdef HIDE_POST_DIALOG
- (void) keyboardWillShow: (NSNotification *) note {
    // Dismiss the keyboard before it has had a chance to show up:
    [ self.view endEditing: true ];
}
#endif

#ifdef HIDE_POST_DIALOG
- (void) willMoveToParentViewController: (UIViewController *) parent {
    // This is called at the point where the Post dialog is about to be shown.
    // Make it transparent, so we don't see it, but first remember how transparent it was originally:
    
    m_oldAlpha = [ self.view alpha ];
    [ self.view setAlpha: 0.0 ];
}
#endif

#ifdef HIDE_POST_DIALOG
- (void) didMoveToParentViewController: (UIViewController *) parent {
    // Restore the original transparency:
    [ self.view setAlpha: m_oldAlpha ];
}
#endif

- (void) passSelectedItemsToApp {
    NSExtensionItem * firstItem = (NSExtensionItem*) self.extensionContext.inputItems.firstObject;
    
    // Reset the counter and the argument list for invoking the app:
    m_invokeArgs = nil;
    m_inputItemCount = firstItem.attachments.count;
    
    // Iterate through the attached files
    for (NSItemProvider * itemProvider in firstItem.attachments ) {
        // Check if we are sharing an image
        if([itemProvider hasItemConformingToTypeIdentifier:@"public.image"]) {
            // Load it, so we can get the path to it
            [itemProvider loadItemForTypeIdentifier:@"public.image"
                                            options:nil
                                  completionHandler: ^(id<NSSecureCoding> item, NSError * error)
             {
                 static int itemIdx = 0;
                 if (nil != error) {
                     NSLog( @"There was an error retrieving the attachments: %@", error );
                     return;
                 }
                 
                 UIImage *sharedImage = nil;
                 if([(NSObject *) item isKindOfClass:[NSURL class]]) {
                     sharedImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:(NSURL *) item]];
                 }
                 
                 if([(NSObject *) item isKindOfClass:[UIImage class]]) {
                     sharedImage = (UIImage*)item;
                 }
                 
                 if (nil == sharedImage) {
                     NSLog( @"There was an error retrieving the attachments: %@", error );
                     return;
                 }
                 
                 // The app won't be able to access the images by path directly in the Camera Roll folder,
                 // so we temporary copy them to a folder which both the extension and the app can access:
                 NSString * filePath = [self saveImageToAppGroupFolder: sharedImage
                                                            imageIndex: itemIdx];
                 
                 // Now add the path to the list of arguments we'll pass to the app:
                 [self addImagePathToArgumentList: filePath];
                 
                 // If we have reached the last attachment, it's time to hand control to the app:
                 
                 if (++itemIdx >= m_inputItemCount) {
                     [self invokeApp: m_invokeArgs];
                 }
             }];
        }
    }
}

- (void) addImagePathToArgumentList: (NSString *) imagePath {
    assert(nil != imagePath);
    
    // The list of arguments we will pass to the AIR app when we invoke it.
    // It will be a comma-separated list of file paths: /path/to/image1.jpg,/path/to/image2.jpg
    if (nil == m_invokeArgs) {
        m_invokeArgs = imagePath;
    }
    else {
        m_invokeArgs = [ NSString stringWithFormat: @"%@,%@", m_invokeArgs, imagePath ];
    }
}

- (NSString *) saveImageToAppGroupFolder: (UIImage *) image
                              imageIndex: (int) imageIndex {
    assert(nil != image);
    
    NSData * jpegData = UIImageJPEGRepresentation( image, 1.0 );
    NSURL * containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier: APP_SHARE_GROUP ];
    NSString * documentsPath = containerURL.path;
    // Note that we aren't using massively unique names for the files in this example:
    NSString * fileName = [ NSString stringWithFormat: @"image%d.jpg", imageIndex ];
    NSString * filePath = [ documentsPath stringByAppendingPathComponent: fileName ];
    [ jpegData writeToFile: filePath
                atomically: true ];
    return filePath;
}

- ( void ) invokeApp: ( NSString * ) invokeArgs {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.3")) {
        // Prepare the URL request
        // this will use the custom url scheme of your app
        // and the paths to the photos you want to share:
        NSString * urlString = [ NSString stringWithFormat: @"%@://%@", APP_SHARE_URL_SCHEME, ( NULL == invokeArgs ? @"" : invokeArgs ) ];
        NSURL * url = [ NSURL URLWithString: urlString ];
        
        NSString *className = @"UIApplication";
        if ( NSClassFromString( className ) ) {
            id object = [ NSClassFromString( className ) performSelector: @selector( sharedApplication ) ];
            [ object performSelector: @selector( openURL: ) withObject: url ];
        }
        
        // Now let the host app know we are done, so that it unblocks its UI:
        [ super didSelectPost ];
    }
    else { // for lower than 8.3 ios versions 
        dispatch_async ( dispatch_get_main_queue(),
                        ^{
                            // openURL doesn't work for any extension, but the Today one,
                            // so we'll use a workaround:
                            // 1. Instantiate a UIWebView that's so tiny it won't show on the screen:
                            UIWebView * webView = [ [ UIWebView alloc ] initWithFrame: CGRectMake( 0, 0, 0, 0 ) ];
                            
                            // 2. Prepare the URL request for the UIWebView:
                            // this will use the custom url scheme of your app
                            // and the paths to the photos you want to share:
                            NSString * urlString = [ NSString stringWithFormat: @"%@://%@", APP_SHARE_URL_SCHEME, ( NULL == invokeArgs ? @"" : invokeArgs ) ];
                            NSURL * url = [ NSURL URLWithString: urlString ];
                            NSURLRequest * request = [ NSURLRequest requestWithURL: url ];
                            
                            // 3. Now get the UIWebView to load the request, which will launch the app:
                            [ webView loadRequest: request ];
                            [ self.view addSubview: webView ];
                            
                            // 4. And finally, say bye to the UIWebView.
                            // The delay is important here, otherwise the UIWebView won't have time
                            // to invoke your app before it's dismissed:
                            [ webView performSelector: @selector( removeFromSuperview ) withObject: NULL afterDelay: 2.0 ];
                            
                            // Now let the host app know we are done, so that it unblocks its UI:
                            [ super didSelectPost ];
                        });
    }
    
   
}
@end
