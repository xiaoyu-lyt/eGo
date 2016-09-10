//
//  User.h
//  eGo
//
//  Created by 萧宇 on 7/13/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic) NSUserDefaults *user;

@property (nonatomic, strong, readonly) NSString *tel;
@property (nonatomic, strong, readonly) NSString *token;
@property (nonatomic, strong, readonly) NSString *stuId;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *nickname;
@property (nonatomic, strong, readonly) NSString *gender;
@property (nonatomic, strong, readonly) NSString *email;
@property (nonatomic, strong, readonly) NSString *signature;
@property (nonatomic, strong, readonly) NSString *avatar;
@property (nonatomic, strong, readonly) NSString *school;
@property (nonatomic, strong, readonly) NSString *college;
@property (nonatomic, strong, readonly) NSString *major;

+ (User *)sharedUser;

- (BOOL)isLoggedIn;
- (void)updateUserInfo;
- (void)saveData;

@end
