//
//  AMapManager.h
//  eGo
//
//  Created by 萧宇 on 8/15/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AMapManager : NSObject

@property (nonatomic, strong) MAMapView *mapView;

+ (AMapManager *)manager;

- (void)resetMapView;
- (void)locate;
- (void)removeAnnotations;
- (MAUserLocation *)userLocation;
- (void)addBusAnnotationsWithLocations:(NSArray *)locations;
- (void)addSiteAnnotationsWithLocations:(NSArray *)locations;
- (void)searchWithPOIKeywords:(NSString *)keywords;
- (void)searchRouteWithOrigin:(NSDictionary *)origin andDestination:(NSDictionary *)destination;

@end
