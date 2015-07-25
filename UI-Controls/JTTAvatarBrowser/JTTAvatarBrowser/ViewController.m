//
//  ViewController.m
//  JTTAvatarBrowser
//
//  Created by Jymn_Chen on 15/7/25.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import "ViewController.h"
#import "JTTAvatarBrowser.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *sbImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test_initWithFrame];
//    [self test_initWithImage];
//    [self test_initWithImageHighlightedImage];
//    [self test_initWithStoryboard];
    [self test_initWithXIB];
}

- (void)test_initWithFrame {
    JTTAvatarBrowser *imageView = [[JTTAvatarBrowser alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    imageView.image = [UIImage imageNamed:@"img2.jpg"];
    [self.view addSubview:imageView];
}

- (void)test_initWithImage {
    JTTAvatarBrowser *imageView = [[JTTAvatarBrowser alloc] initWithImage:[UIImage imageNamed:@"img1.jpg"]];
    imageView.frame = CGRectMake(0, 0, 200, 200);
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
}

- (void)test_initWithImageHighlightedImage {
    UIView *greenView = [UIView new];
    greenView.backgroundColor = [UIColor greenColor];
    greenView.frame = CGRectMake(50, 50, 250, 250);
    [self.view addSubview:greenView];
    
    UIView *redView = [UIView new];
    redView.backgroundColor = [UIColor redColor];
    redView.frame = CGRectMake(0, 0, 50, 50);
    [greenView addSubview:redView];
    
    JTTAvatarBrowser *imageView = [[JTTAvatarBrowser alloc] initWithImage:[UIImage imageNamed:@"img1.jpg"] highlightedImage:[UIImage imageNamed:@"img2.jpg"]];
    imageView.frame = CGRectMake(50, 50, 100, 100);
    [greenView addSubview:imageView];
}

- (void)test_initWithStoryboard {
    _sbImageView.hidden = NO;
}

- (void)test_initWithXIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"View" owner:nil options:nil];
    JTTAvatarBrowser *imageView = views[0];
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
}

@end
