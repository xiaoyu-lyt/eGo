//
//  User.m
//  eGo
//
//  Created by 萧宇 on 7/13/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "User.h"

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

- (void)saveData {
    
}

- (BOOL)isLoggedIn {
    return ([self.user objectForKey:@"token"]) ? YES : NO;
}

@end
