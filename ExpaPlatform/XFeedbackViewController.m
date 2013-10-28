//
//  XFeedbackViewController.m
//  ExpaPlatform
//
//  Created by Ram Ravichandran on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

#import "XFeedbackViewController.h"
#import "XFeedback.h"
#import "MPTextView.h"

@interface XFeedbackViewController ()

@property (strong, nonatomic) MPTextView *textView;
@property (strong, nonatomic) UIImageView *screenshotView;
@property (strong, nonatomic) IBOutlet UILabel *postLabel;
@property (strong, nonatomic) IBOutlet UILabel *cancelLabel;
@end

@implementation XFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     //   *XFeedbackApplicationId = @"APPID";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 45)];
    
    _postLabel = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 50, 10, 40, 20)];
    [_postLabel setUserInteractionEnabled:YES];
    [_postLabel setText:@"Post"];
    [_postLabel setTextColor:[UIColor greenColor]];
    [_postLabel setFont:[UIFont systemFontOfSize:16]];
    [statusView addSubview:_postLabel];
    
    _cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 60, 20)];
    [_cancelLabel setText:@"Cancel"];
    [_cancelLabel setTextColor:[UIColor grayColor]];
    [_cancelLabel setFont:[UIFont systemFontOfSize:16]];
    [_cancelLabel setUserInteractionEnabled:YES];
    [statusView addSubview:_cancelLabel];
    
    [_postLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(postWindow:)]];
    [_cancelLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(closeWindow:)]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/ 2 -40, 10, 100, 20)];
    [headerLabel setText:@"Feedback"];
    [headerLabel setTextColor:[UIColor blackColor]];
    [headerLabel setFont:[UIFont systemFontOfSize:16]];
    [statusView addSubview:headerLabel];
    [self.view addSubview:statusView];
    
    // Add textview
    CGFloat textViewWidth = ([[UIScreen mainScreen] bounds].size.width)/2;
    CGFloat textViewHeight = [[UIScreen mainScreen] bounds].size.height/2;

    _textView = [[MPTextView alloc] initWithFrame:CGRectMake(textViewWidth, 65, textViewWidth, textViewHeight)];
    [_textView setBackgroundColor:[UIColor clearColor]];
    [_textView setTextColor:[UIColor blackColor]];
    [_textView setContentInset:UIEdgeInsetsMake(30.0, 0, 0, 0)];
    [_textView setPlaceholderText:@"Enter feedback..."];
    [self.view addSubview:_textView];
    [_textView becomeFirstResponder];
    
    _screenshotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, textViewWidth, textViewHeight)];
    [_screenshotView setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0]];
    [_screenshotView setUserInteractionEnabled:NO];
    [_screenshotView setImage:self.feedbackImage];
    [self.view addSubview:_screenshotView];
    // Do any additional setup after loading the view from its nib.
}

- (void)postWindow:(id)sender
{
    [XFeedback postBugReportWithImage:self.feedbackImage message:[_textView text]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)closeWindow:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
