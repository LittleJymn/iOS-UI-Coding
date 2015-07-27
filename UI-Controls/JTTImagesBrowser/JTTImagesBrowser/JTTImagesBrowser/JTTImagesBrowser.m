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
    BOOL m_viewDidConfig;
    NSInteger m_currentIndex;
    CGPoint m_beginPoint;
    BOOL m_scrollToRight;
}

@property (nonatomic, copy) NSArray *srcImageViews;
@property (nonatomic, copy) NSArray *allImages;

@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation JTTImagesBrowser


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Init

- (instancetype)initWithImageViews:(NSArray *)imageViewsArray {
    if (imageViewsArray == nil || imageViewsArray.count == 0) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        m_viewDidConfig = NO;
        m_currentIndex = 0;
        _srcImageViews = imageViewsArray;
        NSMutableArray *images = [NSMutableArray array];
        for (UIImageView *imgView in imageViewsArray) {
            if (imgView.image == nil) {
                return nil;
            }
            [images addObject:imgView.image];
        }
        _allImages = [images copy];
        
        self.backgroundColor = [UIColor blackColor];
        self.frame = [UIScreen mainScreen].bounds;
        self.hidden = YES;
        
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
    m_viewDidConfig = NO;
    m_currentIndex = 0;
    m_beginPoint = CGPointZero;
    m_scrollToRight = NO;
    _srcImageViews = nil;
    _allImages = nil;
    _mainScrollView = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Public Methods

- (void)showWithIndex:(NSInteger)index {
    if ([self configSourceImageZoomViewsWithCurrentIndex:index] == NO) {
        return;
    }
    
    if (m_viewDidConfig == NO) {
        // 必须在 [window makeKeyAndVisible] 后获取 keyWindow，否则会获取到 nil
        // 在用户点击图片触发该方法时，可以保证 viewDidAppear 已经完成，所以获取到的 keyWindow 必定不为 nil
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
        m_viewDidConfig = YES;
    }
    
    UIImageView *srcImageView = _srcImageViews[index];
    if (srcImageView) {
        CGRect srcRect = [srcImageView.superview convertRect:srcImageView.frame toView:self.superview];
        UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:srcRect];
        tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
        tmpImageView.image = srcImageView.image;
        [self.superview addSubview:tmpImageView];
        
        [UIView animateWithDuration:0.3 animations:^{
            tmpImageView.frame = self.bounds;
        } completion:^(BOOL finished) {
            [tmpImageView removeFromSuperview];
            self.hidden = NO;
        }];
    }
}

#pragma mark - Private Methods

- (BOOL)configSourceImageZoomViewsWithCurrentIndex:(NSInteger)index {
    if ([self validatePageIndex:index] == NO) {
        return NO;
    }
    m_currentIndex = index;
    
    for (UIView *zoomView in _mainScrollView.subviews) {
        [zoomView removeFromSuperview];
    }
    
    CGRect curRect = self.bounds;
    CGFloat srcX = JTTImagesBrowser_ScreenWidth * m_currentIndex;
    curRect.origin.x = srcX;
    JTTImageZoomView *curZoomView = [[JTTImageZoomView alloc] initWithFrame:curRect
                                                                      image:_allImages[m_currentIndex]
                                                                      index:m_currentIndex
                                                                   delegate:self];
    curZoomView.tag = JTTImagesBrowser_ImageZoomViewTag(m_currentIndex);
    [_mainScrollView addSubview:curZoomView];
    
    if ([self validatePageIndex:m_currentIndex - 1]) {
        CGRect preRect = self.bounds;
        preRect.origin.x = srcX - JTTImagesBrowser_ScreenWidth;
        JTTImageZoomView *preZoomView = [[JTTImageZoomView alloc] initWithFrame:preRect
                                                                          image:_allImages[m_currentIndex - 1]
                                                                          index:(m_currentIndex - 1)
                                                                       delegate:self];
        preZoomView.tag = JTTImagesBrowser_ImageZoomViewTag(m_currentIndex - 1);
        [_mainScrollView addSubview:preZoomView];
    }
    
    if ([self validatePageIndex:m_currentIndex + 1]) {
        CGRect nexRect = self.bounds;
        nexRect.origin.x = srcX + JTTImagesBrowser_ScreenWidth;
        JTTImageZoomView *nexZoomView = [[JTTImageZoomView alloc] initWithFrame:nexRect
                                                                          image:_allImages[m_currentIndex + 1]
                                                                          index:(m_currentIndex + 1)
                                                                       delegate:self];
        nexZoomView.tag = JTTImagesBrowser_ImageZoomViewTag(m_currentIndex + 1);
        [_mainScrollView addSubview:nexZoomView];
    }
    [_mainScrollView scrollRectToVisible:curZoomView.frame animated:NO];
    
    return YES;
}

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
                JTTImageZoomView *nexZoomView = [[JTTImageZoomView alloc] initWithFrame:nexRect
                                                                                  image:_allImages[m_currentIndex + 1]
                                                                                  index:(m_currentIndex + 1)
                                                                               delegate:self];
                nexZoomView.tag = JTTImagesBrowser_ImageZoomViewTag(m_currentIndex + 1);
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
                JTTImageZoomView *nexZoomView = [[JTTImageZoomView alloc] initWithFrame:nexRect
                                                                                  image:_allImages[m_currentIndex - 1]
                                                                                  index:(m_currentIndex - 1)
                                                                               delegate:self];
                nexZoomView.tag = JTTImagesBrowser_ImageZoomViewTag(m_currentIndex - 1);
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    m_currentIndex = (NSInteger)(scrollView.contentOffset.x / JTTImagesBrowser_ScreenWidth);
}


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - JTTImageZoomViewDelegate

- (void)jtt_imageZoomViewDidTapAtIndex:(NSInteger)index {
    UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
    tmpImageView.image = _allImages[m_currentIndex];
    [self.superview addSubview:tmpImageView];
    
    self.hidden = YES;
    UIImageView *srcImageView = _srcImageViews[index];
    CGRect srcRect = [srcImageView.superview convertRect:srcImageView.frame toView:self.superview];
    
    [UIView animateWithDuration:0.3 animations:^{
        tmpImageView.frame = srcRect;
    } completion:^(BOOL finished) {
        [tmpImageView removeFromSuperview];
    }];
}

@end
