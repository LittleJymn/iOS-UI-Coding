//
//  JTTImageZoomView.h
//  JTTImagesBrowser
//
//  Created by Jymn_Chen on 15/7/26.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTTImageZoomViewDelegate <NSObject>
- (void)jtt_imageZoomViewDidTapAtIndex:(NSInteger)index;
@end

@interface JTTImageZoomView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame
                        image:(UIImage *)image
                        index:(NSInteger)index
                     delegate:(id<JTTImageZoomViewDelegate>)aDelegate;

@end
