//
//  ViewController.m
//  SizeToFitDemo
//
//  Created by Jymn_Chen on 15/8/13.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self sizeToFitDemo];
}

- (void)sizeToFitDemo {
    UIView * whiteView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 90, 90)];
    whiteView.backgroundColor = [UIColor greenColor];
    whiteView.clipsToBounds = YES;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor redColor];
    label.text = @"kkjkjkkjkjkjkjjkjkjkjjkjkkjkjkjkjk2222222222222";
    [whiteView addSubview:label];
    
    NSLog(@"the label bounds : %@", NSStringFromCGRect(label.frame));
    
    [label sizeToFit];
    
    NSLog(@"the label bounds : %@", NSStringFromCGRect(label.frame));
    
    [self.view addSubview:whiteView];
}

@end
