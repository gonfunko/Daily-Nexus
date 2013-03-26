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
@property (retain) NSArray *cellSizes;
@property (retain) UIView *loadingView;

@end

@implementation TDNFrontPageViewController

@synthesize tableView;
@synthesize collectionView;
@synthesize loadingView;
@synthesize cellSizes;

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
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.scrollEnabled = NO;
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sections"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self.parentViewController.parentViewController
                                                                            action:@selector(toggleLeftDrawer)];
    
    self.loadingView = [[TDNLoadingView alloc] initWithFrame:self.view.frame];
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.loadingView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadData];
}

- (void)articleManagerDidFinishLoading {
    // When the article manager finishes downloading, we load images and update the list of articles
    [self.loadingView removeFromSuperview];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.tableView.scrollEnabled = YES;
    }
    
    [self loadImages];
    [self generateCellSizes];
    [self reloadData];
}

- (void)reloadData {
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
                        [self reloadData];
                    }
                }
            }];
        }
    }
}

- (void)generateCellSizes {
    NSMutableArray *sizes = [[NSMutableArray alloc] init];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        NSInteger itemWidth = 256;
        
        // Depending on our orientation, we want to show either two or three stories per row. These
        // dimensions are chosen so that that will happen
        if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
            itemWidth = 340;
        } else {
            itemWidth = 380;
        }
        
        for (int i = 0; i < [[[TDNArticleManager sharedManager] currentArticles] count]; i++) {
            // To figure out the size for a given item, we actually create and configure the corresponding cell to get its size metrics.
            TDNArticle *article = [[[TDNArticleManager sharedManager] currentArticles] objectAtIndex:i];
            TDNArticleCollectionViewCell *cell = [[TDNArticleCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, itemWidth, 0)];
            
            // Set the cell's text
            cell.title.text = article.title;
            cell.byline.text = [article byline];
            cell.story.text = article.story;
            
            // If we have an image, add it to the cell
            if ([article.images count] != 0) {
                cell.imageView.image = [article.images lastObject];
            }
            
            // Determine the cell's desired size and cache it
            [cell layoutIfNeeded];
            [sizes addObject:[NSValue valueWithCGSize:[cell sizeThatFits:CGSizeZero]]];
        }
    }
    
    self.cellSizes = sizes;
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
        cell = [[TDNEtchedSeparatorTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        // Configure the appearance of the cell's subviews
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        cell.textLabel.highlightedTextColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        cell.textLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:18.0];
        
        cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        cell.detailTextLabel.highlightedTextColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        cell.detailTextLabel.numberOfLines = 3;
        cell.detailTextLabel.font = [UIFont fontWithName:@"Palatino" size:13.0];
        
        // Round the corners of the image
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = 10.0;
        cell.imageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        cell.imageView.layer.shouldRasterize = YES;
        
        // And add a disclosure triangle to the cell
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        cell.selectedBackgroundView = selectedBackgroundView;
    }
    
    // Set the main text of the cell to the article title
    cell.textLabel.text = article.title;
            
    // Set the cell's detail text to the first few lines of the article
    cell.detailTextLabel.text = article.story;
   
    // If the article has any images, add the first one to the cell
    if ([article.images count] != 0) {
        cell.imageView.image = [[article.images objectAtIndex:0] imageByScalingAndCroppingForSize:CGSizeMake(70, 70)];
    } else {
        // If we don't have any images, set it to nil in case this cell is being reused
        cell.imageView.image = nil;
    }
        
           
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Create an article view controller, set its article to the one that was selected, and present it
    TDNArticleViewController *articleViewController = [[TDNArticleViewController alloc] initWithNibName:@"TDNArticleViewController" bundle:[NSBundle mainBundle]];
    articleViewController.article = [[[TDNArticleManager sharedManager] currentArticles] objectAtIndex:indexPath.row];
    articleViewController.columnated = NO;
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
    
    if ([article.images count] != 0) {
        cell.imageView.image = [article.images lastObject];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.cellSizes count]) {
        return [[self.cellSizes objectAtIndex:indexPath.row] CGSizeValue];
    } else {
        return CGSizeMake(256, 256);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Create an article view controller, set its article to the one that was selected, and present it
    TDNArticleViewController *articleViewController = [[TDNArticleViewController alloc] initWithNibName:@"TDNArticleViewController" bundle:[NSBundle mainBundle]];
    articleViewController.article = [[[TDNArticleManager sharedManager] currentArticles] objectAtIndex:indexPath.row];
    articleViewController.columnated = YES;
    [self.navigationController pushViewController:articleViewController animated:YES];
    
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self generateCellSizes];
    // When we rotate, update the collection view so it uses the appropriate size cells
    [self.collectionView performBatchUpdates:nil completion:nil];
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
