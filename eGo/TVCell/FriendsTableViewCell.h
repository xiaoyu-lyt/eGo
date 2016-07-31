//
//  FriendsTableViewCell.h
//  eGo
//
//  Created by 萧宇 on 7/30/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *userPhotoImgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *messageLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;

@end
