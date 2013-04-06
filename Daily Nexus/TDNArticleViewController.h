//
//  TDNArticleViewController.h
//  Daily Nexus
//
//  TDNArticleViewController uses a UIWebView and CSS 3 to display story text 
//  along with the title, byline and image(s)
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TDNArticleManager.h"
#import "TDNArticle.h"

@interface TDNArticleViewController : UIViewController <UIWebViewDelegate, UIGestureRecognizerDelegate, UIPopoverControllerDelegate, UIScrollViewDelegate>

@property (retain) TDNArticle *article;
@property (assign) BOOL columnated;

@end
