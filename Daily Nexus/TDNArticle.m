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
@synthesize rawStory;
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
        rawStory = @"";
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

// Just use titles for testing equality. This could be expanded to compare all properties, but for our purposes this is sufficient
- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        TDNArticle *otherArticle = object;
        if ([otherArticle.title isEqualToString:self.title]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSUInteger)hash {
    return [self.title hash];
}

- (NSString *)description {
    // Generate a reasonably nice representation of the article for debugging
    NSMutableString *articleDescription = [NSMutableString stringWithFormat:@"%@\nPublished %@ by %@\n%@\nCategories: %@\nImages: %@\n%@", self.title, [self.publicationDate description], self.author, self.url, [self.categories description], [self.imageURLs description], self.story];
    
    return articleDescription;
}

- (NSString *)htmlRepresentationWithHeight:(NSInteger)height andColumns:(BOOL)columns {
    NSString *htmlRepresentation = @"";
    if (columns) {
        /* A quick explanation of this awfulness: This is designed for display in the multi-column article view.
           To that end, the following appearance tweaks are included: 20px margins on all sides. This isn't 
           directly set on the div because CSS multicolumns with a fixed height and without a specified number of
           columns can't figure out their width, so you get margins everywhere except the right. Thus, we set them on
           the top and left on the div, and on the right on the internal p element, which fakes it (and handles whitespace
           between columns). We also enable justification and hyphenation for the text for nice typography and set the fonts and colors. */
        htmlRepresentation = [NSString stringWithFormat:@"<html><head><style>p { margin-right: 20px; text-align: justify; -webkit-hyphens: auto; } h6 { margin-right: 20px; text-align: justify; -webkit-hyphens: auto; } body { margin: 0; padding: 0; }</style></head><body><div style=\"margin-top: 20px; margin-left: 20px; -webkit-column-width: 18em; font-family: Palatino; font-size: 12pt; color: #333333; height: %ldpx;\" id=\"container\"><h1 style=\"font-family: Palatino; font-size: 20pt; font-weight: bold; color: #333333; margin-right: 20px; margin-top: -3px;\">%@</h1><h2 style=\"font-family: Palatino; font-weight: normal; font-size: 10pt; color: #808080; margin-right: 20px;\">%@</h2>%@</div></body></html>", (long)height, self.title, [self byline], self.rawStory];
    } else {
        htmlRepresentation = [NSString stringWithFormat:@"<html><body style=\"padding-bottom: 20px;\"><div style=\"font-family: Palatino; font-size: 12pt; color: #333333; height: %ldpx; margin: 5px;\" id=\"container\"><h1 style=\"font-family: Palatino; font-size: 20pt; font-weight: bold; color: #333333;\">%@</h1><h2 style=\"font-family: Palatino; font-weight: normal; font-size: 10pt; color: #808080;\">%@</h2><div style=\"text-align: justify; -webkit-hyphens: auto; margin-bottom: 10px; overflow: hidden;\">%@</div></div></body></html>", (long)height, self.title, [self byline], self.rawStory];
    }
    
    return htmlRepresentation;
}

@end
