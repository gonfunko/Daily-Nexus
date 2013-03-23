//
//  TDNMultimediaParser.h
//  Daily Nexus
//
//  TDNMultimediaParser extracts the URLs for images and videos from the bodies of stories
//

#import <Foundation/Foundation.h>

@interface TDNMultimediaParser : NSObject

- (NSArray *)multimediaURLsFromStoryBody:(NSString *)story;

@end
