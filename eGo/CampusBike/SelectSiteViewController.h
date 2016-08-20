//
//  SelectSiteViewController.h
//  eGo
//
//  Created by 萧宇 on 8/10/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SiteTypeOrigin,
    SiteTypeDestination,
} SiteType;

@protocol SelectSiteDelegate;

@interface SelectSiteViewController : UIViewController

@property (nonatomic) SiteType siteType;
@property (nonatomic, strong) NSString *site;

@property (nonatomic) id<SelectSiteDelegate> delegate;

@end

@protocol SelectSiteDelegate <NSObject>

- (void)site:(NSDictionary *)site selectedForType:(SiteType)type;

@end
