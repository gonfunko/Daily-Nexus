//
//  TDNFrontPageViewController.h
//  Daily Nexus
//
//  TDNFrontPageViewController is responsible for managing the "front page" view that the user first
//  sees when launching the app and providing data and cells to the collection view that displays stories
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TDNArticleManager.h"

@interface TDNFrontPageViewController : UITableViewController <TDNArticleManagerDelegate>

@end
