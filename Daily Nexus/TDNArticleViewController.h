//
//  TDNArticleViewController.h
//  Daily Nexus
//
//  TDNArticleViewController is responsible for presenting and managing a view that displays a single article.
//

#import <UIKit/UIKit.h>
#import "TDNArticle.h"
#import "TDNArticleView.h"

@interface TDNArticleViewController : UIViewController

@property (retain) TDNArticle *article;
@property (nonatomic, retain) IBOutlet TDNArticleView *articleView;

@end
