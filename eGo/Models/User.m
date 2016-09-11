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
    [manager GET:[kApiUrl stringByAppendingString:[NSString stringWithFormat:@"user/%@/%@.html", [_user objectForKey:@"token"], [_user objectForKey:@"tel"]]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self setUserInfo:responseObject[@"stu_num"] forKey:@"stuNum"];
        [self setUserInfo:responseObject[@"name"] forKey:@"name"];
        [self setUserInfo:responseObject[@"nickname"] forKey:@"nickname"];
        [self setUserInfo:responseObject[@"gender"] forKey:@"gender"];
        [self setUserInfo:responseObject[@"email"] forKey:@"email"];
        [self setUserInfo:responseObject[@"signature"] forKey:@"signature"];
        [self setUserInfo:responseObject[@"avatar"] forKey:@"avatar"];
        [self setUserInfo:responseObject[@"school"] forKey:@"school"];
        [self setUserInfo:responseObject[@"college"] forKey:@"college"];
        [self setUserInfo:responseObject[@"major"] forKey:@"major"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"");
    }];
}

- (NSDictionary *)saveData {
    __block NSDictionary *result;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager PUT:[kApiUrl stringByAppendingString:@"user.html"] parameters:@{@"token" : self.token, @"nickname" : self.nickname, @"tel" : self.tel, @"email" : self.email} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        result = [NSDictionary dictionaryWithDictionary:responseObject];
        NSLog(@"%@", result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%ld", (long)((NSHTTPURLResponse *)task.response).statusCode);
    }];
    return result;
}

- (void)setUserInfo:(NSObject *)infoObject forKey:(NSString *)key {
    if ([infoObject isEqual:[NSNull null]]) {
        [self.user setObject:nil forKey:key];
    } else {
        [self.user setObject:infoObject forKey:key];
    }
}

- (NSString *)tel {
    return ([[NSString stringWithFormat:@"%@", [self.user objectForKey:@"tel"]] isEqualToString:@"(null)"]) ? @"" : [NSString stringWithFormat:@"%@", [self.user objectForKey:@"tel"]];
}

- (NSString *)token {
    return ([[NSString stringWithFormat:@"%@", [self.user objectForKey:@"token"]] isEqualToString:@"(null)"]) ? @"" : [NSString stringWithFormat:@"%@", [self.user objectForKey:@"token"]];
}

- (NSString *)stuNum {
    return ([[NSString stringWithFormat:@"%@", [self.user objectForKey:@"stuNum"]] isEqualToString:@"(null)"]) ? @"" : [NSString stringWithFormat:@"%@", [self.user objectForKey:@"stuNum"]];
}

- (NSString *)name {
    return ([[NSString stringWithFormat:@"%@", [self.user objectForKey:@"name"]] isEqualToString:@"(null)"]) ? @"" : [NSString stringWithFormat:@"%@", [self.user objectForKey:@"name"]];
}

- (NSString *)nickname {
    return ([[NSString stringWithFormat:@"%@", [self.user objectForKey:@"nickname"]] isEqualToString:@"(null)"]) ? @"" : [NSString stringWithFormat:@"%@", [self.user objectForKey:@"nickname"]];
}

- (NSString *)gender {
    return ([[NSString stringWithFormat:@"%@", [self.user objectForKey:@"gender"]] isEqualToString:@"(null)"]) ? @"" : [NSString stringWithFormat:@"%@", [self.user objectForKey:@"gender"]];
}

- (NSString *)email {
    return ([[NSString stringWithFormat:@"%@", [self.user objectForKey:@"email"]] isEqualToString:@"(null)"]) ? @"" : [NSString stringWithFormat:@"%@", [self.user objectForKey:@"email"]];
}

- (NSString *)signature {
    return ([[NSString stringWithFormat:@"%@", [self.user objectForKey:@"signature"]] isEqualToString:@"(null)"]) ? @"" : [NSString stringWithFormat:@"%@", [self.user objectForKey:@"signature"]];
}

- (NSString *)avatar {
    return ([[NSString stringWithFormat:@"%@", [self.user objectForKey:@"avatar"]] isEqualToString:@"(null)"]) ? @"" : [NSString stringWithFormat:@"%@", [self.user objectForKey:@"avatar"]];
}

- (NSString *)school {
    return ([[NSString stringWithFormat:@"%@", [self.user objectForKey:@"school"]] isEqualToString:@"(null)"]) ? @"" : [NSString stringWithFormat:@"%@", [self.user objectForKey:@"school"]];
}

- (NSString *)college {
    return ([[NSString stringWithFormat:@"%@", [self.user objectForKey:@"college"]] isEqualToString:@"(null)"]) ? @"" : [NSString stringWithFormat:@"%@", [self.user objectForKey:@"college"]];
}

- (NSString *)major {
    return ([[NSString stringWithFormat:@"%@", [self.user objectForKey:@"major"]] isEqualToString:@"(null)"]) ? @"" : [NSString stringWithFormat:@"%@", [self.user objectForKey:@"major"]];
}

@end
