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

+ (User *)sharedUser;

- (BOOL)isLoggedIn;
- (void)updateUserInfo;
- (void)saveData;

@end
