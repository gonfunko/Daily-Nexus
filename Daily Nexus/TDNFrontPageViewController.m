//
//  TDNFrontPageViewController.m
//  Daily Nexus
//
//  TDNFrontPageViewController is responsible for managing the "front page" view that the user first
//  sees when launching the app and providing data and cells to the collection view that displays stories
//

#import "TDNFrontPageViewController.h"

@implementation TDNFrontPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Draw the noise texture behind the list of articles
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoiseBackground"]];
    self.tableView.backgroundView = backgroundView;
    
    // Download the latest articles
    [TDNArticleManager sharedManager].delegate = self;
    [[TDNArticleManager sharedManager] loadAllArticles];
    
    self.title = @"The Daily Nexus";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Articles"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
    
    self.tableView.rowHeight = 80;
}

- (void)articleManagerDidFinishLoading {
    // When the article manager finishes downloading, we load images and update the list of articles
    [self loadImages];
    [self.tableView reloadData];
}

- (void)loadImages {
    // Iterate through every image URL in every article...
    for (TDNArticle *article in [[TDNArticleManager sharedManager] currentArticles]) {
        for (NSString *urlString in article.imageURLs) {
            // Set up a request and try to download the image
            NSURL *imageURL = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                // When the download completes, this block is called. Check to make sure we actually got data in response...
                if (data) {
                    // Assuming we did, try to create an image from it and make sure we succeed
                    UIImage *image = [UIImage imageWithData:data];
                    if (image) {
                        // If so, add the image to the article object and reload the table to show it
                        [article.images addObject:image];
                        [self.tableView reloadData];
                    }
                }
            }];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[TDNArticleManager sharedManager] currentArticles] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Identify the article corresponding to this row in the table
    TDNArticle *article = [[[TDNArticleManager sharedManager] currentArticles] objectAtIndex:indexPath.row];
    
    // Get a cell, either by dequeueing a reusable one or allocing a new one
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    // Depending on whether we're on an iPhone/iPod touch or iPad, we want to configure the cell differently...
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        // Set the main text of the cell to the article title and configure the font and colors
        cell.textLabel.text = article.title;
        cell.textLabel.textColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
        cell.textLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:18.0];
        
        // Set the cell's detail text to the first few lines of the article
        cell.detailTextLabel.text = article.story;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.detailTextLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
        cell.detailTextLabel.numberOfLines = 3;
        cell.detailTextLabel.font = [UIFont fontWithName:@"Palatino" size:13.0];

        // If the article has any images, add the first one to the cell
        if ([article.images count] != 0) {
            // We want the image to be square, so draw the image into a square graphics context and use the resulting image
            CGSize size = CGSizeMake(70, 70);
            
            UIGraphicsBeginImageContext(size);
            [[article.images objectAtIndex:0] drawInRect:CGRectMake(0, 0, size.width, size.height)];
            UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            cell.imageView.image = scaledImage;
        } else {
            // If we don't have any images, set it to nil in case this cell is being reused
            cell.imageView.image = nil;
        }
        
        // Round the corners of the image
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = 10.0;
        
        // And add a disclosure triangle to the cell
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Create an article view controller, set its article to the one that was selected, and present it
    TDNArticleViewController *articleViewController = [[TDNArticleViewController alloc] initWithNibName:@"TDNArticleViewController" bundle:[NSBundle mainBundle]];
    articleViewController.article = [[[TDNArticleManager sharedManager] currentArticles] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:articleViewController animated:YES];
}

- (void)dealloc {
    [TDNArticleManager sharedManager].delegate = nil;
}

@end
