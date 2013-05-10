//
//  RKActivity.m
//  RKActivity
//
//  Created by Robin Kunde on 3/14/13.
//  Copyright (c) 2013 Robin Kunde. All rights reserved.
//

#import "RKActivity.h"

@class RKActivityViewController;

@implementation RKActivity

- (id)initWithTitle:(NSString *)title image:(UIImage *)image actionBlock:(RKActivityActionBlock)actionBlock
{
    self = [self initWithTitle:title image:image];
    if (self)
    {
        _actionBlock = [actionBlock copy];
    }

    return self;
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image
{
    self = [super init];
    if (self)
    {
        _title = title;
        _image = image;
    }

    return self;
}

- (void)performActivityWithUserInfo:(NSDictionary *)userInfo andViewController:(RKActivityViewController *)viewController
{
    NSDictionary *info = (_userInfo) ? _userInfo : userInfo;

    if (_actionBlock)
    {
        _actionBlock(self, info, viewController);
    }
    else
    {
        [self _performActivityWithUserInfo:info andViewController:viewController];
    }
}

- (void)_performActivityWithUserInfo:(NSDictionary *)userInfo andViewController:(RKActivityViewController *)viewController
{
}

@end


NSString* RKALocalizedString(NSString* key)
{
    static NSBundle* bundle = nil;
    if (nil == bundle)
    {
        bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"RKActivityResources" ofType:@"bundle"]];
    }
    return [bundle localizedStringForKey:key value:key table:nil];
}
