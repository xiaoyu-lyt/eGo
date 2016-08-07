//
//  AdCollectionViewCell.m
//  eGo
//
//  Created by 萧宇 on 8/7/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "AdCollectionViewCell.h"

@implementation AdCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.adImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.adImgView];
    }
    return self;
}

@end
