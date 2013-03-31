//
//  TDNComment.h
//  Daily Nexus
//
//  TDNComment models a comment on an article in the Daily Nexus
//

#import <Foundation/Foundation.h>

@interface TDNComment : NSObject

@property (copy) NSString *author;
@property (copy) NSString *comment;
@property (retain) NSDate *date;

@end
