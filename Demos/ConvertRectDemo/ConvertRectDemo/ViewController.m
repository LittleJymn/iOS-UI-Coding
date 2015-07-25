//
//  ViewController.m
//  ConvertRectDemo
//
//  Created by Jymn_Chen on 15/7/25.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIView *greenView;
@property (strong, nonatomic) IBOutlet UIView *redView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self demo_convertRectToView];
}

- (void)demo_convertRectToView {
    __unused CGPoint greenOrigin = _greenView.frame.origin;
    
    __unused CGRect redRect = _redView.frame;
    __unused CGRect convertRedRect = [_greenView convertRect:redRect toView:self.view];
    
    __unused CGRect redBounds = _redView.bounds;
    __unused CGRect convertRedBounds = [_greenView convertRect:redBounds toView:self.view];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __unused CGRect greenRect = _greenView.frame;
    __unused CGRect convertToWindowGreenRect = [_greenView convertRect:_greenView.frame toView:window];
    __unused CGRect greenBounds = _greenView.bounds;
    __unused CGRect convertToWindowGreenBounds = [_greenView convertRect:_greenView.bounds toView:window];
    
    NSLog(@"%s", __func__);
    
    /*
     
     srcView 在 superView 中的原点坐标是: (Xg, Yg)
     
     rect 在 srcView 中的值为 (Xr, Yr, W, H)
     
     convertRect = [srcView convertRect:rect toView:superView]
     
     那么 convertRect = (Xr + Xg, Yr + Yg, W, H)
     
     */
}

@end
