//
//  TDNArticle.m
//  Daily Nexus
//
//  TDNArticle is a data model class that represents an article in the Daily Nexus
//

#import "TDNArticle.h"

@implementation TDNArticle

@synthesize title;
@synthesize story;
@synthesize author;
@synthesize url;
@synthesize publicationDate;
@synthesize categories;
@synthesize images;
@synthesize imageURLs;

- (id)init {
    if (self = [super init]) {
        // Initialize all our properties to non-nil values
        title = @"";
        story = @"";
        author = @"";
        url = @"";
        publicationDate = [NSDate date];
        categories = [[NSMutableArray alloc] init];
        images = [[NSMutableArray alloc] init];
        imageURLs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSString *)byline {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM d, YYYY"];
    NSString *byline = [NSString stringWithFormat:@"Published %@ by %@", [formatter stringFromDate:self.publicationDate], self.author];
    
    return byline;
}

- (NSString *)description {
    // Generate a reasonably nice representation of the article for debugging
    NSMutableString *articleDescription = [NSMutableString stringWithFormat:@"%@\nPublished %@ by %@\n%@\nCategories: %@\nImages: %@\n%@", self.title, [self.publicationDate description], self.author, self.url, [self.categories description], [self.imageURLs description], self.story];
    
    return articleDescription;
}

- (NSString *)htmlRepresentationWithHeight:(NSInteger)height {
    NSString *htmlRepresentation = [NSString stringWithFormat:@"<html><div style=\"-webkit-column-width: 13em; -webkit-column-gap: 1em; font-family: Palatino; font-size: 12pt; color: #2b2b2b; height: %ldpx;\"><h1 style=\"font-family: Palatino; font-size: 20pt; font-weight: bold; color: #2b2b2b;\">%@</h1><h2 style=\"font-family: Palatino; font-weight: normal; font-size: 10pt; color: #b8b8b8;\">%@</h2>%@</div></html>", (long)height, self.title, [self byline], self.story];
    
    return htmlRepresentation;
}

@end
