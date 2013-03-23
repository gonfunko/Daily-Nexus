//
//  TDNAppDelegate.m
//  Daily Nexus
//
//  TDNAppDelegate handles initial application setup and responding to application-wide state changes
//

#import "TDNAppDelegate.h"

@interface TDNAppDelegate ()

@end

@implementation TDNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Create our root view controller
    TDNFrontPageViewController *frontPageViewController = [[TDNFrontPageViewController alloc] initWithNibName:@"TDNFrontPageTableView" bundle:[NSBundle mainBundle]];
    
    // And a navigation controller to embed it in
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontPageViewController];
    
    // Set the window's root view controller and display the window
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    
    // Configure the global appearance of instances of UINavigationBar
    NSDictionary *navigationBarTextAttributes = @{UITextAttributeTextColor       : [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0],
                                                  UITextAttributeTextShadowColor : [UIColor whiteColor],
                                                  UITextAttributeFont            : [UIFont fontWithName:@"Bodoni 72 Oldstyle" size:20.0]};
    
    NSDictionary *backButtonTextAttributes = @{UITextAttributeTextColor       : [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0],
                                               UITextAttributeTextShadowColor : [UIColor whiteColor],
                                               UITextAttributeFont            : [UIFont fontWithName:@"Palatino" size:13.0]};
    
    [[UINavigationBar appearance] setTitleTextAttributes:navigationBarTextAttributes];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:backButtonTextAttributes forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:backButtonTextAttributes forState:UIControlStateHighlighted];
    
    return YES;
}

@end