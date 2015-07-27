//
//  JTTImageZoomView.h
//  JTTImagesBrowser
//
//  Created by Jymn_Chen on 15/7/26.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTTImageZoomViewDelegate <NSObject>
- (void)jtt_imageZoomViewDidTap;
@end

@interface JTTImageZoomView : UIScrollView

@property (nonatomic, weak) id<JTTImageZoomViewDelegate> jttDelegate;

- (void)setImage:(UIImage *)image;

@end
