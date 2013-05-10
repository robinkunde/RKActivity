//
//  RKActivityView.m
//  RKActivity
//
//  Created by Robin Kunde on 3/13/13.
//  Copyright (c) 2013 Robin Kunde. All rights reserved.
//

#import "RKActivityView.h"
#import "RKActivity.h"

@interface RKActivityView () <UIScrollViewDelegate>
@property (strong, nonatomic) UIWindow      *overlayWindow;
@property (strong, nonatomic) UIView        *overlayView;
@property (strong, nonatomic) UIView        *activityView;
@property (strong, nonatomic) UIScrollView  *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIButton      *cancelButton;
@property (strong, nonatomic) UIImageView   *backgroundImageView;
@end

@implementation RKActivityView

@synthesize overlayWindow=_overlayWindow;
const int activityMinMarginTop = 15;
const int activityPaddingTop = 20;
const int activityPaddingMinBottom = 5;
const int activityPaddingMaxBottom = 15;
const int activityPaddingSide = 20;
const int buttonWidth = 80;
const int buttonHeight = 90;
const int buttonHorizontalDistance = 20;
const int buttonVerticalDistance = 10;
const int pagingMarginTop = 15;
const int pagingHeight = 20;
const int cancelMarginTop = 15;

- (id)initWithActivities:(NSArray *)activities viewController:(RKActivityViewController *)viewController
{

    self = [super init];
    if (self)
    {
        _viewController = viewController;

        [self setFrame:[UIScreen mainScreen].bounds];
        [self setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];

        // background overlay view
        _overlayView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _overlayView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _overlayView.backgroundColor = [UIColor blackColor];
        _overlayView.alpha = 0;
        [self addSubview:_overlayView];

        _activityView = [[UIView alloc] init];

        _backgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"RKActivityResources.bundle/background"] resizableImageWithCapInsets:UIEdgeInsetsMake(43, 0, 0, 0)]];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_activityView addSubview:_backgroundImageView];

        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        [_activityView addSubview:_scrollView];

        int index = 0;
        for (RKActivity *activity in activities)
        {
            UIView *view = [self viewForActivity:activity index:index];
            [_scrollView addSubview:view];
            index++;
        }

        _pageControl = [[UIPageControl alloc] init];
        [_pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_activityView addSubview:_pageControl];


        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:[[UIImage imageNamed:@"RKActivityResources.bundle/button"]
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(46, 13, 0, 13)] forState:UIControlStateNormal];
        _cancelButton.frame = CGRectMake(0, 0, 276, 46);

        [_cancelButton setTitle:RKALocalizedString(@"button.cancel") forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setTitleShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] forState:UIControlStateNormal];
        _cancelButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
        _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
        [_cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_activityView addSubview:_cancelButton];

        [self addSubview:_activityView];

        [self updateOverlayLayoutForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    }

    return self;
}

- (UIView *)viewForActivity:(RKActivity *)activity index:(NSInteger)index
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 0, 59, 59);
    button.tag = index;
    button.accessibilityLabel = activity.title;
    [button setBackgroundImage:activity.image forState:UIControlStateNormal];
    [button addTarget:_viewController action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, buttonWidth, buttonHeight - 59)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    label.shadowOffset = CGSizeMake(0, 1);
    label.text = activity.title;
    label.font = [UIFont boldSystemFontOfSize:12];
    label.numberOfLines = 0;
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.origin.x = round((view.frame.size.width - frame.size.width) / 2.0f);
    label.frame = frame;
    [view addSubview:label];

    return view;
}

- (void)showAsOverlay
{
    if (![self superview])
        [[self overlayWindow] addSubview:self];

    [[self overlayWindow] setHidden:NO];

    if ([_overlayView alpha] != 0.5)
    {
        [self subscribeToNotifications];
        [self show];
    }
}

- (void)show
{
    CGRect frame = _activityView.frame;
    frame.origin.y = self.frame.size.height;
    _activityView.frame = frame;

    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [_overlayView setAlpha:0.5];

                         CGRect frame = _activityView.frame;
                         frame.origin.y = self.frame.size.height - frame.size.height;
                         _activityView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, @"Activity Menu");
                     }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [_overlayView setAlpha:0];

                         CGRect frame = _activityView.frame;
                         frame.origin.y = self.frame.size.height;
                         _activityView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         [[NSNotificationCenter defaultCenter] removeObserver:self];

                         [_overlayWindow removeFromSuperview];
                         _overlayWindow = nil;

                         // fixes bug where keyboard wouldn't return as keyWindow upon dismissal of HUD
                         // TODO: examine if this is still necessary
                         [[UIApplication sharedApplication].windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id window, NSUInteger idx, BOOL *stop) {
                             if ([window isMemberOfClass:[UIWindow class]])
                             {
                                 [window makeKeyWindow];
                                 *stop = YES;
                             }
                         }];

                         UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
                     }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [_overlayView setAlpha:0];

                         CGRect frame = _activityView.frame;
                         frame.origin.y = self.frame.size.height;
                         _activityView.frame = frame;
                     }
                     completion:nil];
}

- (void)subscribeToNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarWillChangeOrientation:)
                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
                                               object:nil];
}

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation
{
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return CGAffineTransformMakeRotation(-M_PI_2);

        case UIInterfaceOrientationLandscapeRight:
            return CGAffineTransformMakeRotation(M_PI_2);

        case UIInterfaceOrientationPortraitUpsideDown:
            return CGAffineTransformMakeRotation(M_PI);

        case UIInterfaceOrientationPortrait:
        default:
            return CGAffineTransformMakeRotation(0.0);
    }
}

- (void)layoutForPopover
{
    self.backgroundColor = [UIColor blackColor];

    _overlayView.hidden = YES;
    _cancelButton.hidden = YES;
    _backgroundImageView.hidden = YES;
    
    [self updateLayoutForSize:CGSizeMake(320, activityPaddingTop + 3 * buttonHeight + 2 * buttonVerticalDistance + pagingMarginTop + pagingHeight + activityPaddingMaxBottom) showCancel:NO updatePosition:NO];

    _viewController.contentSizeForViewInPopover = _activityView.frame.size;
}

- (void)updateOverlayLayoutForOrientation:(UIInterfaceOrientation)orientation
{
    self.backgroundColor = [UIColor clearColor];

    _overlayView.hidden         = NO;
    _cancelButton.hidden        = NO;
    _backgroundImageView.hidden = NO;

    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect rotatedFrame;
    CGPoint center;
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        rotatedFrame = screenBounds;
        center = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height / 2);
    }
    else
    {
        rotatedFrame = CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
        center = CGPointMake(rotatedFrame.size.height / 2, rotatedFrame.size.width / 2);
    }

    UIWindow *overlayWindow = [self overlayWindow];
    [overlayWindow setBounds:rotatedFrame];
    [overlayWindow setCenter:center];

    [self updateLayoutForSize:rotatedFrame.size showCancel:YES updatePosition:YES];
}

- (void)updateLayoutForSize:(CGSize)size showCancel:(BOOL)showCancel updatePosition:(BOOL)updatePosition
{
    int activityMaxHeight = MIN(410, size.height - (updatePosition ? activityMinMarginTop : 0));

    int distanceToAdd;
    int actionsPerRow = floor((size.width - activityPaddingSide * 2) / (float)(buttonWidth + buttonHorizontalDistance));
    distanceToAdd = (actionsPerRow > 1) ? buttonWidth : buttonWidth + buttonHorizontalDistance;
    if ((size.width - (actionsPerRow * buttonWidth + (actionsPerRow - 1) * buttonVerticalDistance + 2 * activityPaddingSide)) >= distanceToAdd)
        actionsPerRow++;

    int fixedElementHeight = activityPaddingTop + pagingMarginTop + pagingHeight
        + (showCancel ? cancelMarginTop + _cancelButton.frame.size.height : 0)
        + activityPaddingMinBottom;
    int maxRowsPerPage = floor((activityMaxHeight - fixedElementHeight) / (float)(buttonHeight + buttonVerticalDistance));
    distanceToAdd = (maxRowsPerPage > 1) ? buttonHeight : buttonHeight + buttonVerticalDistance;
    if ((activityMaxHeight - (maxRowsPerPage * buttonHeight + (maxRowsPerPage - 1) * buttonVerticalDistance) - fixedElementHeight) >= distanceToAdd)
        maxRowsPerPage++;

    // calculate if we can fit another row as long as we can leave off the paging control
    if ((actionsPerRow * (maxRowsPerPage + 1)) >= _scrollView.subviews.count)
    {
        distanceToAdd = (maxRowsPerPage > 1) ? buttonHeight : buttonHeight + buttonVerticalDistance;
        if ((activityMaxHeight - (maxRowsPerPage * buttonHeight + (maxRowsPerPage - 1) * buttonVerticalDistance) - fixedElementHeight + pagingMarginTop + pagingHeight) >= distanceToAdd)
            maxRowsPerPage++;
    }
    int totalPages = ceil(_scrollView.subviews.count / (float)(actionsPerRow * maxRowsPerPage));
    BOOL hidePaging = (totalPages <= 1);

    int rowsPerPage = MIN(maxRowsPerPage, ceil(_scrollView.subviews.count / (float)actionsPerRow));
    if (_scrollView.subviews.count < actionsPerRow)
        actionsPerRow = _scrollView.subviews.count;

    int height = rowsPerPage * buttonHeight + (rowsPerPage - 1) * buttonVerticalDistance + fixedElementHeight;
    if (hidePaging)
        height -= pagingMarginTop + pagingHeight;
    if (height < activityMaxHeight)
        height += MIN(activityPaddingMaxBottom - activityPaddingMinBottom, activityMaxHeight - height);
    [_activityView setFrame:CGRectMake(0, updatePosition ? size.height - height : 0, size.width, height)];

    int currentPage = 1;
    if (_scrollView.contentSize.width > 0)
        currentPage = floor(_scrollView.contentOffset.x / _scrollView.frame.size.width) + 1;

    [_scrollView setFrame:CGRectMake(0, activityPaddingTop, size.width, rowsPerPage * buttonHeight + (rowsPerPage - 1) * buttonVerticalDistance)];
    _scrollView.contentSize = CGSizeMake(totalPages * _scrollView.frame.size.width, _scrollView.frame.size.height);

    int sideMargin = (_scrollView.frame.size.width - (actionsPerRow * buttonWidth + (actionsPerRow - 1) * buttonHorizontalDistance)) / 2;
    int index = 0;
    int row = -1;
    int page = -1;
    for (UIView *actionView in [_scrollView subviews])
    {
        int col;

        col = index % actionsPerRow;
        if (index % actionsPerRow == 0) row++;
        if (index % (actionsPerRow * rowsPerPage) == 0)
        {
            row = 0;
            page++;
        }

        [actionView setFrame:CGRectMake((sideMargin + col * buttonWidth + col * buttonHorizontalDistance) + page * _scrollView.frame.size.width, row * buttonHeight + row * buttonVerticalDistance, buttonWidth, buttonHeight)];
        index++;
    }
    if (currentPage > totalPages)
        currentPage = totalPages;

    [_scrollView scrollRectToVisible:CGRectMake((currentPage - 1) * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];

    _pageControl.frame = CGRectMake(0, _scrollView.frame.origin.y + _scrollView.frame.size.height + pagingMarginTop, size.width, pagingHeight);
    _pageControl.numberOfPages = totalPages;
    _pageControl.currentPage = currentPage - 1;
    _pageControl.hidden = hidePaging;

    int cancelButtonVerticalOrigin = (hidePaging)
        ? _scrollView.frame.origin.y + _scrollView.frame.size.height
        : _pageControl.frame.origin.y + _pageControl.frame.size.height;
    CGRect tmpFrame = [_cancelButton frame];
    [_cancelButton setFrame:CGRectMake((size.width - tmpFrame.size.width) / 2, cancelButtonVerticalOrigin + cancelMarginTop, tmpFrame.size.width, tmpFrame.size.height)];
}

- (void)statusBarWillChangeOrientation:(NSNotification *)notification
{
    NSNumber *orientation = [[notification userInfo] objectForKey:UIApplicationStatusBarOrientationUserInfoKey];
    if (_overlayWindow)
    {
        [_overlayWindow setTransform:[self transformForOrientation:[orientation intValue]]];
        [self updateOverlayLayoutForOrientation:[orientation intValue]];
    }
}

#pragma mark - Button action

- (void)cancelButtonPressed
{
    [_viewController dismiss];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

#pragma mark - UIPageControl target

- (void)pageControlValueChanged:(UIPageControl *)pageControl
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    CGFloat x = _pageControl.currentPage * pageWidth;
    [_scrollView scrollRectToVisible:CGRectMake(x, 0, pageWidth, _scrollView.frame.size.height) animated:YES];
}

#pragma mark - Getters

- (UIWindow *)overlayWindow
{
    if (!_overlayWindow)
    {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.transform = [self transformForOrientation:[UIApplication sharedApplication].statusBarOrientation];
        _overlayWindow.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.windowLevel = UIWindowLevelStatusBar;
    }

    return _overlayWindow;
}

@end
