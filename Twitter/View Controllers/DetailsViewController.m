//
//  DetailsViewController.m
//  twitter
//
//  Created by Megan Miller on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#include "APIManager.h"
#include "TweetInteractor.h"
#include "ProfileViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshData];
    
    // configure tap gesture
    UITapGestureRecognizer *tapProfileImageView = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(didTapProfile:)];
    [self.profileImageView addGestureRecognizer:tapProfileImageView];
}

- (void)refreshData {
    // configure labels
    self.authorLabel.text = self.tweet.user.name;
    self.usernameLabel.text = self.tweet.user.screenName;
    self.dateLabel.text = self.tweet.createdAtString;
    self.tweetLabel.text = self.tweet.text;
    
    // configure button titles
    [self.replyButton setTitle:@"" forState:UIControlStateNormal];
    [self.retweetButton setTitle:@(self.tweet.retweetCount).stringValue forState:UIControlStateNormal];
    [self.favoriteButton setTitle:@(self.tweet.favoriteCount).stringValue forState:UIControlStateNormal];
    
    // configure button colors
    UIImage *retweetImage = [UIImage imageNamed:@"retweet-icon"];
    UIImage *favoriteImage = [UIImage imageNamed:@"favor-icon"];
    
    if (self.tweet.retweeted) {
        retweetImage = [UIImage imageNamed:@"retweet-icon-green"];
    }
    if (self.tweet.favorited) {
        favoriteImage = [UIImage imageNamed:@"favor-icon-red"];
    }
    
    [self.retweetButton setImage:retweetImage forState:UIControlStateNormal];
    [self.favoriteButton setImage:favoriteImage forState:UIControlStateNormal];
    
    // configure profileImageView
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profileImageView.image = [UIImage imageWithData:urlData];
}

- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted) {
        [TweetInteractor interactWithRetweets:self.tweet isRetweeting:NO];
    } else {
        [TweetInteractor interactWithRetweets:self.tweet isRetweeting:YES];
    }
    [self refreshData];
}

- (IBAction)didTapFavorite:(id)sender {
    if (self.tweet.favorited) {
        [TweetInteractor interactWithTweetFavorites:self.tweet isFavoriting:NO];
    } else {
        [TweetInteractor interactWithTweetFavorites:self.tweet isFavoriting:YES];
    }
    [self refreshData];
}

- (void)didTapProfile:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"profileSegue" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ProfileViewController *profileVC = [segue destinationViewController];
    profileVC.user = self.tweet.user;
}

@end
