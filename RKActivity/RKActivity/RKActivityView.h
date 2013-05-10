//
//  RKActivityView.h
//  RKActivity
//
//  Created by Robin Kunde on 3/13/13.
//  Copyright (c) 2013 Robin Kunde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKActivityViewController.h"

@interface RKActivityView : UIView
@property (weak, nonatomic) RKActivityViewController *viewController;

- (id)initWithActivities:(NSArray *)activities viewController:(RKActivityViewController *)viewController;
- (void)showAsOverlay;
- (void)dismiss;
- (void)show;
- (void)hide;
- (void)layoutForPopover;
@end
