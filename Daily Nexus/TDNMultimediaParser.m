//
//  TDNMultimediaParser.m
//  Daily Nexus
//
//  TDNMultimediaParser extracts the URLs for images and videos from the bodies of stories
//

#import "TDNMultimediaParser.h"

@interface TDNMultimediaParser ()

@property (retain) NSMutableArray *urls;

@end

@implementation TDNMultimediaParser

@synthesize urls;

- (id)init {
    if (self = [super init]) {
        urls = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)multimediaURLsFromStoryBody:(NSString *)story {
    // Wrap our story in a root element
    story = [NSString stringWithFormat:@"<root>%@</root>", story];
    // Get a data representation
    NSData *storyData = [story dataUsingEncoding:NSUTF8StringEncoding];
    
    // Parse the story using an NSXMLParser
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:storyData];
    [parser setDelegate:self];
    [parser parse];
    
    return self.urls;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    // If we find an anchor tag that (1) has an href attribute and (2) that attribute's value has a multimedia file extension,
    // add it to our list of URLs
    if ([elementName isEqualToString:@"a"]) {
        if ([attributeDict objectForKey:@"href"] && [[attributeDict objectForKey:@"href"] hasSuffix:@".jpg"]) {
            [urls addObject:[attributeDict objectForKey:@"href"]];
        }
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    // If we encounter an error while parsing, log it to the console
    NSString *info = [NSString stringWithFormat:
                      @"Error %i, Description: %@, Line: %i, Column: %i",
                      [parseError code],
                      [parseError localizedDescription],
                      [parser lineNumber],
                      [parser columnNumber]];
    
    NSLog(@"Multimedia Parse Error: %@", info);
}

@end
