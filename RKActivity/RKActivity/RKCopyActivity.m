//
//  RKCopyActivity.m
//  RKActivity
//
//  Created by Robin Kunde on 3/25/13.
//  Copyright (c) 2013 Robin Kunde. All rights reserved.
//

#import "RKCopyActivity.h"
#import "RKActivityPrivate.h"
#import "RKActivityViewController.h"

@implementation RKCopyActivity

- (id)init
{
    self = [super initWithTitle:RKALocalizedString(@"activity.Copy.title")
                          image:[UIImage imageNamed:@"RKActivityResources.bundle/icon_copy"]
            ];

    return self;
}

- (void)_performActivityWithUserInfo:(NSDictionary *)userInfo andViewController:(RKActivityViewController *)viewController
{
    NSString *text  = [userInfo objectForKey:@"text"];
    UIImage  *image = [userInfo objectForKey:@"image"];
    NSURL    *url   = [userInfo objectForKey:@"url"];

    if (text)
        [UIPasteboard generalPasteboard].string = text;
    if (url)
        [UIPasteboard generalPasteboard].URL = url;
    if (image)
        [[UIPasteboard generalPasteboard] setData:UIImagePNGRepresentation(image)
                                forPasteboardType:[UIPasteboardTypeListImage objectAtIndex:0]];

    [viewController dismiss];
}

@end
