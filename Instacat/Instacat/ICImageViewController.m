//
//  ICImageViewController.m
//  Instacat
//
//  Created by Manik Kalra on 30/04/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import "ICImageViewController.h"

@interface ICImageViewController ()

@end

@implementation ICImageViewController

-(instancetype)initWithImage:(ICImage *)image {
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        self.image = image;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:UITableViewCell.class
           forCellReuseIdentifier:@"Cell"];
    
    self.title = @"Likes and Comments";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return self.image.likes.count;
    }
    else return self.image.comments.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section == 0) {
        for (int i = 0; i < self.image.likes.count; i++) {
            if (indexPath.row == i) {
                ICLike *temp = [self.image.likes objectAtIndex:i];
                cell.textLabel.text = temp.handle;
            }
        }
    }
    else if (indexPath.section == 1) {
        for (int i = 0; i < self.image.comments.count; i++) {
            if (indexPath.row == i) {
                ICComment *temp = [self.image.comments objectAtIndex:i];
                cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", temp.handle, temp.text];
            }
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Likes";
    }
    else
        return @"Comments";
}

- (void)refresh:(UIRefreshControl *)sender {
    [ICAPIClient.sharedInstance image:self.image.uuid success:^(ICImage *image) {
        if (image) {
            self.image = image;
            [self.tableView reloadData];
        }
        
        [super refresh:sender];
    }];
}

@end
