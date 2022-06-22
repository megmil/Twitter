//
//  TweetInteractor.h
//  twitter
//
//  Created by Megan Miller on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetInteractor : NSObject

+ (void)interactWithTweetFavorites:(Tweet *)tweet isFavoriting:(BOOL)isFavoriting;

+ (void)interactWithRetweets:(Tweet *)tweet isRetweeting:(BOOL)isRetweeting;

@end

NS_ASSUME_NONNULL_END
