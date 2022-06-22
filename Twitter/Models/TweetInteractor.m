//
//  TweetInteractor.m
//  twitter
//
//  Created by Megan Miller on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetInteractor.h"
#import "Tweet.h"
#import "APIManager.h"

@implementation TweetInteractor

+ (void)interactWithTweetFavorites:(Tweet *)tweet
                      isFavoriting:(BOOL)isFavoriting {
    
    tweet.favorited = isFavoriting;
    tweet.favoriteCount += (tweet.favorited ? 1 : -1);
    
    if (isFavoriting) {
        [[APIManager shared] favorite:tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
                 tweet.favorited = !isFavoriting;
                 tweet.favoriteCount += (tweet.favorited ? 1 : -1);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
        }];
    } else {
        [[APIManager shared] unfavorite:tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
                 tweet.favorited = !isFavoriting;
                 tweet.favoriteCount += (tweet.favorited ? 1 : -1);
             }
             else{
                 NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
             }
        }];
    }
}

+ (void)interactWithRetweets:(Tweet *)tweet isRetweeting:(BOOL)isRetweeting {
    
    tweet.retweeted = isRetweeting;
    tweet.retweetCount += (tweet.retweeted ? 1 : -1);
    
    if (isRetweeting) {
        [[APIManager shared] retweet:tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
                 tweet.retweeted = !isRetweeting;
                 tweet.retweetCount += (tweet.retweeted ? 1 : -1);
             }
             else{
                 NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
             }
        }];
    } else {
        [[APIManager shared] unretweet:tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
                 tweet.retweeted = !isRetweeting;
                 tweet.retweetCount += (tweet.retweeted ? 1 : -1);
             }
             else{
                 NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
             }
        }];
    }
}

@end
