//
//  TDNArticleView.h
//  Daily Nexus
//
//  TDNArticleView displays an article's title, byline, image and text
//

#import <UIKit/UIKit.h>
#import "TDNArticle.h"

@interface TDNArticleView : UIView

@property (nonatomic, retain) TDNArticle *article;

@end
