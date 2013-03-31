//
//  TDNCommentsParser.m
//  Daily Nexus
//
//  TDNCommentsParser is responsible for extracting comments on articles from the HTML source of
//  the article page on the Daily Nexus website
//

#import "TDNCommentsParser.h"

@implementation TDNCommentsParser

- (NSArray *)commentsFromSource:(NSData *)source {
    /* We're using a try/catch on this because the parsing is a bit fragile, mostly due to
       relying on keys and indices being present. If we throw an exception, just return an empty array */
    @try {
        // Extract the text of comments, dates and authors from the HTML source using XPath queries
        NSArray *commentBodies = PerformHTMLXPathQuery(source, @"//div[@class='comment-body']");
        NSArray *dates = PerformHTMLXPathQuery(source, @"//div[@class='comment-meta commentmetadata']");
        NSArray *authors = PerformHTMLXPathQuery(source, @"//cite[@class='fn']");
        
        // Set up an array to store comment objects in
        NSMutableArray *comments = [[NSMutableArray alloc] init];
        
        // Create a date formatter to extract dates from date strings
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM d, yyyy 'at' h:mm a"];
        
        // Loop through the dates/comments/authors
        for (int i = 0; i < [dates count]; i++) {
            // Create a new comment
            TDNComment *comment = [[TDNComment alloc] init];
            
            // Build up the body of the comment from the p elements
            NSString *commentText = @"";
            NSDictionary *commentBodyDict = [commentBodies objectAtIndex:i];
            for (NSDictionary *content in [commentBodyDict objectForKey:@"nodeChildArray"]) {
                if ([[content objectForKey:@"nodeName"] isEqualToString:@"p"]) {
                    if ([content objectForKey:@"nodeContent"] != nil) {
                        commentText = [commentText stringByAppendingFormat:@"%@\n\n", [content objectForKey:@"nodeContent"]];
                    }
                }
            }
            
            // Set the comment's text
            comment.comment = [commentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            // Extract the author (the if statement handles the case where the author doesn't have a website)
            NSDictionary *authorDict = [authors objectAtIndex:i];
            NSString *author = [[[authorDict objectForKey:@"nodeChildArray"] objectAtIndex:0] objectForKey:@"nodeContent"];
            if (author == nil) {
                author = [authorDict objectForKey:@"nodeContent"];
            }
            
            // Set the comment's author
            comment.author = author;
            
            // Extract the date using our date formatter and store it in the comment object
            NSString *dateString = [[[[dates objectAtIndex:i] objectForKey:@"nodeChildArray"] objectAtIndex:0] objectForKey:@"nodeContent"];
            comment.date = [formatter dateFromString:dateString];
            
            // Add the comment to the comments array
            [comments addObject:comment];
        }

        return comments;
    } @catch (NSException *exception) {
        // If an exception is thrown, just return an empty array
        return [[NSArray alloc] init];
    }
    
}

@end
