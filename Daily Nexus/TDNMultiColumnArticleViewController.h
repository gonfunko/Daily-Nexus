//
//  TDNMultiColumnArticleViewController.h
//  Daily Nexus
//
//  TDNMultiColumnArticleViewController uses a UIWebView and CSS 3 to display story text in a multi-column
//  format along with the title, byline and image(s)
//

#import <UIKit/UIKit.h>
#import "TDNArticle.h"

@interface TDNMultiColumnArticleViewController : UIViewController <UIWebViewDelegate>

@property (retain) TDNArticle *article;

@end
