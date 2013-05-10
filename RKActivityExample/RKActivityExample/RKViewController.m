//
//  RKViewController.m
//  RKActivityExample
//
//  Created by Robin Kunde on 5/1/13.
//  Copyright (c) 2013 Recoursive.com. All rights reserved.
//

#import "RKViewController.h"
#import "RKActivities.h"
#import "RKActivityViewController.h"

@interface RKViewController ()
@property (strong, nonatomic) UIPopoverController *activityPopoverController;
@end

@implementation RKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showRKActivity:(id)sender
{
    if (_activityPopoverController.isPopoverVisible)
    {
        [_activityPopoverController dismissPopoverAnimated:YES];
        _activityPopoverController = nil;
        return;
    }

    RKFacebookActivity *facebookActivity = [[RKFacebookActivity alloc] init];
    RKTwitterActivity *twitterActivity   = [[RKTwitterActivity alloc] init];
    RKMessageActivity *messageActivity   = [[RKMessageActivity alloc] init];
    RKMailActivity *mailActivity         = [[RKMailActivity alloc] init];
    RKSafariActivity *safariActivity     = [[RKSafariActivity alloc] init];
    RKCopyActivity *copyActivity         = [[RKCopyActivity alloc] init];
    RKPrintActivity *printActivity       = [[RKPrintActivity alloc] init];

    NSArray *activities = @[facebookActivity, twitterActivity, mailActivity, messageActivity, safariActivity, copyActivity, printActivity];

    RKActivityViewController *avc = [[RKActivityViewController alloc] initWithActivities:activities];
    [avc setUserInfo:@{
     @"text":    @"Example Text",
     @"subject": @"Example Subject",
     @"url":     [NSURL URLWithString:@"http://example.com"],
     }];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [avc setWillPresentInPopover:YES];
        _activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:avc];
        [_activityPopoverController presentPopoverFromBarButtonItem:sender
                                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                                           animated:YES];
    }
    else
    {
        [avc presentOverlay];
    }
}

- (void)showUIActivity:(id)sender
{
    if (_activityPopoverController.isPopoverVisible) {
        [_activityPopoverController dismissPopoverAnimated:YES];
        _activityPopoverController = nil;
        return;
    }

    UIActivityViewController *uiActivityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[
                                                          @"Example Text",
                                                          @"Example Subject",
                                                          [NSURL URLWithString:@"http://example.com"],
                                                          [UIImage imageNamed:@"RKActivityResources.bundle/Background"],
                                                          ] applicationActivities:nil];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        _activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:uiActivityViewController];
        [_activityPopoverController presentPopoverFromBarButtonItem:sender
                                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                                           animated:YES];
    }
    else
    {
        [self presentViewController:uiActivityViewController animated:YES completion:nil];
    }
}

#pragma mark - UIPopoverControllerDelegate methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    _activityPopoverController = nil;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
