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
@property (retain) UIView *loadingView;

@end

@implementation TDNFrontPageViewController

@synthesize tableView;
@synthesize collectionView;
@synthesize loadingView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Draw the noise texture behind the list of articles
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoiseBackground"]];
    backgroundView.contentMode = UIViewContentModeCenter;
    
    // Download the latest articles
    [TDNArticleManager sharedManager].delegate = self;
    [[TDNArticleManager sharedManager] loadArticlesInSection:@""];
    
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
    
    // Create the button to display the navigation drawer
    UIButton *navigationButton = [[UIButton alloc] init];
    [navigationButton setImage:[UIImage imageNamed:@"sidebar"] forState:UIControlStateNormal];
    [navigationButton addTarget:self.parentViewController.parentViewController
                         action:@selector(toggleLeftDrawer)
               forControlEvents:UIControlEventTouchUpInside];
    navigationButton.frame = CGRectMake(0, 0, 50, 44);
    
    // ...and add it to the navigation bar
    UIBarButtonItem *navigationBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navigationButton];
    self.navigationItem.leftBarButtonItem = navigationBarButtonItem;
    
    self.loadingView = [[TDNLoadingView alloc] initWithFrame:self.view.frame];
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.loadingView];
    
    // Listen for changes to the selected article category so we can load the appropriate articles
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeSection:)
                                                 name:@"TDNSectionChangedNotification"
                                               object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadData];
}

- (void)articleManagerDidStartLoading {
    self.loadingView.frame = self.view.frame;
    [self.view addSubview:self.loadingView];
}

- (void)articleManagerDidFinishLoading {
    // When the article manager finishes downloading, we load images and update the list of articles
    [self.loadingView removeFromSuperview];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.tableView.scrollEnabled = YES;
    }
    
    [self loadImages];
    [self reloadData];
}

- (void)reloadData {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [self.tableView reloadData];
    } else {
        [self.collectionView reloadData];
    }
}

- (void)changeSection:(NSNotification *)notification {
    NSString *section = notification.object;
    
    [[TDNArticleManager sharedManager] removeAllArticles];
    [self reloadData];
    [[TDNArticleManager sharedManager] loadArticlesInSection:section];
}

- (void)loadImages {
    // Iterate through every image URL in every article...
    for (TDNArticle *article in [TDNArticleManager sharedManager].articles) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[TDNArticleManager sharedManager].articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Identify the article corresponding to this row in the table
    TDNArticle *article = [[TDNArticleManager sharedManager].articles objectAtIndex:indexPath.row];
    
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
        
        // And add a disclosure triangle to the cell using an image so it doesn't turn white when selected
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chevron"]];
        
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
    articleViewController.article = [[TDNArticleManager sharedManager].articles objectAtIndex:indexPath.row];
    articleViewController.columnated = NO;
    [self.navigationController pushViewController:articleViewController animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[TDNArticleManager sharedManager].articles count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Determine the article in question
    TDNArticle *article = [[TDNArticleManager sharedManager].articles objectAtIndex:indexPath.row];
    
    // Get a cell from the collection view
    TDNArticleCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure it to reflect the article's contents
    cell.title.text = article.title;
    cell.byline.text = [article byline];
    cell.story.text = article.story;
    
    if ([article.images count] != 0) {
        cell.imageView.image = [article.images lastObject];
    }
    
    // Resize the cell's subviews to fit their contents
    [cell setNeedsLayout];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        return CGSizeMake(340, 420);
    } else {
        return CGSizeMake(380, 460);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Create an article view controller, set its article to the one that was selected, and present it
    TDNArticleViewController *articleViewController = [[TDNArticleViewController alloc] initWithNibName:@"TDNArticleViewController" bundle:[NSBundle mainBundle]];
    articleViewController.article = [[TDNArticleManager sharedManager].articles objectAtIndex:indexPath.row];
    articleViewController.columnated = YES;
    [self.navigationController pushViewController:articleViewController animated:YES];
    
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
