//
//  TDNArticleManager.h
//  Daily Nexus
//
//  TDNArticleManager is responsible for loading and maintaining a list of all available articles.
//

#import <Foundation/Foundation.h>
#import "TDNFeedParser.h"
#import "TDNArticle.h"

@interface TDNArticleManager : NSObject

+ (TDNArticleManager *)sharedManager;
- (void)loadAllArticles;

@end
