//
//  PCAppDelegate.m
//  Comical
//
//  Created by Eric Weaver on 5/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "PCAppDelegate.h"
#import "PCConstants.h"
#import "PCLiveStreamViewController.h"
#import "PCStreamSelectViewController.h"
#import <Parse/Parse.h>
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "PCSource+Parse.h"

@implementation PCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:COMICAL_PARSE_APP_ID
                  clientKey:COMICAL_PARSE_CLIENT_KEY];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    PCLiveStreamViewController *viewController = [[PCLiveStreamViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    PCStreamSelectViewController *leftDrawer = [[PCStreamSelectViewController alloc] init];
    
    [navigationController setRestorationIdentifier:@"ComicalCenterNavigationControllerRestorationKey"];
    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:navigationController
                                                                           leftDrawerViewController:leftDrawer];
    
    [drawerController setRestorationIdentifier:@"Comical"];
    [drawerController setMaximumLeftDrawerWidth:260.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeCustom];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll & ~MMCloseDrawerGestureModePanningDrawerView];
    
    [drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         
     }];

    [PCSource fetchNewForInstallation:^(BOOL succeeded, NSError *error) {
        
        
    }];
    
    
    self.window.rootViewController = drawerController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
