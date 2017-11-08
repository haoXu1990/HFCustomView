//
//  HFPhotosView.m
//  HFPhotosView
//
//  Created by Henry on 06/09/2017.
//  Copyright © 2017 Henry. All rights reserved.
//

#import "HFPhotosView.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface HFPhotosView ()
@property (nonatomic, strong) UIView *phContainer; ///< 宽度标尺view的 container
@property (nonatomic, strong) UIView *photoContainer; ///< 图片容器
@property (nonatomic, strong) MASConstraint *heightConstraint; ///< photoContainer 高度约束
@end

@implementation HFPhotosView

#pragma mark- lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    _photoMargin = 10;
    _numberOfColumns = 3;
    
    [self setupSubviews];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    _photoMargin = 10;
    _numberOfColumns = 3;
    
    [self setupSubviews];
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.phContainer];
    [self.phContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(@0); // 调试时可把改变此值查看效果
    }];
    
    [self updatePlaceHolderContainer];
    
    [self addSubview:self.photoContainer];
    [self.photoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        self.heightConstraint = make.height.mas_equalTo(@0).priorityLow();
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat wh = (self.photoContainer.frame.size.width - (self.numberOfColumns + 1) * self.photoMargin) / self.numberOfColumns;
    [self.photoContainer.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger column = idx % self.numberOfColumns;
        NSUInteger row = idx / self.numberOfColumns;
        obj.frame = CGRectMake((wh + self.photoMargin) * column + self.photoMargin, (wh + self.photoMargin) * row + self.photoMargin, wh, wh);
    }];
}

#pragma mark- event handling

- (void)photoViewDidTapped:(UITapGestureRecognizer *)tap {
    UIImageView *tappedView = (UIImageView *)tap.view;
    
    if ([self.delegate respondsToSelector:@selector(photosView:didTappedPhotoAtIndex:)]) {
        [self.delegate photosView:self didTappedPhotoAtIndex:tappedView.tag];
    }
    
    if (self.tapBlock) {
        self.tapBlock(self, tappedView.tag);
    }
}

#pragma mark- privateM

/**
 numberOfColumns 或 margin 变化时需要重新布局标尺视图
 */
- (void)updatePlaceHolderContainer {
    [self.phContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *lastView;
    for (int i = 0; i < self.numberOfColumns; i++) {
        UIView *phView = [UIView new];
        phView.backgroundColor = [UIColor greenColor];
        
        [self.phContainer addSubview:phView];
        [phView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.phContainer);
            if (!lastView) { // 第一个
                make.left.equalTo(self.phContainer).offset(self.photoMargin);
            } else {
                make.left.equalTo(lastView.mas_right).offset(self.photoMargin);
                make.width.equalTo(lastView);
            }
            
            if (i == self.numberOfColumns - 1) { // 最后一个
                make.right.equalTo(self.phContainer).offset(-self.photoMargin);
            }
        }];
        lastView = phView;
    }
}

/**
 重新布局 photoContainer 高度
 */
- (void)updatePhotoContainer {
    [self.heightConstraint deactivate];
    NSInteger numberOfRows = (self.photos.count + self.numberOfColumns - 1) / self.numberOfColumns;
    UIView *phView = [self.phContainer.subviews firstObject]; // 任意一个标尺均可
    [self.photoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        if (numberOfRows == 0) {
            self.heightConstraint = make.height.mas_equalTo(@0).priorityLow();
        } else {
            self.heightConstraint = make.height.equalTo(phView.mas_width).multipliedBy(numberOfRows).offset((numberOfRows + 1) * self.photoMargin).priorityLow();
        }
    }];
    [self setNeedsLayout];
    [self.superview setNeedsLayout];
}

#pragma mark- accessor

- (void)setPhotoMargin:(CGFloat)photoMargin {
    _photoMargin = photoMargin;
    
    [self updatePlaceHolderContainer];
    [self updatePhotoContainer];
}

- (void)setNumberOfColumns:(NSUInteger)numberOfColumns {
    _numberOfColumns = numberOfColumns;
    
    [self updatePlaceHolderContainer];
    [self updatePhotoContainer];
}

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    
    [self.photoContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *iv = [UIImageView new];
        iv.tag = idx;
        iv.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.photoContainer addSubview:iv];
        
        if ([obj isKindOfClass:[UIImage class]]) {
            iv.image = (UIImage *)obj;
        } else if ([obj isKindOfClass:[NSURL class]]) {
            [iv sd_setImageWithURL:obj placeholderImage:self.photoPlaceHolder];
        } else if ([obj isKindOfClass:[NSString class]]) {
            UIImage *img = [UIImage imageNamed:obj];
            if (img) {
                iv.image = img;
            } else {
                [iv sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:self.photoPlaceHolder];
            }
        } else {
            // 不能识别的图片
        }
        
        iv.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoViewDidTapped:)];
        [iv addGestureRecognizer:tap];
    }];
    
    [self updatePhotoContainer];
}

- (UIView *)phContainer {
    if (_phContainer == nil) {
        _phContainer = [UIView new];
        _phContainer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _phContainer;
}

- (UIView *)photoContainer {
    if (_photoContainer == nil) {
        _photoContainer = [UIView new];
    }
    return _photoContainer;
}
@end
