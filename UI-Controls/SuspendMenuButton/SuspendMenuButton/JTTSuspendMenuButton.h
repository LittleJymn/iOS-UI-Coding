//
//  JTTSuspendMenuButton.h
//  SuspendMenuButton
//
//  Created by Jymn_Chen on 15/8/17.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTTSuspendMenuButton : UIButton

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;

@end
