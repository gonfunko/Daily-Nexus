//
//  TDNArticleManager.h
//  Daily Nexus
//
//  TDNArticleManager is responsible for loading and maintaining a list of all available articles.
//

#import <Foundation/Foundation.h>
#import "TDNFeedParser.h"
#import "TDNArticle.h"

@protocol TDNArticleManagerDelegate <NSObject>

@optional
- (void)articleManagerDidStartLoading;
- (void)articleManagerDidFinishLoading;

@end

@interface TDNArticleManager : NSObject

+ (TDNArticleManager *)sharedManager;
- (void)loadAllArticles;
- (NSArray *)currentArticles;

@property (retain) id <TDNArticleManagerDelegate> delegate;

@end
