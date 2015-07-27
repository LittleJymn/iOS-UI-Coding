//
//  JTTImagesBrowser.h
//  JTTImagesBrowser
//
//  Created by Jymn_Chen on 15/7/26.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTTImagesBrowser : UIView

- (instancetype)initWithImages:(NSArray *)imagesArray;

- (void)showWithImageView:(UIImageView *)imageView
                    index:(NSInteger)index;

@end

// 隐藏到特定下标对应的视图
// 隐藏导航条和状态栏
