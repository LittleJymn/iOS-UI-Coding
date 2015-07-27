//
//  JTTImageZoomView.m
//  JTTImagesBrowser
//
//  Created by Jymn_Chen on 15/7/26.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import "JTTImageZoomView.h"


///////////////////////////////////////////////////////////////////////////////////////////


@interface JTTImageZoomView () <UIScrollViewDelegate>
{
    BOOL m_isDoubleTap;
}

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation JTTImageZoomView


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.backgroundColor = [UIColor clearColor];
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 2.0;
        self.delegate = self;
        
        _imageView = [UIImageView new];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - iVars Accessors

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
    [self adjustImageViewFrame];
}


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Private Methods

- (void)adjustImageViewFrame {
    if (_imageView.image == nil) {
        return;
    }
    
    CGRect scaleRect;
    CGSize imgSize = _imageView.image.size;
    
    CGFloat scaleX = self.frame.size.width / imgSize.width;
    CGFloat scaleY = self.frame.size.height / imgSize.height;
    
    if (scaleX > scaleY) {
        CGFloat imgViewWidth = imgSize.width * scaleY;
        scaleRect = (CGRect) {
            self.frame.size.width / 2 - imgViewWidth / 2,
            0,
            imgViewWidth,
            self.frame.size.height
        };
    }
    else {
        CGFloat imgViewHeight = imgSize.height * scaleX;
        scaleRect = (CGRect) {
            0,
            self.frame.size.height / 2 - imgViewHeight / 2,
            self.frame.size.width,
            imgViewHeight
        };
    }
    
    _imageView.frame = scaleRect;
}

- (void)tapInImageZoomView {
    if (m_isDoubleTap) {
        return;
    }
    
    if (_jttDelegate && [_jttDelegate respondsToSelector:@selector(jtt_imageZoomViewDidTap)]) {
        [_jttDelegate jtt_imageZoomViewDidTap];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = _imageView.frame;
    CGSize contentSize = scrollView.contentSize;
    
    CGPoint centerPoint = CGPointMake(contentSize.width / 2, contentSize.height / 2);
    if (imgFrame.size.width <= boundsSize.width) {
        centerPoint.x = boundsSize.width / 2;
    }
    if (imgFrame.size.height <= boundsSize.height) {
        centerPoint.y = boundsSize.height / 2;
    }
    
    _imageView.center = centerPoint;
}


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Gesture Actions

- (void)singleTapAction:(UITapGestureRecognizer *)tap {
    m_isDoubleTap = NO;
    [self performSelector:@selector(tapInImageZoomView) withObject:nil afterDelay:0.2];
}

- (void)doubleTapAction:(UITapGestureRecognizer *)tap {
    m_isDoubleTap = YES;
    
    CGPoint touchPoint = [tap locationInView:self];
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
    else {
        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}

@end
