//
//  TDNSectionViewController.m
//  Daily Nexus
//
//  Created by Aaron Dodson on 3/25/13.
//  Copyright (c) 2013 Daily Nexus. All rights reserved.
//

#import "TDNSectionViewController.h"

@interface TDNSectionViewController ()

@end

@implementation TDNSectionViewController

- (void)viewWillAppear:(BOOL)animated {
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoiseBackground"]];
    self.tableView.backgroundView = backgroundView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *sections = @[@"Feature", @"News", @"Sports", @"Opinion", @"Artsweek", @"On the Menu", @"Science & Tech", @"Online"];
    
    cell.textLabel.text = [sections objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Palatino" size:18.0];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
