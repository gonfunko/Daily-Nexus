//
//  TDNCommentPostingViewController.m
//  Daily Nexus
//
//  TDNCommentPostingViewController is responsible for displaying a view that allows the user to
//  enter comments and posting these comments to the Daily Nexus website
//

#import "TDNCommentPostingViewController.h"

@interface TDNCommentPostingViewController ()

@property (retain, nonatomic) IBOutlet UITextField *name;
@property (retain, nonatomic) IBOutlet UITextField *email;
@property (retain, nonatomic) IBOutlet UITextView *comment;

@end

@implementation TDNCommentPostingViewController

@synthesize article;
@synthesize nonce;
@synthesize name;
@synthesize email;
@synthesize comment;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Post Comment";
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"commentsName" : @"", @"commentsEmail" : @"" }];
    
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(postComment:)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = postButton;
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.name.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.name.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.name.layer.borderWidth = 1.0;
    self.name.layer.cornerRadius = 8.0;
    self.name.layer.masksToBounds = YES;
    self.name.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.name.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"commentsName"];
    
    self.email.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.email.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.email.layer.borderWidth = 1.0;
    self.email.layer.cornerRadius = 8.0;
    self.email.layer.masksToBounds = YES;
    self.email.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.email.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"commentsEmail"];
    
    self.comment.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.comment.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.comment.layer.borderWidth = 1.0;
    self.comment.layer.cornerRadius = 8.0;
    self.comment.layer.masksToBounds = YES;
    
    // Register for notifications when the keyboard is shown or hidden
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification*)aNotification {
    CGRect keyboardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrame = [self.view convertRect:keyboardFrame fromView:nil];

    double animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{ self.comment.frame = CGRectMake(20, self.comment.frame.origin.y, self.view.frame.size.width - 40, (keyboardFrame.origin.y - 20) - self.comment.frame.origin.y); }
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    double animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{ self.comment.frame = CGRectMake(20, self.comment.frame.origin.y, self.view.frame.size.width - 40, self.view.frame.size.height - self.comment.frame.origin.y - 20); }
                     completion:nil];
}

// When text in any of the fields changes, disable the post button if any field does not contain text
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.name.text isEqualToString:@""] ||
        [self.email.text isEqualToString:@""] ||
        [self.comment.text isEqualToString:@""]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([self.name.text isEqualToString:@""] ||
        [self.email.text isEqualToString:@""] ||
        [self.comment.text isEqualToString:@""]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)postComment:(id)sender {
    // Store the name and email to autofill in the future
    [[NSUserDefaults standardUserDefaults] setObject:self.name.text forKey:@"commentsName"];
    [[NSUserDefaults standardUserDefaults] setObject:self.email.text forKey:@"commentsEmail"];
    
    // Perform basic URL escaping on text before POSTing it to the server
    CFStringRef escapedEmail = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.email.text, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), kCFStringEncodingUTF8);
    CFStringRef escapedName = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.name.text, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), kCFStringEncodingUTF8);
    CFStringRef escapedComment = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.comment.text, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), kCFStringEncodingUTF8);
    
    // Construct the POST string
    NSString *post = [NSString stringWithFormat:@"author=%@&email=%@&comment=%@&comment_post_ID=%ld&comment_parent=0&akismet_comment_nonce=%@", escapedName, escapedEmail, escapedComment, (long)self.article.postID, self.nonce];
    
    CFRelease(escapedComment);
    CFRelease(escapedEmail);
    CFRelease(escapedName);
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    // Set up a POST request of the comments form
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://dailynexus.com/wp-comments-post.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // Asynchronously send the request
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               // If we get a response, assume the comment was posted and dismiss ourselves; otherwise, present an error
                               if (data) {
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               } else {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Post Comment"
                                                                                   message:error.localizedDescription
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                               }
                           }];
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
