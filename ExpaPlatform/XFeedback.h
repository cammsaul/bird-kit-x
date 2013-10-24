//
//  Feedback.h
//  ExpaPlatform
//
//  Created by Ram Ravichandran on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface XFeedback : NSObject <MFMailComposeViewControllerDelegate>

+ (void)registerAsanaAPIKey:(NSString *)appID;

@end
