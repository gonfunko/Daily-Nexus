//
//  TDNFeedParser.h
//  Daily Nexus
//
//  TDNFeedParser parses the Daily Nexus RSS feed, extracts titles, authors, dates, stories and the like,
//  and creates and returns an array of articles that represent each item in the feed
//

#import <Foundation/Foundation.h>
#import "TDNArticle.h"
#import "TDNMultimediaParser.h"
#import "NSString+TDNAdditions.h"

@interface TDNFeedParser : NSObject <NSXMLParserDelegate>

- (NSArray *)articlesWithFeedData:(NSData *)feedData;

@end
