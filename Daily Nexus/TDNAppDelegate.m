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
    TDNFrontPageViewController *frontPageViewController = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        frontPageViewController = [[TDNFrontPageViewController alloc] initWithNibName:@"TDNFrontPageTableView" bundle:[NSBundle mainBundle]];
    } else {
        frontPageViewController = [[TDNFrontPageViewController alloc] initWithNibName:@"TDNFrontPageCollectionView" bundle:[NSBundle mainBundle]];
    }

    // And a navigation controller to embed it in
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontPageViewController];

    // Create a section view controller
    TDNSectionViewController *sectionViewController = [[TDNSectionViewController alloc] initWithNibName:@"TDNSectionViewController" bundle:[NSBundle mainBundle]];
    
    // And a sliding drawer view controller with the section controller as the left view controller and the navigation controller as the main view controller
    TDNSlidingDrawerViewController *slidingDrawerViewController = [[TDNSlidingDrawerViewController alloc] initWithNibName:@"TDNSlidingDrawerViewController"
                                                                                           bundle:[NSBundle mainBundle]
                                                                               mainViewController:navigationController
                                                                               leftViewController:sectionViewController
                                                                           andRightViewController:nil];
    
    // Set the window's root view controller and display the window
    self.window.rootViewController = slidingDrawerViewController;
    
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