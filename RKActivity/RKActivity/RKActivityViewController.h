//
//  RKActivityViewController.h
//  RKActivity
//
//  Created by Robin Kunde on 3/12/13.
//  Copyright (c) 2013 Robin Kunde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface RKActivityViewController : UIViewController <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic) BOOL willPresentInPopover;
@property (strong, nonatomic) NSDictionary *userInfo;

- (id)initWithActivities:(NSArray *)activities;
- (void)presentOverlay;
- (void)dismiss;
- (void)show;
- (void)hide;
@end
