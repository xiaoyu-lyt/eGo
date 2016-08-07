//
//  CampusBikeViewController.m
//  eGo
//
//  Created by 萧宇 on 8/7/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "CampusBikeViewController.h"
#import "AdCollectionViewCell.h"

#import "User.h"
#import "Util.h"
#import "AFNetworking.h"

@interface CampusBikeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *adCV;
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UIImageView *img3;

@end

@implementation CampusBikeViewController{
    NSArray *_image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBarButton];
    
    UISwipeGestureRecognizer *preViewSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(preView:)];
    [preViewSwip setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.adCV addGestureRecognizer:preViewSwip];
    UISwipeGestureRecognizer *nextViewSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextView:)];
    [nextViewSwip setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.adCV addGestureRecognizer:nextViewSwip];
    
    self.adCV.scrollEnabled = NO;
    _image = @[@"DefaultImage", @"Background", @"AppLogo"];
    self.img1.image = [UIImage imageNamed:@"Male"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.adCV.delegate = self;
    self.adCV.dataSource = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.adCV.delegate = nil;
    self.adCV.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)preView:(UISwipeGestureRecognizer *)sender {
    NSIndexPath *current = self.adCV.indexPathsForVisibleItems.firstObject;
    NSLog(@"%ld", (long)current.row);
    long nextRow = current.row - 1;
    long nextSection = current.section;
    if (nextRow == -1) {
        nextRow = 2;
    }
    
    switch (nextRow) {
        case 0:
            self.img1.image = [UIImage imageNamed:@"Male"];
            self.img2.image = [UIImage imageNamed:@"Female"];
            self.img3.image = [UIImage imageNamed:@"Female"];
            break;
        case 1:
            self.img1.image = [UIImage imageNamed:@"Female"];
            self.img2.image = [UIImage imageNamed:@"Male"];
            self.img3.image = [UIImage imageNamed:@"Female"];
            break;
        case 2:
            self.img1.image = [UIImage imageNamed:@"Female"];
            self.img2.image = [UIImage imageNamed:@"Female"];
            self.img3.image = [UIImage imageNamed:@"Male"];
            break;
        default:
            break;
    }
    NSIndexPath *next = [NSIndexPath indexPathForRow:nextRow inSection:nextSection];
    [self.adCV scrollToItemAtIndexPath:next atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}

- (void)nextView:(UISwipeGestureRecognizer *)sender {
    NSIndexPath *current = self.adCV.indexPathsForVisibleItems.firstObject;
    NSLog(@"%ld", (long)current.row);
    long nextRow = current.row + 1;
    long nextSection = current.section;
    if (nextRow == 3) {
        nextRow = 0;
    }
    
    switch (nextRow) {
        case 0:
            self.img1.image = [UIImage imageNamed:@"Male"];
            self.img2.image = [UIImage imageNamed:@"Female"];
            self.img3.image = [UIImage imageNamed:@"Female"];
            break;
        case 1:
            self.img1.image = [UIImage imageNamed:@"Female"];
            self.img2.image = [UIImage imageNamed:@"Male"];
            self.img3.image = [UIImage imageNamed:@"Female"];
            break;
        case 2:
            self.img1.image = [UIImage imageNamed:@"Female"];
            self.img2.image = [UIImage imageNamed:@"Female"];
            self.img3.image = [UIImage imageNamed:@"Male"];
            break;
        default:
            break;
    }
    NSIndexPath *next = [NSIndexPath indexPathForRow:nextRow inSection:nextSection];
    [self.adCV scrollToItemAtIndexPath:next atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AdCollectionViewCell";
    [collectionView registerClass:[AdCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    AdCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.adImgView.image = [UIImage imageNamed:_image[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width / 3);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(-15.0, 0.0, 0.0, 0.0);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
