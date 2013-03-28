//
//  thiAppDelegate.m
//  thiContainerViewController
//
//  Created by thi on 13-3-20.
//  Copyright (c) 2013年 thi. All rights reserved.
//

#import "thiAppDelegate.h"
#import "thiContainerViewController.h"
#import "thiContentViewController.h"

@implementation thiAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    srand(time(nil));
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    thiContainerViewController *container = [[thiContainerViewController alloc] init];
    [self.window setRootViewController:container];
    UITabBarController *tabController = [[UITabBarController alloc] init];
    [container pushScrollViewController:tabController animated:NO scrollEnabled:NO];

    thiContentViewController *content = [[thiContentViewController alloc] init];
    [tabController addChildViewController:content];
    content.thiContainerDelegate = container;
    [content release];
    thiContentViewController *content1 = [[thiContentViewController alloc] init];
    [tabController addChildViewController:content1];
    content1.thiContainerDelegate = container;
    [content1 release];
    thiContentViewController *content2 = [[thiContentViewController alloc] init];
    [tabController addChildViewController:content2];
    content2.thiContainerDelegate = container;
    [content2 release];
    
    [tabController release];
    [container release];


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
