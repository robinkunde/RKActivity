//
//  RKFacebookActivity.m
//  RKActivity
//
//  Created by Robin Kunde on 3/19/13.
//  Copyright (c) 2013 Robin Kunde. All rights reserved.
//

#import "RKFacebookActivity.h"
#import "RKActivityPrivate.h"
#import "RKActivityViewController.h"
#import <Social/Social.h>

@implementation RKFacebookActivity

- (id)init
{
    self = [super initWithTitle:RKALocalizedString(@"activity.Facebook.title")
                          image:[UIImage imageNamed:@"RKActivityResources.bundle/icon_facebook"]
            ];

    return self;
}

- (void)_performActivityWithUserInfo:(NSDictionary *)userInfo andViewController:(RKActivityViewController *)viewController
{
    NSString *text  = [userInfo objectForKey:@"text"];
    UIImage  *image = [userInfo objectForKey:@"image"];
    NSURL    *url   = [userInfo objectForKey:@"url"];

    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *facebookController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookController setInitialText:text];
        [facebookController addURL:url];
        [facebookController addImage:image];
        [facebookController setCompletionHandler:^(SLComposeViewControllerResult result) {
            [viewController dismiss];
        }];

        [viewController hide];
        [viewController presentViewController:facebookController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *noAccount = [[UIAlertView alloc] initWithTitle:RKALocalizedString(@"activity.Facebook.unconfigured.title")
                                                            message:RKALocalizedString(@"activity.Facebook.unconfigured.message")
                                                           delegate:nil
                                                  cancelButtonTitle:RKALocalizedString(@"button.ok")
                                                  otherButtonTitles:nil];
        [noAccount show];
    }
}

@end
