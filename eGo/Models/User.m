//
//  User.m
//  eGo
//
//  Created by 萧宇 on 7/13/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "User.h"
#import "Util.h"
#import "AFNetworking.h"

@implementation User

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.user = [NSUserDefaults standardUserDefaults];
    return self;
}

+ (User *)sharedUser {
    static User *sharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUser = [[User alloc] init];
    });
    return sharedUser;
}

- (BOOL)isLoggedIn {
    return ([self.user objectForKey:@"token"]) ? YES : NO;
}

- (void)updateUserInfo {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[kApiUrl stringByAppendingString:@"User/getUserInfo.html"] parameters:@{@"token" : [[User sharedUser].user objectForKey:@"token"], @"tel" : [[User sharedUser].user objectForKey:@"tel"]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject[@"data"]);
        [self setUserInfo:responseObject[@"data"][@"stu_id"] forKey:@"stuId"];
        [self setUserInfo:responseObject[@"data"][@"name"] forKey:@"name"];
        [self setUserInfo:responseObject[@"data"][@"nickname"] forKey:@"nickname"];
        [self setUserInfo:responseObject[@"data"][@"gender"] forKey:@"gender"];
        [self setUserInfo:responseObject[@"data"][@"email"] forKey:@"email"];
        [self setUserInfo:responseObject[@"data"][@"signature"] forKey:@"signature"];
        [self setUserInfo:responseObject[@"data"][@"photo_name"] forKey:@"photoName"];
        [self setUserInfo:responseObject[@"data"][@"school"] forKey:@"school"];
        [self setUserInfo:responseObject[@"data"][@"college"] forKey:@"college"];
        [self setUserInfo:responseObject[@"data"][@"major"] forKey:@"major"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Faild:%@", [error localizedDescription]);
    }];
}

- (void)saveData {
    
}

- (void)setUserInfo:(NSObject *)infoObject forKey:(NSString *)key {
    if ([infoObject isEqual:[NSNull null]]) {
        [self.user setObject:nil forKey:key];
    } else {
        [self.user setObject:infoObject forKey:key];
    }
}

@end
