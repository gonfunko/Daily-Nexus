#`TDNComment : NSObject`#

TDNComment models a comment on an article in the Daily Nexus.

##Public Interface##

###Properties###
`@property (copy) NSString *author;` - The author of the comment, as a string.

`@property (copy) NSString *comment;` - The text of the comment as a string without HTML tags or formatting, suitable for display in the user interface.

`@property (retain) NSDate *date;` - The date the comment was posted.