//
//  RKActivityViewController.m
//  RKActivity
//
//  Created by Robin Kunde on 3/12/13.
//  Copyright (c) 2013 Robin Kunde. All rights reserved.
//

#import "RKActivityViewController.h"
#import "RKActivityView.h"
#import "RKActivity.h"

@interface RKActivityViewController ()
@property (strong, nonatomic) RKActivityViewController *instance;
@property (strong, nonatomic) NSArray *activities;
@property (strong, nonatomic) UIActionSheet *as;

@end

@implementation RKActivityViewController

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (id)initWithActivities:(NSArray *)activities
{
    self = [super init];
    if (self)
    {
        _activities = activities;
    }
    return self;
}

#pragma mark - Control methods

- (void)presentOverlay
{
    // retain self since controller will not be presented
    _instance = self;
    [(RKActivityView *)[self view] showAsOverlay];
}

- (void)dismiss
{
    if (!_willPresentInPopover)
        [(RKActivityView *)[self view] dismiss];

    _instance = nil;
}

- (void)show
{
    if (!_willPresentInPopover)
        [(RKActivityView *)[self view] show];
}

- (void)hide
{
    if (!_willPresentInPopover)
        [(RKActivityView *)[self view] hide];
}

#pragma mark - Controller lifecycle methods

- (void)loadView
{
    RKActivityView *view = [[RKActivityView alloc] initWithActivities:_activities viewController:self];
    if (_willPresentInPopover)
        [view layoutForPopover];
    [self setView:view];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    if (_willPresentInPopover)
        _instance = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [UIView animateWithDuration:0.1
                          delay:0
                        options:0
                     animations:^{
                         [self view].frame = [UIScreen mainScreen].bounds;
                     }
                     completion:nil];
}

#pragma mark - View delegate methods

- (void)buttonPressed:(UIButton *)button
{
    RKActivity *activity = [_activities objectAtIndex:button.tag];
    [activity performActivityWithUserInfo:_userInfo andViewController:self];
}

#pragma mark - MFMessageComposeViewControllerDelegate methods

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^(void) {
        [weakSelf dismiss];
    }];
}

#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^(void) {
        [weakSelf dismiss];
    }];
}

#pragma mark - Other

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
