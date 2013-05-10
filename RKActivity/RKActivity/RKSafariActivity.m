//
//  RKSafariActivity.m
//  RKActivity
//
//  Created by Robin Kunde on 3/25/13.
//  Copyright (c) 2013 Robin Kunde. All rights reserved.
//

#import "RKSafariActivity.h"
#import "RKActivityPrivate.h"
#import "RKActivityViewController.h"

@implementation RKSafariActivity

- (id)init
{
    self = [super initWithTitle:RKALocalizedString(@"activity.Safari.title")
                          image:[UIImage imageNamed:@"RKActivityResources.bundle/icon_safari"]
            ];

    return self;
}

- (void)_performActivityWithUserInfo:(NSDictionary *)userInfo andViewController:(RKActivityViewController *)viewController
{
    if ([[userInfo objectForKey:@"url"] isKindOfClass:[NSURL class]])
        [[UIApplication sharedApplication] openURL:[userInfo objectForKey:@"url"]];

    [viewController dismiss];
}

@end
