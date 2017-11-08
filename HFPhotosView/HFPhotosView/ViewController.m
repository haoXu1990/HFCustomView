//
//  ViewController.m
//  HFPhotosView
//
//  Created by Henry on 06/09/2017.
//  Copyright © 2017 Henry. All rights reserved.
//

#import "ViewController.h"
#import "HFPhotosView.h"
#import "SDPhotoBrowser.h"

@interface ViewController ()<SDPhotoBrowserDelegate>
@property (nonatomic, copy) NSMutableArray *photos; ///< <#desc#>
@property (weak, nonatomic) IBOutlet HFPhotosView *photosView;
@property (nonatomic, strong) SDPhotoBrowser *brower; ///< <#desc#>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photosView.photos = [self.photos copy];
    self.photosView.photoPlaceHolder = [UIImage imageNamed:@"placeHolder"];
    
    __weak typeof(self)weakSelf = self;
    
    self.photosView.tapBlock = ^(HFPhotosView *photosView, NSUInteger idx) {
        SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = weakSelf;
        photoBrowser.currentImageIndex = idx;
        photoBrowser.imageCount = weakSelf.photos.count;
        photoBrowser.sourceImagesContainerView = self.photosView.photoContainer;
        [photoBrowser show];
    };
    
}

#pragma mark- SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    return [NSURL URLWithString:self.photos[index]];
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return [UIImage imageNamed:@"placeHolder"];
}

#pragma mark- event handling

- (IBAction)marginSlideValueChanged:(UISlider *)sender {
    self.photosView.photoMargin = sender.value;
}

- (IBAction)columnSegmentedValueChanged:(UISegmentedControl *)sender {
    self.photosView.numberOfColumns = sender.selectedSegmentIndex + 1;
}

- (IBAction)plusCount:(UIButton *)sender {
    [self.photos addObject:[NSString stringWithFormat:@"http://oimil4j5d.bkt.clouddn.com/%d.jpg", arc4random()%10]];
    self.photosView.photos = [self.photos copy];
}

- (IBAction)minusCount:(UIButton *)sender {
    [self.photos removeLastObject];
    self.photosView.photos = [self.photos copy];
}

- (NSMutableArray *)photos {
    if (_photos == nil) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (SDPhotoBrowser *)brower {
    if (_brower == nil) {
        _brower = [[SDPhotoBrowser alloc] init];
        _brower.sourceImagesContainerView = self.view;
        _brower.delegate = self;
    }
    return _brower;
}

@end
