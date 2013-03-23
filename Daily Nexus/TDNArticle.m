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

- (NSString *)description {
    // Generate a reasonably nice representation of the article for debugging
    NSMutableString *articleDescription = [NSMutableString stringWithFormat:@"%@\nPublished %@ by %@\n%@\nCategories: %@\nImages: %@\n%@", self.title, [self.publicationDate description], self.author, self.url, [self.categories description], [self.imageURLs description], self.story];
    
    return articleDescription;
}

@end
