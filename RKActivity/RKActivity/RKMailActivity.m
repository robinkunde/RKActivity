//
//  RKMailActivity.m
//  RKActivity
//
//  Created by Robin Kunde on 3/25/13.
//  Copyright (c) 2013 Robin Kunde. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "RKMailActivity.h"
#import "RKActivityPrivate.h"
#import "RKActivityViewController.h"

@implementation RKMailActivity

- (id)init
{
    self = [super initWithTitle:RKALocalizedString(@"activity.Mail.title")
                          image:[UIImage imageNamed:@"RKActivityResources.bundle/icon_mail"]
            ];

    return self;
}

- (void)_performActivityWithUserInfo:(NSDictionary *)userInfo andViewController:(RKActivityViewController *)viewController
{
    NSString *subject = [userInfo objectForKey:@"subject"];
    NSString *text    = [userInfo objectForKey:@"text"];
    UIImage  *image   = [userInfo objectForKey:@"image"];
    NSURL    *url     = [userInfo objectForKey:@"url"];

    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = viewController;

    [mailComposeViewController setMessageBody:[NSString stringWithFormat:@"%@%@%@", text, (text && url) ? @" " : @"", url.absoluteString] isHTML:NO];

    if (image)
        [mailComposeViewController addAttachmentData:UIImageJPEGRepresentation(image, 0.8f) mimeType:@"image/jpeg" fileName:@"photo.jpg"];

    if (subject)
        [mailComposeViewController setSubject:subject];

    mailComposeViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [viewController presentViewController:mailComposeViewController animated:YES completion:nil];

    [viewController hide];
}

@end
