//
//  Feedback.h
//  ExpaPlatform
//
//  Created by Ram Ravichandran on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

@import Foundation;
@import MessageUI;

@interface XFeedback : NSObject <MFMailComposeViewControllerDelegate>

+ (void)registerAsanaAPIKey:(NSString *)appID workspaceID:(NSString*)workspaceID;
+ (void)postBugReportWithImage:(UIImage*)image message:(NSString*)message;

@end
