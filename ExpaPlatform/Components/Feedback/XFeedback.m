//
//  Feedback.m
//  ExpaPlatform
//
//  Created by Ram Ravichandran on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

#import "XFeedback.h"
#import "NSString+XURLEncoding.h"
#import "XFeedbackViewController.h"

static NSString *__AsanaAPIKey;
static NSString *__AsanaWorkspaceID;

static NSString * XBase64EncodedStringFromString(NSString *string) {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

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

+ (void)registerAsanaAPIKey:(NSString *)appID workspaceID:(NSString*)workspaceID{
    __AsanaAPIKey = appID;
    __AsanaWorkspaceID = workspaceID;
    
    [[NSNotificationCenter defaultCenter] addObserver:[self sharedInstance]
                                             selector:@selector(screenshotTaken)
                                                 name:UIApplicationUserDidTakeScreenshotNotification
                                               object:nil];
}

- (void)callMailAsFallback:(UIImage*)image
{
    UIViewController *rootVC = [[[UIApplication sharedApplication] delegate] window].rootViewController;
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

+ (void)postBugReportWithImage:(UIImage*)image message:(NSString*)message
{
    [[self sharedInstance] postBugReportWithImage:image message:message];
}

- (void)postBugReportWithImage:(UIImage*)image message:(NSString*)message
{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://app.asana.com/api/1.0/tasks"]];
    NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:", __AsanaAPIKey];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", XBase64EncodedStringFromString(basicAuthCredentials)];
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSString *name = [NSString stringWithFormat:@"name=%@",
                      [@"New Bug Report" urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *msg = [NSString stringWithFormat:@"notes=%@",
                     [message urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *myParameters = [NSString stringWithFormat:@"%@&%@&workspace=%@",name,msg,__AsanaWorkspaceID];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error) {
                                   [self callMailAsFallback:image];
                                   return;
                               }
                               
                               NSError *jerror = nil;
                               NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jerror];
                               if (!jerror) {
                                   NSData *imageData = UIImagePNGRepresentation(image);
                                   NSNumber *taskId = jsonArray[@"data"][@"id"];
                                   NSString *url = [NSString stringWithFormat:@"https://app.asana.com/api/1.0/tasks/%@/attachments",taskId];
                                   NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
                                   NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:", __AsanaAPIKey];
                                   NSString *authValue = [NSString stringWithFormat:@"Basic %@", XBase64EncodedStringFromString(basicAuthCredentials)];
                                   [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
                                   
                                   [urlRequest setHTTPMethod:@"POST"];
                                   
                                   NSString *boundary = @"dfggfsdiigiigigigue22223";
                                   
                                   NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
                                   [urlRequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
                                   
                                   // post body
                                   NSMutableData *body = [NSMutableData data];
                                   
                                   // add params (all params are strings)
                                       [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                                       [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"files"] dataUsingEncoding:NSUTF8StringEncoding]];
                                       [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"kkk.png"] dataUsingEncoding:NSUTF8StringEncoding]];

                                   
                                   // add image data
                                   if (imageData) {
                                       [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                                       [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"file"] dataUsingEncoding:NSUTF8StringEncoding]];
                                       [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                                       [body appendData:imageData];
                                       [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                                   }
                                   
                                   [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];


                                   [urlRequest setHTTPBody:body];
                                   
                                   [NSURLConnection sendAsynchronousRequest:urlRequest
                                                                      queue:[NSOperationQueue mainQueue]
                                    completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                                    }];
                                    
                               }
                                                              
                           }];
}


- (void)screenshotTaken
{


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
    
    XFeedbackViewController *xFeedbackVC = [[XFeedbackViewController alloc] init];
    [xFeedbackVC setFeedbackImage:image];
    UIViewController *rootVC = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    [rootVC presentViewController:xFeedbackVC animated:YES completion:nil];
    
   
    
  
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[controller dismissViewControllerAnimated:YES completion:nil];
}

@end
