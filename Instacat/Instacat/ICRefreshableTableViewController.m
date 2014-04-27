//
//  ICRefreshableTableViewController.m
//  Instacat
//
//  Created by Alec Gorge on 4/26/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import "ICRefreshableTableViewController.h"

@interface ICRefreshableTableViewController ()

@end

@implementation ICRefreshableTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	UIRefreshControl *c = [[UIRefreshControl alloc] init];
	[c addTarget:self
		  action:@selector(refresh:)
forControlEvents:UIControlEventValueChanged];
	self.refreshControl = c;
	[self beginRefreshingTableView];
    
	[self refresh: self.refreshControl];
}

- (void)refresh:(UIRefreshControl *)sender {
	[sender endRefreshing];
}

- (void)beginRefreshingTableView {
    if (self.tableView.contentOffset.y == 0) {
        self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
        [self.refreshControl beginRefreshing];
        return;
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^(void){
                             self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             
                         }];
        
    }
}


@end
