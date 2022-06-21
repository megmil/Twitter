//
//  TweetCell.m
//  twitter
//
//  Created by Megan Miller on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshData {
    // configure labels
    self.authorLabel.text = self.tweet.user.name;
    self.usernameLabel.text = self.tweet.user.screenName;
    self.dateLabel.text = self.tweet.createdAtString;
    self.tweetLabel.text = self.tweet.text;
    
    // configure button titles
    [self.replyButton setTitle:@"" forState:UIControlStateNormal];
    [self.messageButton setTitle:@"" forState:UIControlStateNormal];
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
    [self.profileImageView setImageWithURL:url];
}

- (IBAction)didTapFavorite:(id)sender {
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    [self refreshData];
    
    // TODO: Send a POST request to the POST favorites/create endpoint
     [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
         if(error){
              NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
         }
         else{
             NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
         }
     }];
}

@end
