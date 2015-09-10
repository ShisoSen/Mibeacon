//
//  CenterCollectionCell.h
//  MiBeacon
//
//  Created by Sicong Qian on 15/9/8.
//  Copyright (c) 2015年 silverup.co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *moreInfo;
@property (nonatomic, strong) UILabel *label;
@end
