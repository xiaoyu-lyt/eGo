//
//  UserInfoTableViewCell.h
//  eGo
//
//  Created by 萧宇 on 8/29/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (strong, nonatomic) IBOutlet UILabel *aliasLbl;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLbl;
@property (strong, nonatomic) IBOutlet UILabel *signatureLbl;

@end
