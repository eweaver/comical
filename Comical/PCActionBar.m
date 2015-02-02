//
//  PCActionBar.m
//  Comical
//
//  Created by Eric Weaver on 6/1/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "PCActionBar.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "UIViewController+MMDrawerController.h"

@interface PCActionBar ()

@end

@implementation PCActionBar

- (UIToolbar *) createTabBar:(id)delegate withBounds:(CGRect)bounds {
    UIToolbar *actionBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 44)];
    actionBar.translucent = NO;
    
    UIBarButtonItem *browser = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tb_browser.png"] style:UIBarButtonItemStylePlain target:delegate action:@selector(actionBrowser:)];
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:delegate action:@selector(actionShare:)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:delegate action:nil];
    
    NSArray *buttonItems = [NSArray arrayWithObjects:spacer, browser, spacer, share, spacer, nil];
    [actionBar setItems:buttonItems];
    
    return actionBar;
}

@end
