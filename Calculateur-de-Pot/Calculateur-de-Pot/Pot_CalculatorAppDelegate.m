//
//  Pot_CalculatorAppDelegate.m
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 31/03/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import "Pot_CalculatorAppDelegate.h"

#import "Pot_CalculatorViewController.h"
#import "Pot_CalculatorSecondPageViewController.h"
#import "Pot_CalculatorThirdPageViewController.h"
#import "IIViewDeckController.h"


@implementation Pot_CalculatorAppDelegate

@synthesize window = _window;
@synthesize vue1;
@synthesize vue2;
@synthesize vue3;
@synthesize brain;

- (id)init
{
    self = [super init];
    if (self) {
        if (!self.brain) {
            brain = [[Pot_Calculator_Brain alloc] init];
        }
        if (!self.vue1) {
            vue1 = [[Pot_CalculatorViewController alloc] initWithBrain:brain];
        }
        if (!self.vue2) {
            vue2 = [[Pot_CalculatorSecondPageViewController alloc] initWithBrain:brain];
        }
        if (!self.vue3) {
            vue3 = [[Pot_CalculatorThirdPageViewController alloc] initWithBrain:brain];
        }
    }
    return self;
}

- (void)dealloc
{
    [_window release];
    self.vue1 = nil;
    self.vue2 = nil;
    self.vue3 = nil;
    self.brain = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    //self.viewController = [[[Pot_CalculatorViewController alloc] initWithNibName:@"Pot_CalculatorViewController" bundle:nil] autorelease];
    
    IIViewDeckController *dc = [[[IIViewDeckController alloc] initWithCenterViewController:self.vue1] autorelease];
    
    dc.leftController = self.vue2;
    dc.rightController = self.vue3;
    
    self.window.rootViewController = dc;
    [self.window makeKeyAndVisible];
    
    NSLog(@"fini de charger");
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
