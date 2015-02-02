//
//  UIViewController+UIViewController_ComicalBase.h
//  Comical
//
//  Created by Eric Weaver on 5/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ComicalBase)

- (void) setNavbarTitle;
- (void) setNavbarTitle:(NSString *)title;
- (void) setNavbarItems;
- (void) toggleLeftDrawer;
- (void) displayWaiting;
- (void) hideWaiting;

@end
