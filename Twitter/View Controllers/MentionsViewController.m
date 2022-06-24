//
//  MentionsViewController.m
//  twitter
//
//  Created by Megan Miller on 6/24/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "MentionsViewController.h"
#import "APIManager.h"
#import "TweetCell.h"

@interface MentionsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayOfTweets;
@property (strong, nonatomic) NSMutableArray *arrayOfNewTweets;
@property (nonatomic) BOOL isLoadingMoreData;

@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.isLoadingMoreData = NO;
    
    [self getMentions];
    
    // configure refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getMentions) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView addSubview:self.refreshControl];
}

// MODIFIES: arrayOfTweets, tableView, refreshControl
// EFFECTS: Updates arrayOfTweets with the current timeline, then reloads table and stops refreshing.
- (void)getMentions {
    [[APIManager shared] getMentionsWithCompletion:^(NSArray *tweets, NSError *error) {
        self.arrayOfTweets = (NSMutableArray *)tweets;
        if (self.arrayOfTweets) {
            NSLog(@"😎😎😎 Successfully loaded mentions");
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting mentions: %@", error.localizedDescription);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
