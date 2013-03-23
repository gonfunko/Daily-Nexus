//
//  TDNMultimediaParser.m
//  Daily Nexus
//
//  TDNMultimediaParser extracts the URLs for images and videos from the bodies of stories
//

#import "TDNMultimediaParser.h"

@implementation TDNMultimediaParser

- (NSArray *)multimediaURLsFromStoryBody:(NSString *)story {
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    
    NSError *error = NULL;
    /* This cast shouldn't be necessary – the docs and headers are in conflict, and NSTextCheckingTypeLink is a valid input
       value, even though the headers want something from NSTextCheckingTypes. This is here to suppress a warning – if/when
       the bug is fixed, the cast can and should be removed. See 
       http://stackoverflow.com/questions/14226300/i-am-getting-an-implicit-conversion-from-enumeration-type-warning-in-xcode-for
       for more details. */
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeLink error:&error];
    // Assuming we successfully created a data detector, go through all the URLs it finds.
    if (detector) {
        [detector enumerateMatchesInString:story
                                   options:0
                                     range:NSMakeRange(0, [story length])
                                usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                    // If the URL ends in .jpg and isn't a thumbnail URL, add it to the list of URLs
                                    NSString *url = [[result URL] absoluteString];
                                    if ([url hasSuffix:@".jpg"] && ![self isThumbnailURL:url]) {
                                            [urls addObject:url];
                                    }
        }];
    } else {
        NSLog(@"Multimedia parser encountered an error: %@", error.localizedDescription);
    }
    
    return urls;
}

- (BOOL)isThumbnailURL:(NSString *)url {
    NSError *error = NULL;
    // Create a regex that looks for strings in the form 123x123.jpg – these indicate thumbnail images
    NSRegularExpression *thumbnailRegex = [[NSRegularExpression alloc] initWithPattern:@"[0-9]{3}x[0-9]{3}\\.jpg"
                                                                               options:0
                                                                                 error:&error];
    // Check how many matches there are in the string
    NSUInteger matches = [thumbnailRegex numberOfMatchesInString:url
                                                      options:0
                                                        range:NSMakeRange(0, [url length])];
    
    // If there aren't any, this probably isn't a thumbnail, and vice versa
    if (matches == 0) {
        return NO;
    } else {
        return YES;
    }
}
@end
