//
//  RKViewController.h
//  RKActivityExample
//
//  Created by Robin Kunde on 5/1/13.
//  Copyright (c) 2013 Recoursive.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKViewController : UIViewController <UIPopoverControllerDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *uiActivityButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rkActivityButton;

- (IBAction)showUIActivity:(id)sender;
- (IBAction)showRKActivity:(id)sender;
@end
