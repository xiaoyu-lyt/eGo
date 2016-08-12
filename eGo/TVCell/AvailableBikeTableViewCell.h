//
//  AvailableBikeTableViewCell.h
//  eGo
//
//  Created by 萧宇 on 8/11/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvailableBikeTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *photoImgView;
@property (strong, nonatomic) IBOutlet UILabel *pathLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UILabel *rangeLbl;
@property (strong, nonatomic) IBOutlet UILabel *ownerLbl;
@property (strong, nonatomic) IBOutlet UILabel *telLbl;

@end
