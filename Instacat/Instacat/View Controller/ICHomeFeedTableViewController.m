//
//  ICHomeFeedTableViewController.m
//  Instacat
//
//  Created by Alec Gorge on 4/16/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import "ICHomeFeedTableViewController.h"
#import "ICImageViewController.h"

#import <PWProgressView/PWProgressView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <CRToast/CRToast.h>
#import <REComposeViewController/REComposeViewController.h>

typedef NS_ENUM(NSInteger, ICHomeFeedRows) {
    ICHomeFeedImageRow,
    ICHomeFeedLikesAndCommentRow,
    ICHomeFeedRowCount,
};

@interface ICHomeFeedTableViewController ()

@property NSArray *images;
@property CGSize imageSize;

@end

@implementation ICHomeFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Instacat";
    self.images = @[];
    self.imageSize = CGSizeMake(self.tableView.bounds.size.width, self.tableView.bounds.size.width);
    
    [self.tableView registerClass:UITableViewCell.class
           forCellReuseIdentifier:@"image"];
    [self.tableView registerClass:UITableViewCell.class
           forCellReuseIdentifier:@"cell"];
    
    self.tableView.separatorColor = UIColor.clearColor;
}

- (void)viewDidAppear:(BOOL)animated {
    if(ICGateway.sharedInstance.isSignedIn) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(signOut)];
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)signOut {
    self.navigationItem.rightBarButtonItem = nil;
    [ICGateway.sharedInstance signOut];
}

- (void)refresh:(UIRefreshControl *)sender {
    [ICAPIClient.sharedInstance images:^(NSArray *images) {
        if(images) {
            self.images = images;
            [self.tableView reloadData];
        }
        
        [super refresh:sender];
    }];
}

- (void)likeImage:(UIButton*)button {
    // tag is set to the section number of the table in cellForRowAtIndexPath
    ICImage *image = self.images[button.tag];
    
    if (image.isLikedLocally == YES) {
        return;
    }
    
    image.isLikedLocally = YES;

    [ICAPIClient.sharedInstance likeImage:image
                                  success:^(NSError *err) {
                                      if(err) {
                                          [CRToastManager showNotificationWithOptions:@{
                                                                                        kCRToastNotificationTypeKey             : @(CRToastTypeNavigationBar),
                                                                                        kCRToastBackgroundColorKey              : UIColor.redColor,
                                                                                        kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                                                                                        kCRToastUnderStatusBarKey               : @(YES),
                                                                                        kCRToastTextKey                         : err.localizedDescription,
                                                                                        kCRToastTimeIntervalKey                 : @(5)
                                                                                        }
                                                                      completionBlock:^{
                                                                          
                                                                      }];

                                      }
                                  }];
    
    [self.tableView reloadData];
    
}

- (void)commentImage:(UIButton*)button {
    // tag is set to the section number of the table in cellForRowAtIndexPath
    ICImage *image = self.images[button.tag];
    REComposeViewController *composeViewController = [[REComposeViewController alloc] init];
    composeViewController.title = @"Comment";
    composeViewController.hasAttachment = NO;
    composeViewController.attachmentImage = nil;
    [composeViewController presentFromRootViewController];
    
    // handle the comment
    composeViewController.completionHandler = ^(REComposeViewController *composeViewController, REComposeResult result) {
        [composeViewController dismissViewControllerAnimated:YES completion:nil];
        
        if (result == REComposeResultPosted) {
            [ICAPIClient.sharedInstance commentOnImage:image
                                               comment:composeViewController.text
                                               success:^(NSError *err) {
                                                   if(err) {
                                                       [CRToastManager showNotificationWithOptions:@{
                                                                                                     kCRToastNotificationTypeKey             : @(CRToastTypeNavigationBar),
                                                                                                     kCRToastBackgroundColorKey              : UIColor.redColor,
                                                                                                     kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                                                                                                     kCRToastUnderStatusBarKey               : @(YES),
                                                                                                     kCRToastTextKey                         : err.localizedDescription,
                                                                                                     kCRToastTimeIntervalKey                 : @(5)
                                                                                                     }
                                                                                   completionBlock:^{
                                                                                       
                                                                                   }];
                                                       
                                                   }
                                               }];
            image.isCommentedLocally = YES;
            [self.tableView reloadData];
            
        }
    };
   }

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.images.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return ICHomeFeedRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICImage *image = self.images[indexPath.section];
    NSInteger row = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:row == ICHomeFeedImageRow ? @"image" : @"cell"
                                                            forIndexPath:indexPath];
    
    if (row == ICHomeFeedImageRow) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.imageSize.width, self.imageSize.height)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        
        PWProgressView *prog = [[PWProgressView alloc] initWithFrame:imgView.bounds];
        prog.alpha = 0;
        
        [imgView addSubview:prog];
        
        [imgView setImageWithURL:image.imageURL
                placeholderImage:nil
                         options:0
                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            prog.alpha = 1;
                            prog.progress = (float) receivedSize / (float) expectedSize;
                        }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                           if(error) {
                               dbug(@"err: %@", error);
                           }
                           
                           [UIView animateWithDuration:0.1
                                            animations:^{
                                                prog.alpha = 0;
                                            }
                                            completion:^(BOOL finished) {
                                                [prog removeFromSuperview];
                                            }];
                       }];
        
        cell.contentView.clipsToBounds = YES;
        [cell.contentView addSubview:imgView];
    }
    else if(row == ICHomeFeedLikesAndCommentRow) {
        cell.textLabel.text = [NSString stringWithFormat:@"%lu likes, %lu comments", (unsigned long)image.likes.count + image.isLikedLocally, (unsigned long)image.comments.count + image.isCommentedLocally];
        cell.textLabel.textColor = IC_TEXT_COLOR;
        cell.textLabel.font = [UIFont systemFontOfSize:IC_TEXT_SIZE];
        cell.userInteractionEnabled = YES;
        
        UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [likeButton setImage:[UIImage imageNamed:@"glyphicons_343_thumbs_up"]
                    forState:UIControlStateNormal];
        [commentButton setImage:[UIImage imageNamed:@"glyphicons_309_comments"]
                       forState:UIControlStateNormal];
        
        commentButton.tag = likeButton.tag = indexPath.section;
        commentButton.contentMode = likeButton.contentMode = UIViewContentModeCenter;
        
        [likeButton addTarget:self
                       action:@selector(likeImage:)
             forControlEvents:UIControlEventTouchUpInside];
        [commentButton addTarget:self
                          action:@selector(commentImage:)
                forControlEvents:UIControlEventTouchUpInside];
        
        int buttonSize = 44;
        int spacing = 2 * buttonSize / 2;
        
        likeButton.frame = CGRectMake(0, 0, buttonSize, buttonSize);
        commentButton.frame = CGRectMake(spacing, 0, buttonSize, buttonSize);
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonSize * 2, buttonSize)];
        [container addSubview:likeButton];
        [container addSubview:commentButton];
        
        [container sizeToFit];
        
        cell.accessoryView = container;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    ICImage *image = self.images[section];
    
    return image.user.handle;
}

- (UIView*)tableView:(UITableView*)tableView
viewForHeaderInSection:(NSInteger)section {
    UIView* view = [[UIView alloc] init];
    UILabel* label = [[UILabel alloc] init];
    
    view.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.8];
    
    label.text = [self tableView: tableView titleForHeaderInSection: section];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = IC_TEXT_COLOR;
    label.font = [UIFont systemFontOfSize:IC_TEXT_SIZE];
    
    [label sizeToFit];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [view addSubview:label];
    
    [view addConstraints:
     @[[NSLayoutConstraint constraintWithItem:label
                                    attribute:NSLayoutAttributeCenterX
                                    relatedBy:NSLayoutRelationEqual
                                       toItem:view
                                    attribute:NSLayoutAttributeCenterX
                                   multiplier:1 constant:0],
       [NSLayoutConstraint constraintWithItem:label
                                    attribute:NSLayoutAttributeCenterY
                                    relatedBy:NSLayoutRelationEqual
                                       toItem:view
                                    attribute:NSLayoutAttributeCenterY
                                   multiplier:1 constant:0],
       [NSLayoutConstraint constraintWithItem:label
                                    attribute:NSLayoutAttributeLeading
                                    relatedBy:NSLayoutRelationEqual
                                       toItem:view
                                    attribute:NSLayoutAttributeLeft
                                   multiplier:0 constant:15],
       ]];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == ICHomeFeedImageRow) {
        return self.imageSize.height;
    }
    
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ICImage *image = self.images[indexPath.section];
    ICImageViewController *imageController = [[ICImageViewController alloc] initWithImage:image];
    [self.navigationController pushViewController:imageController animated:YES];
}

@end
