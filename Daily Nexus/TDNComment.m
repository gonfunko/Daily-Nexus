//
//  TDNComment.m
//  Daily Nexus
//
//  TDNComment models a comment on an article in the Daily Nexus
//

#import "TDNComment.h"

@implementation TDNComment

@synthesize author;
@synthesize comment;
@synthesize date;

- (NSString *)description {
    return [NSString stringWithFormat:@"Comment by %@ at %@:\n%@", self.author, [self.date description], self.comment];
}

@end
