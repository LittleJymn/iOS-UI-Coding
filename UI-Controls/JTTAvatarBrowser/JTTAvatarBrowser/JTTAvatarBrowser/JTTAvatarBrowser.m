//
//  JTTAvatarBrowser.m
//  JTTAvatarBrowser
//
//  Created by Jymn_Chen on 15/7/25.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import "JTTAvatarBrowser.h"

#define JTTAvatarBrowser_ScreenWidth    [UIScreen mainScreen].bounds.size.width
#define JTTAvatarBrowser_ScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface JTTAvatarBrowser ()
{
    CGRect m_originFrame;
    BOOL m_viewDidConfig;
}

@property (nonatomic, strong) UIImageView *zoomImageView;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation JTTAvatarBrowser


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Init

- (void)commonInit {
    m_viewDidConfig = NO;
    
    _zoomImageView = [[UIImageView alloc] initWithImage:self.image];
    _zoomImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backgroundView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInBackgroundViewAction:)];
    [_backgroundView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapInSelf = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInSelfAction:)];
    [self addGestureRecognizer:tapInSelf];
    self.userInteractionEnabled = YES;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Dealloc

- (void)dealloc {
    _zoomImageView = nil;
    _backgroundView = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - iVars Accessors

- (void)setImage:(UIImage *)image {
    if (_zoomImageView) {
        // 通过非 initWithImage: 或 initWithImage:highlightedImage: 方法初始化 self 时，
        // _zoomImageView.image 为 nil，所以这里要为其赋值
        _zoomImageView.image = image;
    }
    
    [super setImage:image];
}


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Gesture Actions

- (void)tapInBackgroundViewAction:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.hidden = YES;
        _zoomImageView.frame = m_originFrame;
        self.frame = m_originFrame;
    }];
}

- (void)tapInSelfAction:(id)sender {
    if (m_viewDidConfig == NO) {
        // 必须在 [window makeKeyAndVisible] 后获取 keyWindow，否则会获取到 nil
        // 在用户点击图片触发该方法时，可以保证 viewDidAppear 已经完成，所以获取到的 keyWindow 必定不为 nil
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        m_originFrame = self.frame;
        _zoomImageView.frame = m_originFrame;
        [_backgroundView addSubview:_zoomImageView];
        _backgroundView.hidden = YES;
        [window addSubview:_backgroundView];
        
        m_viewDidConfig = YES;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        double horScaleFactor = JTTAvatarBrowser_ScreenWidth / self.image.size.width;
        double verScaleFactor = JTTAvatarBrowser_ScreenHeight / self.image.size.height;
        double scaleFactor = (horScaleFactor < verScaleFactor) ? horScaleFactor : verScaleFactor;
        _zoomImageView.bounds = CGRectMake(0,
                                           0,
                                           self.image.size.width * scaleFactor,
                                           self.image.size.height * scaleFactor);
        _zoomImageView.center = _backgroundView.center;
        _backgroundView.hidden = NO;
        
    } completion:^(BOOL finished) {
        self.frame = _zoomImageView.frame;
    }];
}

@end
