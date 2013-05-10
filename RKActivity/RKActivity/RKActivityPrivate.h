//
//  RKActivityPrivate.h
//  RKActivity
//
//  Created by Robin Kunde on 3/21/13.
//  Copyright (c) 2013 Robin Kunde. All rights reserved.
//

@interface RKActivity ()

- (id)initWithTitle:(NSString *)title image:(UIImage *)image;
- (void)_performActivityWithUserInfo:(NSDictionary *)userInfo andViewController:(UIViewController *)viewController;
@end
