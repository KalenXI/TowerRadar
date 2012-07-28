//
//  TWFAppDelegate.m
//  TowerFinder
//
//  Created by Kevin Vinck on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TWFAppDelegate.h"

#import "TWFFirstViewController.h"

@implementation TWFAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"searchRadius"] == nil) {
        [defaults setValue:[NSNumber numberWithInt:50] forKey:@"searchRadius"];
    }
    if ([defaults valueForKey:@"defaultTower"] == nil) {
        NSMutableDictionary *defaultTower = [NSMutableDictionary dictionaryWithCapacity:6];
        
        [defaultTower setValue:@"38" forKey:@"channel"];
        [defaultTower setValue:[NSNumber numberWithFloat:39.33472] forKey:@"latitude"];
        [defaultTower setValue:[NSNumber numberWithFloat:-76.65083] forKey:@"longitude"];
        [defaultTower setValue:@"1000.  kW" forKey:@"power"];
        [defaultTower setValue:@"2" forKey:@"psip"];
        [defaultTower setValue:@"WMAR-TV" forKey:@"stationName"];
        
        [defaults setObject:defaultTower forKey:@"defaultTower"];
    }
    
    UIViewController *viewController1 = [[TWFFirstViewController alloc] initWithNibName:@"TWFFirstViewController" bundle:nil];
    //UIViewController *viewController2 = [[TWFSecondViewController alloc] initWithNibName:@"TWFSecondViewController" bundle:nil];
    UITableViewController *settingsViewController = [[SettingsTableView alloc] initWithNibName:@"SettingsTableView" bundle:nil];
    UINavigationController *settingNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    MapViewController *mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    settingNavigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, mapViewController, settingNavigationController, nil];
    self.window.rootViewController = self.tabBarController;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
