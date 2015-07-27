//
//  JTTImagesBrowser.m
//  JTTImagesBrowser
//
//  Created by Jymn_Chen on 15/7/26.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import "JTTImagesBrowser.h"
#import "JTTImageZoomView.h"


///////////////////////////////////////////////////////////////////////////////////////////


#define JTTImagesBrowser_ScreenWidth    [UIScreen mainScreen].bounds.size.width
#define JTTImagesBrowser_ScreenHeight   [UIScreen mainScreen].bounds.size.height

#define JTTImagesBrowser_ImageZoomViewTag(index)    (index + 6270)

@interface JTTImagesBrowser () <UIScrollViewDelegate, JTTImageZoomViewDelegate>
{
    CGRect m_srcImageViewRect;
    NSInteger m_currentIndex;
    CGPoint m_beginPoint;
    BOOL m_scrollToRight;
}

@property (nonatomic, copy) NSArray *allImages;

@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation JTTImagesBrowser


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Init

- (instancetype)initWithImages:(NSArray *)imagesArray {
    if (imagesArray == nil || imagesArray.count == 0) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.hidden = YES;
        m_currentIndex = 0;
        _allImages = [imagesArray copy];
        
        self.backgroundColor = [UIColor blackColor];
        self.frame = [UIScreen mainScreen].bounds;
        
        [self configMainScrollView];
    }
    return self;
}

- (void)configMainScrollView {
    CGRect rect = self.bounds;
    _mainScrollView = [[UIScrollView alloc] initWithFrame:rect];
    _mainScrollView.backgroundColor = [UIColor clearColor];
    _mainScrollView.bounces = YES;
    _mainScrollView.bouncesZoom = YES;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    _mainScrollView.contentSize = CGSizeMake(_allImages.count * JTTImagesBrowser_ScreenWidth, JTTImagesBrowser_ScreenHeight);
    [self addSubview:_mainScrollView];
}

#pragma mark - Dealloc

- (void)dealloc {
    m_srcImageViewRect = CGRectZero;
    m_currentIndex = 0;
    m_beginPoint = CGPointZero;
    m_scrollToRight = NO;
    _allImages = nil;
    _mainScrollView = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Public Methods

- (void)showWithImageView:(UIImageView *)imageView index:(NSInteger)index {
    if ([self validatePageIndex:index] == NO) {
        return;
    }
    m_currentIndex = index;
    
    CGRect curRect = self.bounds;
    CGFloat srcX = JTTImagesBrowser_ScreenWidth * index;
    curRect.origin.x = srcX;
    JTTImageZoomView *curZoomView = [[JTTImageZoomView alloc] initWithFrame:curRect];
    curZoomView.tag = JTTImagesBrowser_ImageZoomViewTag(m_currentIndex);
    curZoomView.jttDelegate = self;
    [curZoomView setImage:_allImages[m_currentIndex]];
    [_mainScrollView addSubview:curZoomView];
    
    if ([self validatePageIndex:m_currentIndex - 1]) {
        CGRect preRect = self.bounds;
        preRect.origin.x = srcX - JTTImagesBrowser_ScreenWidth;
        JTTImageZoomView *preZoomView = [[JTTImageZoomView alloc] initWithFrame:preRect];
        preZoomView.tag = JTTImagesBrowser_ImageZoomViewTag(m_currentIndex - 1);
        preZoomView.jttDelegate = self;
        [preZoomView setImage:_allImages[m_currentIndex - 1]];
        [_mainScrollView addSubview:preZoomView];
    }
    
    if ([self validatePageIndex:m_currentIndex + 1]) {
        CGRect nexRect = self.bounds;
        nexRect.origin.x = srcX + JTTImagesBrowser_ScreenWidth;
        JTTImageZoomView *nexZoomView = [[JTTImageZoomView alloc] initWithFrame:nexRect];
        nexZoomView.tag = JTTImagesBrowser_ImageZoomViewTag(m_currentIndex + 1);
        nexZoomView.jttDelegate = self;
        [nexZoomView setImage:_allImages[m_currentIndex + 1]];
        [_mainScrollView addSubview:nexZoomView];
    }
    [_mainScrollView scrollRectToVisible:curZoomView.frame animated:NO];
    
    m_srcImageViewRect = imageView.frame;
    UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:m_srcImageViewRect];
    tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
    tmpImageView.image = imageView.image;
    [self.superview addSubview:tmpImageView];
    [UIView animateWithDuration:0.3 animations:^{
        tmpImageView.frame = self.bounds;
    } completion:^(BOOL finished) {
        [tmpImageView removeFromSuperview];
        self.hidden = NO; 
    }];
}

#pragma mark - Private Methods

- (void)refreshMainScrollView {
    JTTImageZoomView *curZoomView = (JTTImageZoomView *)[_mainScrollView viewWithTag:JTTImagesBrowser_ImageZoomViewTag(m_currentIndex)];
    CGRect curRect = curZoomView.frame;
    
    if (m_scrollToRight) {
        if ([self validatePageIndex:m_currentIndex - 2]) {
            UIView *preZoomView = [_mainScrollView viewWithTag:JTTImagesBrowser_ImageZoomViewTag(m_currentIndex - 2)];
            if (preZoomView) {
                [preZoomView removeFromSuperview];
            }
        }
        if ([self validatePageIndex:m_currentIndex + 1]) {
            UIView *tmpZoomView = [_mainScrollView viewWithTag:JTTImagesBrowser_ImageZoomViewTag(m_currentIndex + 1)];
            if (tmpZoomView == nil) {
                CGRect nexRect = curRect;
                nexRect.origin.x += JTTImagesBrowser_ScreenWidth;
                JTTImageZoomView *nexZoomView = [[JTTImageZoomView alloc] initWithFrame:nexRect];
                nexZoomView.tag = JTTImagesBrowser_ImageZoomViewTag(m_currentIndex + 1);
                nexZoomView.jttDelegate = self;
                nexZoomView.image = _allImages[m_currentIndex + 1];
                [_mainScrollView addSubview:nexZoomView];
            }
        }
    }
    else {
        if ([self validatePageIndex:m_currentIndex + 2]) {
            UIView *preZoomView = [_mainScrollView viewWithTag:JTTImagesBrowser_ImageZoomViewTag(m_currentIndex + 2)];
            if (preZoomView) {
                [preZoomView removeFromSuperview];
            }
        }
        if ([self validatePageIndex:m_currentIndex - 1]) {
            UIView *tmpZoomView = [_mainScrollView viewWithTag:JTTImagesBrowser_ImageZoomViewTag(m_currentIndex - 1)];
            if (tmpZoomView == nil) {
                CGRect nexRect = curRect;
                nexRect.origin.x -= JTTImagesBrowser_ScreenWidth;
                JTTImageZoomView *nexZoomView = [[JTTImageZoomView alloc] initWithFrame:nexRect];
                nexZoomView.tag = JTTImagesBrowser_ImageZoomViewTag(m_currentIndex - 1);
                nexZoomView.jttDelegate = self;
                nexZoomView.image = _allImages[m_currentIndex - 1];
                [_mainScrollView addSubview:nexZoomView];
            }
        }
    }
}

- (BOOL)validatePageIndex:(NSInteger)index {
    return (index >= 0 && index < _allImages.count);
}


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    m_beginPoint = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == m_beginPoint.x) {
        return;
    }
    
    m_scrollToRight = (scrollView.contentOffset.x > m_beginPoint.x);
    m_currentIndex = (NSInteger)(scrollView.contentOffset.x / JTTImagesBrowser_ScreenWidth);
    [self refreshMainScrollView];
}


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - JTTImageZoomViewDelegate

- (void)jtt_imageZoomViewDidTap {
    UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
    tmpImageView.image = _allImages[m_currentIndex];
    [self.superview addSubview:tmpImageView];
    self.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        tmpImageView.frame = m_srcImageViewRect;
    } completion:^(BOOL finished) {
        [tmpImageView removeFromSuperview];
    }];
}

@end
