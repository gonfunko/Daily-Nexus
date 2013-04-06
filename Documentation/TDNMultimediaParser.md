#`TDNMultimediaParser : NSObject`#

TDNMultimediaParser extracts the URLs for images from the bodies of stories.

##Public Interface##

###Methods###
`- (NSArray *)multimediaURLsFromStoryBody:(NSString *)story;` - Given the HTML source of a story page as a string, returns an array of URLs for images as strings