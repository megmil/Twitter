//
//  User.m
//  twitter
//
//  Created by Megan Miller on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePicture = dictionary[@"profile_image_url_https"];
        self.bannerPicture = dictionary[@"profile_banner_url"];
        self.tagline = dictionary[@"description"];
        self.statusesCount = [dictionary[@"statuses_count"] intValue];
        self.followerCount = [dictionary[@"followers_count"] intValue];
        self.followingCount = [dictionary[@"friends_count"] intValue];
    }
    return self;
}

@end
