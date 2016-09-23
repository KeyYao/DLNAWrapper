//
//  AppDelegate.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor whiteColor];
    
    MainViewController *rootViewController = [[MainViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    navController.navigationBar.hidden = YES;
    
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (UIColor *)getColor:(NSString *)color {
    unsigned int alpha = 1;
    unsigned int red;
    unsigned int green;
    unsigned int blue;
    NSRange range;
    range.length = 2;
    
    NSInteger colorLength = [color length];
    BOOL hasAlpha = NO;
    if (colorLength > 6) {
        hasAlpha = YES;
    }
    
    if (hasAlpha) {
        range.location = 0;
        [[NSScanner scannerWithString:[color substringWithRange:range]] scanHexInt:&alpha];
    }
    
    range.location = hasAlpha ? 2 : 0;
    [[NSScanner scannerWithString:[color substringWithRange:range]] scanHexInt:&red];
    
    range.location = hasAlpha ? 4 : 2;
    [[NSScanner scannerWithString:[color substringWithRange:range]] scanHexInt:&green];
    
    range.location = hasAlpha ? 6 : 4;
    [[NSScanner scannerWithString:[color substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float) (red / 255.0f) green:(float) (green / 255.0f) blue:(float) (blue / 255.0f) alpha:hasAlpha? (float) (alpha / 255.0) : 1.0f];
    
}

@end
