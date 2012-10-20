//
//  AppDelegate.m
//  NLProject
//
//  Created by Алексей Гончаров on 21.07.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import "AppDelegate.h"
#import "MainMenu.h"
@implementation AppDelegate

@synthesize window = _window;



- (void)copyLevels {
	BOOL success;
	NSError *error;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingString:@"/Levels.plist"];
	
	success = [fileManager fileExistsAtPath:filePath];
	if (success) return;
	
	NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/Levels.plist"];
	success = [fileManager copyItemAtPath:path toPath:filePath error:&error];
	
	if (!success) {
		NSAssert1(0, @"Failed to copy Plist. Error %@", [error localizedDescription]);
	}
	else {
		NSLog(@"Levels loaded");
	}
	
	filePath = [documentsDirectory stringByAppendingString:@"/Users.plist"];
	
	success = [fileManager fileExistsAtPath:filePath];
	if (success) return;
	
	path = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/Users.plist"];
	success = [fileManager copyItemAtPath:path toPath:filePath error:&error];
	
	if (!success) {
		NSAssert1(0, @"Failed to copy Plist. Error %@", [error localizedDescription]);
	}
	else {
		NSLog(@"Users loaded");
	}
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:[[MainMenu alloc] init]];
	navigation.navigationBarHidden = YES;
	
	navigation.view.frame = CGRectMake(0.f, 0.f, 1024.f, 768.f);
	UIImage * background = [UIImage imageNamed:@"Back.jpeg"];
		// redraw the image to fit |navigation.view|'s size
	UIGraphicsBeginImageContextWithOptions(navigation.view.frame.size, NO, 0.f);
	[background drawInRect:CGRectMake(0.f, 0.f, navigation.view.frame.size.width, navigation.view.frame.size.height)];
	UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	navigation.view.backgroundColor = [UIColor colorWithPatternImage:resultImage];
	self.window.rootViewController = navigation;
	
	[self copyLevels];
	
	/*NSString* enabled = [[NSUserDefaults standardUserDefaults] stringForKey:@"color"];
    if ([enabled isEqualToString:@"white"]) {
        [self.window setBackgroundColor:[UIColor whiteColor]];
    }
    else {
        [self.window setBackgroundColor:[UIColor blackColor]];
    }*/
    //self.window.backgroundColor = [UIColor whiteColor];
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:20] ,@"numberOfSolvesInLevel",
                               [NSNumber numberWithInt:17] ,@"solveDifficult",
                               [NSNumber numberWithBool:YES],@"solveEnabled",
                               [NSNumber numberWithInt:6] ,@"decimetersDifficult",
                               [NSNumber numberWithBool:YES],@"decimetersEnabled",
                               [NSNumber numberWithInt:2] ,@"magicSquareDifficult",
                               [NSNumber numberWithBool:YES],@"magicSquareEnabled",
                               [NSNumber numberWithInt:2] ,@"interestingSquareDifficult",
                               [NSNumber numberWithBool:YES],@"interestingSquareEnabled",
                               [NSNumber numberWithInt:12] ,@"compareDifficult",
                               [NSNumber numberWithBool:YES],@"compareEnabled",
                               [NSNumber numberWithInt:8] ,@"equationDifficult",
                               [NSNumber numberWithBool:YES],@"equationEnabled",nil];
  [defaults registerDefaults:appDefaults];
  [defaults synchronize];
	[self.window makeKeyAndVisible];
	[Appirater appLaunched:YES];
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
	[Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSString* enabled = [[NSUserDefaults standardUserDefaults] stringForKey:@"color"];
    if ([enabled isEqualToString:@"white"]) {
        [self.window setBackgroundColor:[UIColor whiteColor]];
    }
    else {
        [self.window setBackgroundColor:[UIColor blackColor]];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
