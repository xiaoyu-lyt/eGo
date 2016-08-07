//
//  CommentsTableViewCell.h
//  eGo
//
//  Created by 萧宇 on 8/6/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (strong, nonatomic) IBOutlet UILabel *floorLbl;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UILabel *placeLbl;
@property (strong, nonatomic) IBOutlet UILabel *contentLbl;
@property (strong, nonatomic) IBOutlet UIButton *likeBtn;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;

@end
