//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Tweet.h"

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;

- (void)getHomeTimelineMaxID:(NSString *)maxID
                  completion:(void(^)(NSArray *tweets, NSError *error))completion;

- (void)getUserTimelineWithScreenName:(NSString *)screenName
                           completion:(void(^)(NSArray *tweets, NSError *error))completion;

- (void)getUserTimelineWithScreenName:(NSString *)screenName
                                maxID:(NSString *)maxID
                           completion:(void(^)(NSArray *tweets, NSError *error))completion;

- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion;

- (void)postStatusWithText:(NSString *)text
         inReplyToStatusID:(NSString *)inReplyToStatusID
                completion:(void (^)(Tweet *, NSError *))completion;

- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)getAccountWithCompletion:(void (^)(User *user, NSError *error))completion;

@end
