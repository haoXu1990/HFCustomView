//
//  HFPhotosView.h
//  HFPhotosView
//
//  Created by Henry on 06/09/2017.
//  Copyright © 2017 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HFPhotosView;

typedef void(^HFPhotosViewTapBlock)(HFPhotosView *photosView, NSUInteger idx);

@protocol HFPhotosViewDelegate <NSObject>
@optional
- (void)photosView:(HFPhotosView *)photosView didTappedPhotoAtIndex:(NSUInteger)idx;
@end


@interface HFPhotosView : UIView
@property (nonatomic, assign) CGFloat photoMargin; ///< 图片间隙，默认10
@property (nonatomic, strong) UIImage *photoPlaceHolder; ///< placeHolder
@property (nonatomic, assign) NSUInteger numberOfColumns; ///< 图片列数，默认3
@property (nonatomic, strong) NSArray *photos; ///< 图片数组
@property (nonatomic, weak) id<HFPhotosViewDelegate> delegate; ///< 代理
@property (nonatomic, copy) HFPhotosViewTapBlock tapBlock; ///< 点击回调
@property (nonatomic, strong, readonly) UIView *photoContainer; ///< 图片容器
@end
