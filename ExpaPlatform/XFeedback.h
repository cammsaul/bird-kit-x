//
//  Feedback.h
//  ExpaPlatform
//
//  Created by Ram Ravichandran on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@protocol XFeedbackDelegate <NSObject>
@optional
/// Optional method a delegate of XFeedback
- (NSString *)feedbackNotesForNewTask;
@end

/// ID of the Asana workspace for XFeedback to create new tickets in.
static NSString * const XFeedbackOptionsAsanaWorkspaceID	= @"workspace";

/// ID of the Asana user for XFeedback to assign new tickets to.
static NSString * const XFeedbackOptionsAsanaAssigneeID		= @"assignee";

/// ID (NSString) or IDs (NSArray of NSString) of Asana Users IDs to be set as followers of tasks created via XFeedback.
static NSString * const XFeedbackOptionsAsanaFollowerIDs	= @"followers";

/// Asana project ID to create new tickets under. Can be either a single ID (NSString) or an NSArray of IDs.
static NSString * const XFeedbackOptionsAsanaProjectIDs		= @"projects";

/// Status of newly created AsanaTickets, if XFeedbackAsanaOptionsAssigneeID is set. Default is XFeedbackAsanaAssigneeStatusInbox
/// \seealso Asana API documentation at http://developer.asana.com/documentation/#tasks
static NSString * const XFeedbackOptionsAsanaAssigneeStatus = @"assignee_status";
/// Newly created Asana tasks go to Assignee's inbox
static NSString * const XFeedbackOptionsAsanaAssigneeStatusInbox = @"inbox";
/// Newly created Asana tasks go to "Later"
static NSString * const XFeedbackOptionsAsanaAssigneeStatusLater = @"later";
/// Newly created Asana tasks go to "Today"
static NSString * const XFeedbackOptionsAsanaAssigneeStatusToday = @"today";
/// Newly created Asana tasks go to "Upcoming"
static NSString * const XFeedbackOptionsAsanaAssigneeStatusUpcoming = @"upcoming";
/// Specify this parameter to set the XFeedbackDelegate, which is weakly retained by XFeedback itself.
static NSString * const XFeedbackOptionsDelegate = @"[delegate]";

@interface XFeedback : NSObject <MFMailComposeViewControllerDelegate>

/// Registers Asana API key and optional IDs for use with XFeedback (feedback mechanism when showing taking a screenshot)
/// \param apiKey Asana API Key.
/// \param xFeedbackOptions Dictionary of options keyed by an XFeedbackOptions string.
+ (void)registerAsanaAPIKey:(NSString *)apiKey options:(NSDictionary *)xFeedbackOptions;

/// Post a new Asana ticket with image and message using the configuration settings from registerAsanaAPIKey:options:
+ (void)postBugReportWithImage:(UIImage*)image message:(NSString*)message;

@end
