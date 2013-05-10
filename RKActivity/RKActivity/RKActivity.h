//
//  RKActivity.h
//  RKActivity
//
//  Created by Robin Kunde on 3/14/13.
//  Copyright (c) 2013 Robin Kunde. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKActivity;
@class RKActivityViewController;

typedef void (^RKActivityActionBlock)(RKActivity *activity, NSDictionary *userInfo, RKActivityViewController *viewController);

@interface RKActivity : NSObject

@property (strong, readonly, nonatomic) NSString *title;
@property (strong, readonly, nonatomic) UIImage *image;
@property (strong, nonatomic) NSDictionary *userInfo;
@property (copy, nonatomic) RKActivityActionBlock actionBlock;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image actionBlock:(RKActivityActionBlock)actionBlock;
- (void)performActivityWithUserInfo:(NSDictionary *)userInfo andViewController:(UIViewController *)viewController;
@end

NSString* RKALocalizedString(NSString* key);
