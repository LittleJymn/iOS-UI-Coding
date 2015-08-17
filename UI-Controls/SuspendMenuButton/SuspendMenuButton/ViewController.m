//
//  ViewController.m
//  SuspendMenuButton
//
//  Created by Jymn_Chen on 15/8/17.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import "ViewController.h"
#import "JTTSuspendMenuButton.h"

@interface ViewController ()

@property (nonatomic, strong) JTTSuspendMenuButton *btn;

@end

@implementation ViewController
@synthesize btn;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btn = [JTTSuspendMenuButton new];
    btn.backgroundColor = [UIColor greenColor];
    btn.frame = CGRectMake(100, 100, 36, 36);
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [btn willRotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [btn didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

@end
