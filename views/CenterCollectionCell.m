//
//  CenterCollectionCell.m
//  MiBeacon
//
//  Created by Sicong Qian on 15/9/8.
//  Copyright (c) 2015年 silverup.co. All rights reserved.
//

#import "CenterCollectionCell.h"

@implementation CenterCollectionCell

- (instancetype)init{
    self = [super init];
    if (self) {
        [self _createImageView];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _createImageView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[self layer]setCornerRadius:15.0];
        [self _createImageView];
    }
    return self;
}
- (void)_createImageView{
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _imageView.clipsToBounds = YES;
    [[_imageView layer] setCornerRadius:10.0f];
    
    _label = [[UILabel alloc] init];
    _label.clipsToBounds = YES;
    [_label setTextAlignment:NSTextAlignmentCenter];
    _label.textColor = [UIColor whiteColor];
}
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        _imageView.alpha = .7f;
    }else {
        _imageView.alpha = 1.f;
    }
}
//bug-fix: image size was not fit of cell @sicong
- (void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _label.frame = CGRectMake(0, self.bounds.size.height*2/3, self.bounds.size.width, self.bounds.size.height/3);
    _label.text = self.title;
}
@end
