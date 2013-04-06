#`TDNArticle : NSObject`#

TDNArticle is a data model class that represents an article in the Daily Nexus.

##Public Interface##

###Properties###
`@property (copy) NSString *title;` - The title of the article

`@property (copy) NSString *story;` - The text of the article, formatted for display in the user interface

`@property (copy) NSString *rawStory;` - The text of the article in HTML format

`@property (copy) NSString *author;` - The name of the author of the article

`@property (copy) NSString *url;` - The URL of the article on the Daily Nexus website

`@property (copy) NSDate *publicationDate;` - The date the article was published

`@property (retain) NSMutableArray *categories;` - A list of categories (sections) the article belongs to

`@property (retain) NSMutableArray *imageURLs;` - A list of URLs for images included in the article

`@property (retain) NSMutableArray *images;` - The actual image objects included in the article

`@property (retain) NSArray *comments;` - An array of [TDNComment](TDNComment.md) objects representing comments on the article

`@property (assign) NSInteger postID;` - The Wordpress ID of the article on the Daily Nexus website

###Methods###
`- (NSString *)htmlRepresentationWithHeight:(NSInteger)height andColumns:(BOOL)columns;` - Returns an HTML version of the article that fits in the specified `height` and either does or does not have columns, depending on the value of the `columns` argument

`- (NSString *)byline;` - Returns the byline for the article as a string, in the form `Published <date> by <author>`