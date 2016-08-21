//
//  ModifyUserInfoViewController.h
//  eGo
//
//  Created by 萧宇 on 8/21/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UserInfoTypeNickname,
    UserInfoTypeTel,
    UserInfoTypeEmail,
    UserInfoTypePassword,
} UserInfoType;

@protocol ModifyUserInfoDelegate;

@interface ModifyUserInfoViewController : UIViewController

@property (nonatomic, assign) UserInfoType userInfoType;
@property (nonatomic, strong) NSString *userInfo;
@property (nonatomic, strong) id<ModifyUserInfoDelegate> delegate;

@end

@protocol ModifyUserInfoDelegate <NSObject>

- (void)userInfo:(NSString *)userInfo modifiedForType:(UserInfoType)type;

@end
