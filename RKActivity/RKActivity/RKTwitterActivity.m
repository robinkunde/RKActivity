//
//  RKTwitterActivity.m
//  RKActivity
//
//  Created by Robin Kunde on 3/21/13.
//  Copyright (c) 2013 Robin Kunde. All rights reserved.
//

#import "RKTwitterActivity.h"
#import "RKActivityPrivate.h"
#import "RKActivityViewController.h"
#import <Social/Social.h>

@implementation RKTwitterActivity

- (id)init
{
    self = [super initWithTitle:RKALocalizedString(@"activity.Twitter.title")
                          image:[UIImage imageNamed:@"RKActivityResources.bundle/icon_twitter"]
            ];

    return self;
}

- (void)_performActivityWithUserInfo:(NSDictionary *)userInfo andViewController:(RKActivityViewController *)viewController
{
    NSString *text  = [userInfo objectForKey:@"text"];
    UIImage  *image = [userInfo objectForKey:@"image"];
    NSURL    *url   = [userInfo objectForKey:@"url"];

    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *twitterController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitterController setInitialText:text];
        [twitterController addURL:url];
        [twitterController addImage:image];
        [twitterController setCompletionHandler:^(SLComposeViewControllerResult result) {
            [viewController dismiss];
        }];

        [viewController hide];
        [viewController presentViewController:twitterController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *noAccount = [[UIAlertView alloc] initWithTitle:RKALocalizedString(@"activity.Twitter.unconfigured.title")
                                                            message:RKALocalizedString(@"activity.Twitter.unconfigured.message")
                                                           delegate:nil
                                                  cancelButtonTitle:RKALocalizedString(@"button.ok")
                                                  otherButtonTitles:nil];

        [noAccount show];
    }
}

@end
