#`TDNFeedParser : NSObject <NSXMLParserDelegate>`#

TDNFeedParser parses the Daily Nexus RSS feed, extracts titles, authors, dates, stories and the like, and creates and returns an array of [TDNArticle](TDNArticle.md) objects that represent each item in the feed

##Public Interface##

###Methods###
`- (NSArray *)articlesWithFeedData:(NSData *)feedData;` - Given an NSData representation of the Daily Nexus RSS feed, parses it and returns an array of [TDNArticle](TDNArticle.md) objects

##Imported Classes##
* [TDNArticle](TDNArticle.md)
* [TDNMultimediaParser](TDNMultimediaParser.md)
* [NSString+TDNAdditions](NSString+TDNAdditions.md)