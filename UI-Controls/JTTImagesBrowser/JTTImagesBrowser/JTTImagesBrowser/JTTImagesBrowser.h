//
//  JTTImagesBrowser.h
//  JTTImagesBrowser
//
//  Created by Jymn_Chen on 15/7/26.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTTImagesBrowser : UIView

- (instancetype)initWithImageViews:(NSArray *)imageViewsArray;

- (void)showWithIndex:(NSInteger)index;

@end

// TODO
// 加入网络加载功能
