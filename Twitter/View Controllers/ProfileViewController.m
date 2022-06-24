//
//  ProfileViewController.m
//  twitter
//
//  Created by Megan Miller on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "DetailsViewController.h"
#import "User.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *backdropImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusesCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayOfTweets;
@property (strong, nonatomic) NSMutableArray *arrayOfNewTweets;
@property (nonatomic) BOOL isLoadingMoreData;

@property (nonatomic) CGFloat originalHeight;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.isLoadingMoreData = NO;
    
    if (self.user == nil) {
        [self getCurrentUser];
        NSLog(@"%@", self.user);
    }
    [self getTimeline];
    
    // configure label texts
    self.userNameLabel.text = self.user.name;
    self.userUsernameLabel.text = self.user.screenName;
    self.followingCountLabel.text = [NSString stringWithFormat:@"%d Following", self.user.followingCount];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%d Followers", self.user.followerCount];
    self.statusesCountLabel.text = [NSString stringWithFormat:@"%d Tweets", self.user.statusesCount];
    
    // configure image views
    NSString *profileURLString = self.user.profilePicture;
    NSURL *profileURL = [NSURL URLWithString:profileURLString];
    NSData *profileURLData = [NSData dataWithContentsOfURL:profileURL];
    self.userProfileImageView.image = [UIImage imageWithData:profileURLData];
    
    NSString *backdropURLString = self.user.bannerPicture;
    NSURL *backdropURL = [NSURL URLWithString:backdropURLString];
    NSData *backdropURLData = [NSData dataWithContentsOfURL:backdropURL];
    self.backdropImageView.image = [UIImage imageWithData:backdropURLData];
    self.backdropImageView.clipsToBounds = YES;
    self.originalHeight = self.backdropImageView.frame.size.height;
}

// MODIFIES: arrayOfTweets
// EFFECTS: Updates arrayOfTweets with the current user timeline, then reloads table and stops refreshing.
- (void)getTimeline {
    [[APIManager shared] getUserTimelineWithScreenName:self.user.screenName
                                            completion:^(NSArray *tweets, NSError *error) {
        self.arrayOfTweets = (NSMutableArray *)tweets;
        if (self.arrayOfTweets) {
            NSLog(@"😎😎😎 Successfully loaded user timeline");
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting user timeline: %@", error.localizedDescription);
        }
    }];
}

// MODIFIES: arrayOfNewTweets, arrayOfTweets, isLoadingMoreData, tableView
// EFFECTS: Loads more user tweets and appends to existing array, then reloads table.
- (void)continueTimelineSinceID:(NSString *)maxID {
    [[APIManager shared] getUserTimelineWithScreenName:self.user.screenName
                                                 maxID:maxID
                                            completion:^(NSArray *tweets, NSError *error){
        self.arrayOfNewTweets = (NSMutableArray *)tweets;
        if (self.arrayOfNewTweets) {
            NSLog(@"😎😎😎 Successfully loaded more user tweets");
            self.isLoadingMoreData = NO;
            [self.arrayOfTweets addObjectsFromArray:self.arrayOfNewTweets];
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error loading more user tweets: %@", error.localizedDescription);
        }
    }];
}

- (void)getCurrentUser {
    [[APIManager shared] getAccountWithCompletion:^(User *user, NSError *error){
        if (user) {
            NSLog(@"😎😎😎 Successfully loaded user account");
            self.user = user;
        } else {
            NSLog(@"😫😫😫 Error loading user account: %@", error.localizedDescription);
        }
    }];
}

// EFFECTS: Shows all loaded tweets.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

// MODIFIES: TweetCell tweet
// EFFECTS: Configures and returns reusable TweetCell.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.arrayOfTweets[indexPath.row];
    [cell refreshData];
    return cell;
}

// MODIFIES: isLoadingMoreData
// EFFECTS: If at end of timeline and not already loading data, sends request for the next 20 tweets.
- (void)tableView:(UITableView *)tableView willDisplayCell:(TweetCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tweet == [self.arrayOfTweets lastObject] && !self.isLoadingMoreData) {
        self.isLoadingMoreData = YES;
        [self continueTimelineSinceID:cell.tweet.idStr];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *myIndexPath = [self.tableView indexPathForCell:sender];
    Tweet *tweet = self.arrayOfTweets[myIndexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.tweet = tweet;
}

@end
