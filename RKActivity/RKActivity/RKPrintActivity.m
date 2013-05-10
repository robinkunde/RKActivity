//
//  RKPrintActivity.m
//  RKActivity
//
//  Created by Robin Kunde on 3/25/13.
//  Copyright (c) 2013 Robin Kunde. All rights reserved.
//

#import "RKPrintActivity.h"
#import "RKActivityPrivate.h"
#import "RKActivityViewController.h"

@implementation RKPrintActivity

- (id)init
{
    self = [super initWithTitle:RKALocalizedString(@"activity.Print.title")
                          image:[UIImage imageNamed:@"RKActivityResources.bundle/icon_print"]
            ];

    return self;
}

- (void)_performActivityWithUserInfo:(NSDictionary *)userInfo andViewController:(RKActivityViewController *)viewController
{
    UIPrintInteractionController *pc = [UIPrintInteractionController sharedPrintController];

    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = [userInfo objectForKey:@"text"];
    pc.printInfo = printInfo;

    pc.printingItem = [userInfo objectForKey:@"image"];

    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error)
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:RKALocalizedString(@"activity.Print.error.title")
                                                         message:[NSString stringWithFormat:RKALocalizedString(@"activity.Print.error.message"), error.localizedDescription]
                                                        delegate:nil
                                               cancelButtonTitle:RKALocalizedString(@"button.ok")
                                               otherButtonTitles:nil];

            [av show];
        }
    };

    [pc presentAnimated:YES completionHandler:completionHandler];

    [viewController dismiss];
}

@end
