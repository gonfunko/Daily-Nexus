//
//  TDNFrontPageViewController.m
//  Daily Nexus
//
//  TDNFrontPageViewController is responsible for managing the "front page" view that the user first
//  sees when launching the app and providing data and cells to the collection or table view that displays stories
//

#import "TDNFrontPageViewController.h"

@interface TDNFrontPageViewController ()

@property (retain) UITableView *tableView;
@property (retain) UICollectionView *collectionView;

@end

@implementation TDNFrontPageViewController

@synthesize tableView;
@synthesize collectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Draw the noise texture behind the list of articles
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoiseBackground"]];
    
    // Download the latest articles
    [TDNArticleManager sharedManager].delegate = self;
    [[TDNArticleManager sharedManager] loadAllArticles];
    
    self.title = @"The Daily Nexus";
    
    // Depending on whether we're running on an iPhone or iPad, configure the table or collection view, respectively
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.tableView = (UITableView *)self.view;
        self.tableView.rowHeight = 80;
        self.tableView.backgroundView = backgroundView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    } else {
        self.collectionView = (UICollectionView *)self.view;
        self.collectionView.backgroundView = backgroundView;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        // Register our collection view cell with the collection view so we can dequeue instances of it
        [self.collectionView registerClass:[TDNArticleCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    
    // Specify the back button that will be used when we push a view controller on the stack
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Articles"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
}

- (void)articleManagerDidFinishLoading {
    // When the article manager finishes downloading, we load images and update the list of articles
    [self loadImages];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [self.tableView reloadData];
    } else {
        [self.collectionView reloadData];
    }
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
                        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
                            [self.tableView reloadData];
                        } else {
                            [self.collectionView reloadData];
                        }
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
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[TDNArticleManager sharedManager] currentArticles] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Determine the article in question
    TDNArticle *article = [[[TDNArticleManager sharedManager] currentArticles] objectAtIndex:indexPath.row];
    
    // Get a cell from the collection view
    TDNArticleCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure it to reflect the article's contents
    cell.title.text = article.title;
    cell.byline.text = [article byline];
    cell.story.text = article.story;
    
    // Determine the needed size and resize the cell
    [cell layoutIfNeeded];
    [cell setFrame:CGRectMake(0, 0, [cell sizeThatFits:CGSizeZero].width, [cell sizeThatFits:CGSizeZero].height)];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    /* To figure out the size for a given item, we actually create and configure the corresponding cell to get its size metrics.
       This isn't terribly efficient and should probably be replaced with something better (or cached), but it works for now */
    TDNArticle *article = [[[TDNArticleManager sharedManager] currentArticles] objectAtIndex:indexPath.row];
    TDNArticleCollectionViewCell *cell = [[TDNArticleCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 256, 0)];
    
    cell.title.text = article.title;
    cell.byline.text = [article byline];
    cell.story.text = article.story;
    
    [cell layoutIfNeeded];
    
    return [cell sizeThatFits:CGSizeZero];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Create an article view controller, set its article to the one that was selected, and present it
    TDNMultiColumnArticleViewController *articleViewController = [[TDNMultiColumnArticleViewController alloc] initWithNibName:@"TDNMultiColumnArticleViewController" bundle:[NSBundle mainBundle]];
    articleViewController.article = [[[TDNArticleManager sharedManager] currentArticles] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:articleViewController animated:YES];
    
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)dealloc {
    [TDNArticleManager sharedManager].delegate = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.tableView.delegate = nil;
        self.tableView.dataSource = nil;
    } else {
        self.collectionView.delegate = nil;
        self.collectionView.dataSource = nil;
    }
}

@end
