//
//  AMapManager.m
//  eGo
//
//  Created by 萧宇 on 8/15/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "AMapManager.h"
#import "Util.h"

#import "CampusTrafficViewController.h"
#import "BusInfoViewController.h"

static const double kRadius = 6371004;

@interface AMapManager()<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAUserLocation *userLocation;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) NSMutableArray *overlays;
@property (nonatomic, strong) NSArray<NSDictionary *> *poiSearchResult;

@end

@implementation AMapManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [AMapServices sharedServices].apiKey = @"92d9824162e630cdbecf438c6be674b4";
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        // 设置代理
        self.mapView.delegate = self;
        // 设置地图初始大小
        self.mapView.zoomLevel = 16;
        // 显示用户位置
        self.mapView.showsUserLocation = YES;
        // 设置地图Logo位置
        self.mapView.logoCenter = CGPointMake(self.mapView.logoCenter.x, 80);
        // 设置指南针位置
        self.mapView.compassOrigin = CGPointMake(self.mapView.compassOrigin.x, 108);
        // 设置地图中心点
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake(26.057000, 119.196000);
        
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
    }
    return self;
}

+ (AMapManager *)manager {
    static AMapManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AMapManager alloc] init];
    });
    return manager;
}

- (void)resetMapView {
    if (self.annotations != nil) {
        [self.mapView removeAnnotations:self.annotations];
        self.annotations = nil;
    }
    if (self.overlays != nil) {
        [self.mapView removeOverlays:self.overlays];
        self.overlays = nil;
    }
}

- (void)locate {
    self.mapView.showsUserLocation = NO;
    switch (self.mapView.userTrackingMode) {
        case MAUserTrackingModeFollow:
            [self.mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading animated:YES];
            break;
        default:
            [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
            break;
    }
    self.mapView.showsUserLocation = YES;
}

- (void)removeAnnotations {
    if (self.annotations != nil) {
        [self.mapView removeAnnotations:self.annotations];
    }
}

- (void)addBusAnnotationsWithLocations:(NSArray *)locations {
    [self removeAnnotations];
    self.annotations = [[NSMutableArray alloc] init];
    for (NSDictionary *location in locations) {
        // 计算小白与当前位置距离，并以10km/h的平均速度计算到达当前位置所需时间
        double distance = [self getDistanceWithLatitude:[location[@"latitude"] doubleValue] andLongitude:[location[@"longitude"] doubleValue]];
        
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([location[@"latitude"] doubleValue], [location[@"longitude"] doubleValue]);
        pointAnnotation.title = [NSString stringWithFormat:@"距离%.2f米", distance];
        pointAnnotation.subtitle = [NSString stringWithFormat:@"约%.1f分钟后到达", (60 * distance / 10000)];
        
        [self.annotations addObject:pointAnnotation];
    }
    [self.mapView addAnnotations:self.annotations];
}

- (void)addSiteAnnotationsWithLocations:(NSArray *)locations {
    [self removeAnnotations];
    self.annotations = [[NSMutableArray alloc] init];
    for (NSDictionary *location in locations) {
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([location[@"latitude"] doubleValue], [location[@"longitude"] doubleValue]);
        pointAnnotation.title = location[@"name"];
        
        [self.annotations addObject:pointAnnotation];
    }
    [self.mapView addAnnotations:self.annotations];
}

- (void)searchWithPOIKeywords:(NSString *)keywords {
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:self.userLocation.coordinate.latitude longitude:self.userLocation.coordinate.longitude];
    request.keywords = keywords;
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"餐饮服务|购物服务|生活服务|体育休闲服务|风景名胜|地名地址信息";
    request.sortrule = 0;
    request.requireExtension = YES;
    
    //发起周边搜索
    [_search AMapPOIAroundSearch: request];
}

// 根据经纬度计算距离
- (double)getDistanceWithLatitude:(double)latitude andLongitude:(double)longitude {
    double c = sin(latitude) * sin(self.userLocation.location.coordinate.latitude) * cos(longitude-self.userLocation.location.coordinate.longitude) + cos(latitude) * cos(self.userLocation.location.coordinate.latitude);
    return kRadius * acos(c) * M_PI / 180;
}

#pragma mark - MAMapViewDelegate

// 用户位置更新回调事件
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        self.userLocation = userLocation;
//        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

// 设置气泡
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = NO;        //设置标注动画显示，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
//        annotationView.pinColor = MAPinAnnotationColorPurple;
        UIViewController *currentVC = [Util getViewController:self.mapView];
        if ([[currentVC class] isEqual:[CampusTrafficViewController class]]) {
            annotationView.image = [UIImage imageNamed:@"CampusBus"];
        } else {
            annotationView.pinColor = MAPinAnnotationColorRed;
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    NSLog(@"a");
}

// 点击气泡触发事件
- (void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view {
    NSLog(@"You tapped the %lu annotation view", (unsigned long)[self.annotations indexOfObject:view.annotation]);
    UIViewController *currentVC = [Util getViewController:self.mapView];
    if ([[currentVC class] isEqual:[CampusTrafficViewController class]] && ![view.annotation.title isEqualToString:@"当前位置"]) {
        [currentVC showViewController:[[BusInfoViewController alloc] init] sender:nil];
    }
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if(response.pois.count == 0) {
        [[Util getViewController:self.mapView].view makeToast:@"未找到相关信息"];
        return;
    }
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:response.pois.count];
    for (AMapPOI *poi in response.pois) {
        [result addObject:@{@"name" : poi.name, @"latitude" : @(poi.location.latitude), @"longitude" : @(poi.location.longitude)}];
    }
    [self addSiteAnnotationsWithLocations:result];
}

@end
