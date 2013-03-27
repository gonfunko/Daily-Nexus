//
//  TDNFeedParser.m
//  Daily Nexus
//
//  TDNFeedParser parses the Daily Nexus RSS feed, extracts titles, authors, dates, stories and the like,
//  and creates and returns an array of articles that represent each item in the feed
//

#import "TDNFeedParser.h"

@interface TDNFeedParser ()

@property (retain) NSMutableArray *articles;
// These two properties exist to hold temporary values generated while parsing
@property (retain) TDNArticle *currentArticle;
@property (retain) NSMutableString *currentElementData;

@end

@implementation TDNFeedParser

@synthesize articles;
@synthesize currentElementData;
@synthesize currentArticle;

- (id)init {
    if (self = [super init]) {
        currentElementData = [NSMutableString stringWithString:@""];
        articles = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)articlesWithFeedData:(NSData *)feedData {
    self.articles = [[NSMutableArray alloc] init];
    
    // Create an XML parser and use it to parse the RSS feed
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:feedData];
    [parser setDelegate:self];
    [parser parse];
    
    return self.articles;
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    // Every time we encounter a new item element, create a new article
    if ([elementName isEqualToString:@"item"]) {
        TDNArticle *article = [[TDNArticle alloc] init];
        self.currentArticle = article;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    // Rather than directly setting currentElementData, we append the string the parser found to it,
    // since this method may be called multiple times per element
    [self.currentElementData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    // Based on the name of the element we finished parsing, set the appropriate article property to
    // the contents of currentElementData. In all cases, we want to sanitize this value first to strip
    // whitespace, replace HTML escape sequences and remove tags
    if ([elementName isEqualToString:@"title"]) {
        self.currentArticle.title = [self.currentElementData strippedString];
    } else if ([elementName isEqualToString:@"dc:creator"]) {
        self.currentArticle.author = [self.currentElementData strippedString];
    } else if ([elementName isEqualToString:@"link"]) {
        self.currentArticle.url = [self.currentElementData strippedString];
    } else if ([elementName isEqualToString:@"content:encoded"]) {
        TDNMultimediaParser *multimediaParser = [[TDNMultimediaParser alloc] init];
        [self.currentArticle.imageURLs addObjectsFromArray:[multimediaParser multimediaURLsFromStoryBody:self.currentElementData]];
        self.currentArticle.story = [self.currentElementData strippedString];
        self.currentArticle.rawStory = self.currentElementData;
    } else if ([elementName isEqualToString:@"pubDate"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
        self.currentArticle.publicationDate = [formatter dateFromString:[self.currentElementData strippedString]];
    } else if ([elementName isEqualToString:@"category"]) {
        [self.currentArticle.categories addObject:[self.currentElementData strippedString]];
    } else if ([elementName isEqualToString:@"item"]) {
        // In the case where we finished parsing an item element, we're done with this article, so add it to the array
        [self.articles addObject:self.currentArticle];
    }
    
    // Since we finished an element, clear out currentElementData so it's ready for the next one
    self.currentElementData = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    // If we encounter an error while parsing, log it to the console
    NSString *info = [NSString stringWithFormat:
                      @"Error %i, Description: %@, Line: %i, Column: %i",
                      [parseError code],
                      [parseError localizedDescription],
                      [parser lineNumber],
                      [parser columnNumber]];
    
    NSLog(@"RSS Feed Parse Error: %@", info);
}

@end
