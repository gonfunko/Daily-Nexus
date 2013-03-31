//
//  TDNCommentsViewController.h
//  Daily Nexus
//
//  TDNCommentsViewController is responsible for presenting a table view that displays comments on articles
//

#import "TDNCommentsViewController.h"

@interface TDNCommentsViewController ()

@property (retain) UILabel *noCommentsLabel;
@property (retain) UIActivityIndicatorView *loadingIndicator;

@end

@implementation TDNCommentsViewController

@synthesize noCommentsLabel;
@synthesize loadingIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up our background noise texture
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoiseBackground"]];
    backgroundView.contentMode = UIViewContentModeCenter;
    self.tableView.backgroundView = backgroundView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = @"Comments";
    
    // Set up our placeholder text
    self.noCommentsLabel = [[UILabel alloc] init];
    self.noCommentsLabel.text = @"No Comments";
    self.noCommentsLabel.font = [UIFont fontWithName:@"Palatino" size:20.0];
    self.noCommentsLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    self.noCommentsLabel.shadowColor = [UIColor whiteColor];
    self.noCommentsLabel.shadowOffset = CGSizeMake(0, 1);
    self.noCommentsLabel.backgroundColor = [UIColor clearColor];
    [self.noCommentsLabel sizeToFit];
    [self.tableView addSubview:self.noCommentsLabel];
    
    // Set up our loading indicator
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingIndicator.color = [UIColor colorWithWhite:0.5 alpha:1.0];
    [self.tableView addSubview:self.loadingIndicator];
}

- (void)viewWillAppear:(BOOL)animated {
    // Reload the table to reflect the comments for the current article (or lack thereof)
    [self.tableView reloadData];
    
    // If there aren't any comments, we need to load them
    if ([TDNArticleManager sharedManager].currentArticle.comments == nil) {
        // Fix the positioning and visibility of the loading indicator and placeholder text
        self.noCommentsLabel.frame = CGRectMake((self.tableView.frame.size.width - self.noCommentsLabel.frame.size.width) / 2, (self.tableView.frame.size.height - self.noCommentsLabel.frame.size.height) / 2, self.noCommentsLabel.frame.size.width, self.noCommentsLabel.frame.size.height);
        self.noCommentsLabel.hidden = YES;
        self.noCommentsLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.loadingIndicator.frame = CGRectMake((self.tableView.frame.size.width - self.loadingIndicator.frame.size.width) / 2, (self.tableView.frame.size.height - self.loadingIndicator.frame.size.height) / 2, self.loadingIndicator.frame.size.width, self.loadingIndicator.frame.size.height);
        self.loadingIndicator.hidden = NO;
        self.loadingIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.loadingIndicator startAnimating];
        
        // Set up a request for the article's page source
        NSURL *articleURL = [NSURL URLWithString:[TDNArticleManager sharedManager].currentArticle.url];
        NSURLRequest *articleRequest = [NSURLRequest requestWithURL:articleURL];

        // Send the request
        [NSURLConnection sendAsynchronousRequest:articleRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if (data) {
                                       // If we get data in response, create a parser and parse the comments
                                       TDNCommentsParser *parser = [[TDNCommentsParser alloc] init];
                                       NSArray *comments = [parser commentsFromSource:data];
                                       // Set the current article's comments
                                       [TDNArticleManager sharedManager].currentArticle.comments = comments;
                                       //Hide the loading indicator and reload the table
                                       [self.loadingIndicator stopAnimating];
                                       self.loadingIndicator.hidden = YES;
                                       [self.tableView reloadData];
                                   } else {
                                       // If we didn't get any data, present an error
                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Loading Comments"
                                                                                       message:error.localizedDescription
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"OK"
                                                                             otherButtonTitles:nil, nil];
                                       
                                       [alert show];
                                   }
                               }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // If we have no items, show the placeholder text; otherwise, hide it
    NSInteger count = [[TDNArticleManager sharedManager].currentArticle.comments count];
    if (count == 0) {
        self.noCommentsLabel.hidden = NO;
    } else {
        self.noCommentsLabel.hidden = YES;
    }
    
    // Return the number of comments
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // If we didn't get a cell, create and configure one
        cell = [[TDNEtchedSeparatorTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        cell.textLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:18.0];
        
        cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.font = [UIFont fontWithName:@"Palatino" size:13.0];
    }
    
    // Identify the comment in question
    TDNComment *comment = [[TDNArticleManager sharedManager].currentArticle.comments objectAtIndex:indexPath.row];
    
    // Set the cell's content and return it
    cell.textLabel.text = comment.author;
    cell.detailTextLabel.text = comment.comment;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Identify the comment corresponding to this row
    TDNComment *comment = [[TDNArticleManager sharedManager].currentArticle.comments objectAtIndex:indexPath.row];
    
    // Create and configure a UILabel and use it to determine the size needed to display this row
    UILabel *sizingLabel = [[UILabel alloc] init];
    sizingLabel.lineBreakMode = NSLineBreakByWordWrapping;
    sizingLabel.numberOfLines = 0;
    sizingLabel.font = [UIFont fontWithName:@"Palatino" size:13.0];
    sizingLabel.text = comment.comment;

    CGSize desiredSize = [sizingLabel sizeThatFits:CGSizeMake(self.tableView.frame.size.width - 10, 0)];
    
    // Return the label's desired height, plus a bit more for padding/comment author names
    return desiredSize.height + 50;
}

@end
