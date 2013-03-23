//
//  TDNFrontPageViewController.m
//  Daily Nexus
//
//  TDNFrontPageViewController is responsible for managing the "front page" view that the user first
//  sees when launching the app and providing data and cells to the collection view that displays stories
//

#import "TDNFrontPageViewController.h"

@interface TDNFrontPageViewController ()

@property (retain) NSMutableDictionary *images;

@end

@implementation TDNFrontPageViewController

@synthesize images;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoiseBackground"]];
    self.tableView.backgroundView = backgroundView;
    
    [TDNArticleManager sharedManager].delegate = self;
    [[TDNArticleManager sharedManager] loadAllArticles];
    
    self.title = @"The Daily Nexus";
    
    self.images = [[NSMutableDictionary alloc] init];
    self.tableView = (UITableView *)self.view;
    self.tableView.rowHeight = 80;
}

- (void)articleManagerDidFinishLoading {
    [self loadImages];
    [self.tableView reloadData];
}

- (void)loadImages {
    for (TDNArticle *article in [[TDNArticleManager sharedManager] currentArticles]) {
        for (NSString *urlString in article.images) {
            NSURL *imageURL = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (data) {
                    UIImage *image = [UIImage imageWithData:data];
                    if (image) {
                        [self.images setObject:image forKey:urlString];
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
    TDNArticle *article = [[[TDNArticleManager sharedManager] currentArticles] objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        cell.textLabel.text = article.title;
        cell.textLabel.textColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
        cell.detailTextLabel.text = article.story;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.detailTextLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
        cell.detailTextLabel.numberOfLines = 3;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];

        if ([article.images count] != 0) {
            CGSize size = CGSizeMake(70, 70);
            
            UIGraphicsBeginImageContext(size);
            [[self.images objectForKey:[article.images objectAtIndex:0]] drawInRect:CGRectMake(0, 0, size.width, size.height)];
            UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            cell.imageView.image = scaledImage;
        } else {
            cell.imageView.image = nil;
        }
        
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = 10.0;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
    }
    
    return cell;
}

- (void)dealloc {
    [TDNArticleManager sharedManager].delegate = nil;
}

@end
