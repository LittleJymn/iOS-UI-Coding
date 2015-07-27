//
//  ViewController.m
//  JTTImagesBrowser
//
//  Created by Jymn_Chen on 15/7/26.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import "ViewController.h"
#import "JTTImagesBrowser.h"

@interface ViewController ()

@property (nonatomic, strong) JTTImagesBrowser *browser;

@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;
@property (strong, nonatomic) IBOutlet UIImageView *imageView3;
@property (strong, nonatomic) IBOutlet UIImageView *imageView4;
@property (strong, nonatomic) IBOutlet UIImageView *imageView5;
@property (strong, nonatomic) IBOutlet UIImageView *imageView6;
@property (strong, nonatomic) IBOutlet UIImageView *imageView7;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSMutableArray *imgs = [NSMutableArray array];
//    for (NSInteger i = 0; i < 7; i++) {
//        NSString *imageName = [NSString stringWithFormat:@"img%zd", i + 1];
//        [imgs addObject:[UIImage imageNamed:imageName]];
//    }
    
    NSArray *imageViews = @[_imageView1, _imageView2, _imageView3, _imageView4, _imageView5, _imageView6, _imageView7];
    self.browser = [[JTTImagesBrowser alloc] initWithImageViews:imageViews.copy];
}

- (IBAction)tapAction1:(id)sender {
    [_browser showWithIndex:0];
}
- (IBAction)tapAction2:(id)sender {
    [_browser showWithIndex:1];
}
- (IBAction)tapAction3:(id)sender {
    [_browser showWithIndex:2];
}
- (IBAction)tapAction4:(id)sender {
    [_browser showWithIndex:3];
}
- (IBAction)tapAction5:(id)sender {
    [_browser showWithIndex:4];
}
- (IBAction)tapAction6:(id)sender {
    [_browser showWithIndex:5];
}
- (IBAction)tapAction7:(id)sender {
    [_browser showWithIndex:6];
}

@end
