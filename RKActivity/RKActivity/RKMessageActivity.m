//
//  RKMessageActivity.m
//  RKActivity
//
//  Created by Robin Kunde on 3/25/13.
//  Copyright (c) 2013 Robin Kunde. All rights reserved.
//

#import "RKMessageActivity.h"
#import "RKActivityPrivate.h"
#import "RKActivityViewController.h"

@implementation RKMessageActivity

- (id)init
{
    self = [super initWithTitle:RKALocalizedString(@"activity.Message.title")
                          image:[UIImage imageNamed:@"RKActivityResources.bundle/icon_message"]
            ];

    return self;
}

- (void)_performActivityWithUserInfo:(NSDictionary *)userInfo andViewController:(RKActivityViewController *)viewController
{
    NSString *text = [userInfo objectForKey:@"text"];
    NSURL    *url  = [userInfo objectForKey:@"url"];

    MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
    messageComposeViewController.messageComposeDelegate = viewController;

    messageComposeViewController.body = [NSString stringWithFormat:@"%@%@%@", text, (text && url) ? @" " : @"" , url.absoluteString];

    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [viewController presentViewController:messageComposeViewController animated:YES completion:nil];

    [viewController hide];
}

@end
