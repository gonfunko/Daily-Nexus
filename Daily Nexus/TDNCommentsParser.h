//
//  TDNCommentsParser.h
//  Daily Nexus
//
//  TDNCommentsParser is responsible for extracting comments on articles from the HTML source of
//  the article page on the Daily Nexus website
//

#import <Foundation/Foundation.h>
#import "TDNComment.h"
#import "XPathQuery.h"

@interface TDNCommentsParser : NSObject

- (NSArray *)commentsFromSource:(NSData *)source;

@end
