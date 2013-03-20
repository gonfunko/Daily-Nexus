//
//  TDNArticle.h
//  Daily Nexus
//
//  TDNArticle is a data model class that represents an article in the Daily Nexus
//

#import <Foundation/Foundation.h>

@interface TDNArticle : NSObject

@property (copy) NSString *title;
@property (copy) NSString *story;
@property (copy) NSString *author;
@property (copy) NSString *url;
@property (copy) NSDate *publicationDate;
@property (retain) NSMutableArray *categories;

@end
