//
//  Feedback.m
//  ExpaPlatform
//
//  Created by Ram Ravichandran on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

#import "XFeedback.h"

static NSString *__AsanaAPIKey;

@implementation XFeedback

+ (id)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)registerAsanaAPIKey:(NSString *)appID {
    __AsanaAPIKey = appID;
    
    [[NSNotificationCenter defaultCenter] addObserver:[self sharedInstance]
                                             selector:@selector(screenshotTaken)
                                                 name:UIApplicationUserDidTakeScreenshotNotification
                                               object:nil];
}


- (void)screenshotTaken
{
   UIViewController *rootVC = [[[UIApplication sharedApplication] delegate] window].rootViewController;

    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context, -[window bounds].size.width * [[window layer] anchorPoint].x, -[window bounds].size.height * [[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            CGContextRestoreGState(context);
        }
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"Feedback for Beta 1"];
        [mailViewController setToRecipients:@[@"feedback@geotip.com"]];
        [mailViewController addAttachmentData:imageData mimeType:@"image/png" fileName:@"feedback.png"];
        [rootVC presentViewController:mailViewController animated:YES completion:nil];
        
    }
    
    else {
        //Allow the user to decide what to do with the image, via UIActivityViewController
        //instead of forcibly save it to disk.
        UIActivityViewController *activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:@[ imageData ]
                                          applicationActivities:nil];
        
        [rootVC presentViewController:activityViewController
                                                     animated:YES
                                                   completion:nil];
        
    }

}

+ (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[controller dismissViewControllerAnimated:YES completion:nil];
}

@end
