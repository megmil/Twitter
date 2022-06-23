//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"
#import "ProfileViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *composeButton;

@property (strong, nonatomic) NSMutableArray *arrayOfTweets;
@property (strong, nonatomic) NSMutableArray *arrayOfNewTweets;
@property (nonatomic) BOOL isLoadingMoreData;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.isLoadingMoreData = NO;
    [self.composeButton setTitle:@"" forState:UIControlStateNormal];
    
    [self getTimeline];
    
    // configure refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getTimeline) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView addSubview:self.refreshControl];
}

// MODIFIES: arrayOfTweets, tableView, refreshControl
// EFFECTS: Updates arrayOfTweets with the current timeline, then reloads table and stops refreshing.
- (void)getTimeline {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        self.arrayOfTweets = (NSMutableArray *)tweets;
        if (self.arrayOfTweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
}

// MODIFIES: arrayOfNewTweets, arrayOfTweets, isLoadingMoreData, tableView
// EFFECTS: Loads new tweets and appends to existing array, then reloads table.
- (void)continueTimelineSinceID:(NSString *)maxID {
    [[APIManager shared] getHomeTimelineMaxID:maxID
                                   completion:^(NSArray *tweets, NSError *error) {
        self.arrayOfNewTweets = (NSMutableArray *)tweets;
        if (self.arrayOfNewTweets) {
            NSLog(@"😎😎😎 Successfully loaded more tweets");
            self.isLoadingMoreData = NO;
            [self.arrayOfTweets addObjectsFromArray:self.arrayOfNewTweets];
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error loading more tweets: %@", error.localizedDescription);
        }
    }];
}

// EFFECTS: Shows all loaded tweets.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

// MODIFIES: TweetCell.tweet
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

// EFFECTS: Returns to login screen.
- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (void)didTweet:(Tweet *)tweet {
    [self getTimeline];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"composeSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeVC = (ComposeViewController*)navigationController.topViewController;
        composeVC.isReply = NO;
        composeVC.delegate = self;
    } else if ([segue.identifier  isEqual: @"detailsSegue"]) {
        NSIndexPath *myIndexPath = [self.tableView indexPathForCell:sender];
        Tweet *tweet = self.arrayOfTweets[myIndexPath.row];
        DetailsViewController *detailVC = [segue destinationViewController];
        detailVC.tweet = tweet;
    } else {
        NSIndexPath *myIndexPath = [self.tableView indexPathForCell:sender];
        Tweet *tweet = self.arrayOfTweets[myIndexPath.row];
        ProfileViewController *profileVC = [segue destinationViewController];
        profileVC.user = tweet.user;
    }
}

@end
