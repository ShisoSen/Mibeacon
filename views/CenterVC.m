//
//  CenterVC.m
//  MiBeacon
//
//  Created by Sicong Qian on 15/9/7.
//  Copyright (c) 2015年 silverup.co. All rights reserved.
//

#import "CenterVC.h"
#import "RACollectionViewReorderableTripletLayout.h"
#import "CenterCollectionCell.h"
#import "DispatchVC.h"
#import "ScanVC.h"
#import "SettingVC.h"

NSUInteger const MaxCellCount = 17;
@interface CenterVC () <RACollectionViewDelegateReorderableTripletLayout, RACollectionViewReorderableTripletLayoutDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *colorArray;
@property (nonatomic, assign) BOOL selectToDelete;
@end

@implementation CenterVC{
    UINavigationItem *navItems;
    UIBarButtonItem *rightItemDel;
    UIViewController *settingPage;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.insets = UIEdgeInsetsMake(69+5, 5, 5, 5);
        self.selectToDelete = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.878 green:0.919 blue:1.000 alpha:1.000];
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 69)];
    [navBar setBarTintColor:[UIColor colorWithRed:0.241 green:0.474 blue:1.000 alpha:1.000]];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    navBar.translucent = false;
    [self.view addSubview:navBar];
    
    navItems = [[UINavigationItem alloc] initWithTitle:@"center"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(MenuAction:)];
    [leftItem setTintColor:[UIColor whiteColor]];
    navItems.leftBarButtonItem = leftItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"A" style:UIBarButtonItemStyleBordered target:self action:@selector(AddAction:)];
    [rightItem setTintColor:[UIColor whiteColor]];
    rightItemDel = [[UIBarButtonItem alloc] initWithTitle:@"D" style:UIBarButtonItemStyleBordered target:self action:@selector(DeleteAction:)];
    [rightItemDel setTintColor:[UIColor whiteColor]];
    navItems.rightBarButtonItems = @[rightItemDel,rightItem];
    [navBar pushNavigationItem:navItems animated:YES];
    
    RACollectionViewReorderableTripletLayout *layout = [[RACollectionViewReorderableTripletLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.insets.left, self.insets.top, self.view.bounds.size.width-self.insets.left-self.insets.right, self.view.bounds.size.height-self.insets.top-self.insets.bottom) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self setupDataArray];
}

- (void)MenuAction:(id)sender{
    switch (self.sliderController.drawerState) {
        case GDFDrawerControllerStateClosed:
            [self.sliderController open];
            break;
        case GDFDrawerControllerStateOpen:
            [self.sliderController close];
            break;
        default:
            break;
    }
}
- (void)AddAction:(id)sender{
    if (_photosArray.count>=17) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"cannot add more"
                                                       delegate:nil
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSString *photoName = [NSString stringWithFormat:@"%ld.jpg",(long)_photosArray.count+1];
    UIImage *photo = [UIImage imageNamed:photoName];
    [self.collectionView performBatchUpdates:^{
        [_photosArray addObject:photo];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_photosArray.count-1 inSection:1];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
        CGPoint offset = CGPointMake(0, self.collectionView.contentSize.height - self.collectionView.frame.size.height);
        [self.collectionView setContentOffset:offset animated:YES];
    }];
    
}
- (void)DeleteAction:(id)sender{
    _selectToDelete = _selectToDelete?NO:YES;
    if (_selectToDelete) {
        [navItems setTitle:@"Deleting..."];
        [rightItemDel setTintColor:[UIColor redColor]];
    }else{
        [navItems setTitle:@"Center"];
        [rightItemDel setTintColor:[UIColor whiteColor]];
    }
    NSLog(@"selectToDelete: %@",_selectToDelete?@"yes":@"no");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - collectionView delegate
- (void)setupDataArray
{
    [_photosArray removeAllObjects];
    _photosArray = nil;
    _photosArray = [NSMutableArray array];
    for (NSInteger i = 1; i <= 7; i++) {
        NSString *photoName = [NSString stringWithFormat:@"%ld.jpg",(long)i];
        UIImage *photo = [UIImage imageNamed:photoName];
        [_photosArray addObject:photo];
    }
    [_titleArray removeAllObjects];
    _titleArray = nil;
    _titleArray = [NSMutableArray array];
    [_titleArray addObjectsFromArray:@[@"指南",
                                       @"biubiu",
                                       @"fewfew"]];
    [_colorArray removeAllObjects];
    _colorArray = nil;
    _colorArray = [NSMutableArray array];
    [_colorArray addObject:[UIColor colorWithRed:1.000 green:0.791 blue:0.456 alpha:1.000]];
    [_colorArray addObject:[UIColor colorWithRed:0.643 green:1.000 blue:0.317 alpha:1.000]];
    [_colorArray addObject:[UIColor colorWithRed:0.528 green:0.815 blue:1.000 alpha:1.000]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return _photosArray.count;
}

- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(5.f, 0, 5.f, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(self.collectionView.frame.size.width, 200);
    }
    return RACollectionViewTripletLayoutStyleSquare; //same as default !
}

- (UIEdgeInsets)autoScrollTrigerEdgeInsets:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(50.f, 0, 50.f, 0); //Sorry, horizontal scroll is not supported now.
}

- (UIEdgeInsets)autoScrollTrigerPadding:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(64.f, 0, 0, 0);
}

- (CGFloat)reorderingItemAlpha:(UICollectionView *)collectionview
{
    return .3f;
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    UIImage *image = [_photosArray objectAtIndex:fromIndexPath.item];
    [_photosArray removeObjectAtIndex:fromIndexPath.item];
    [_photosArray insertObject:image atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if (toIndexPath.section == 0) {
        return NO;
    }else if (toIndexPath.row<3){
        return NO;
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }else if (indexPath.row < 3){
        return NO;
    }
    return YES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellID = @"headerCell";
        [self.collectionView registerClass:[CenterCollectionCell class] forCellWithReuseIdentifier:cellID];
        UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:0.728 green:1.000 blue:0.588 alpha:1.000];
        return cell;
    }else {
        static NSString *cellID = @"cellID";
        [self.collectionView registerClass:[CenterCollectionCell class] forCellWithReuseIdentifier:cellID];
        CenterCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        [cell.imageView removeFromSuperview];
        [cell.label removeFromSuperview];
        if (indexPath.item < 3) {
            cell.backgroundColor = _colorArray[indexPath.item];
            cell.title = _titleArray[indexPath.item];
            [cell.contentView addSubview:cell.label];
        }else{
            cell.imageView.frame = cell.bounds;
            cell.imageView.image = _photosArray[indexPath.item];
            [cell.contentView addSubview:cell.imageView];
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectToDelete) {
        if (indexPath.section == 0) {
            return;
        }
        if (_photosArray.count == 1) {
            return;
        }
        [self.collectionView performBatchUpdates:^{
            [_photosArray removeObjectAtIndex:indexPath.item];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [self.collectionView reloadData];
        }];
    }else{
        if (indexPath.section==1) {
            if (indexPath.item==0) {
                settingPage = [[SettingVC alloc]initWithNibName:nil bundle:nil];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:settingPage];
                [nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
                [self presentViewController:nav animated:YES completion:^{
                    NSLog(@"111");
                }];
            }else if(indexPath.item==1){
                DispatchVC *dispatchVC = [[DispatchVC alloc] initWithNibName:nil bundle:nil];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dispatchVC];
                [self presentViewController:nav animated:YES completion:^{
                    NSLog(@"111");
                }];
            }else{
                ScanVC *scanVC = [[ScanVC alloc] initWithNibName:nil bundle:nil];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:scanVC];
                [self presentViewController:nav animated:YES completion:^{
                    NSLog(@"111");
                }];
            }
        }
    }
    NSLog(@"didSelectItemAtIndexPath in section:%ld, row:%ld",(long)indexPath.section,(long)indexPath.row);
}

#pragma mark -GDFSlide delegate
- (void)slideControllerWillOpen:(GDFSlideController *)slideController{
    
}
- (void)slideControllerDidOpen:(GDFSlideController *)slideController{
    
}
- (void)slideControllerWillClose:(GDFSlideController *)slideController{
    
}
- (void)slideControllerDidClose:(GDFSlideController *)slideController{
    
}

- (void)slideControllerTapClose:(GDFSlideController *)slideController{
    
}
@end
