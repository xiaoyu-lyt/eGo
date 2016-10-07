//
//  ChatTableViewCell.h
//  eGo
//
//  Created by 萧宇 on 8/3/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UIImageView *genderImgView;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UILabel *placeLbl;
@property (strong, nonatomic) IBOutlet UILabel *contentLbl;
@property (strong, nonatomic) IBOutlet UIButton *likeBtn;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;

@property (assign, nonatomic) NSInteger index;

@end
