//
//  ShowRouteViewController.h
//  eGo
//
//  Created by 萧宇 on 8/20/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MAMapKit/MAMapKit.h>

@interface ShowRouteViewController : UIViewController

/* 起点 */
@property (nonatomic, strong) NSDictionary *origin;
/* 终点 */
@property (nonatomic, strong) NSDictionary *destination;

@end
