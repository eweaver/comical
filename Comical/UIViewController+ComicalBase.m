//
//  UIViewController+UIViewController_ComicalBase.m
//  Comical
//
//  Created by Eric Weaver on 5/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "UIViewController+ComicalBase.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "UIViewController+MMDrawerController.h"
#import "PCOrganizeViewController.h"
#import "MBProgressHUD.h"

@implementation UIViewController (ComicalBase)

- (void) setNavbarTitle {
    self.title = @"Comical";
}

- (void) setNavbarTitle:(NSString *)title {
    self.title = title;
}

- (void) setNavbarItems {
    //UIBarButtonItem *shareItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:nil];
    UIBarButtonItem *streams = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list-star-7.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftDrawer)];
    
    NSArray *actionButtonItems2 = @[streams];
    self.navigationItem.leftBarButtonItems = actionButtonItems2;
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(pushOrganizeViewController)];
    
    NSArray *actionButtonItems = @[shareItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}

- (void) pushOrganizeViewController {
    UINavigationController *navController = (UINavigationController *) self.mm_drawerController.centerViewController;
    PCOrganizeViewController *viewController = [[PCOrganizeViewController alloc] init];
    [navController pushViewController:viewController animated:YES];
}

- (void) toggleLeftDrawer {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void) displayWaiting {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
    });
}

- (void) hideWaiting {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
}

@end
