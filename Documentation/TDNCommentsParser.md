#`TDNCommentsParser : NSObject`#

TDNCommentsParser is responsible for extracting comments on articles from the HTML source of the article page on the Daily Nexus website

##Public Interface##

###Methods###
`- (NSArray *)commentsFromSource:(NSData *)source;` - Given the HTML source of an article page on the Daily Nexus website as an NSData object, returns an array of [TDNComment](TDNComment.md) objects representing the comments on the article

##Imported Classes##
* [TDNComment](TDNComment.md)