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
    
    NSMutableArray *imgs = [NSMutableArray array];
    for (NSInteger i = 0; i < 7; i++) {
        NSString *imageName = [NSString stringWithFormat:@"img%zd", i + 1];
        [imgs addObject:[UIImage imageNamed:imageName]];
    }
    self.browser = [[JTTImagesBrowser alloc] initWithImages:imgs.copy];
    [self.view addSubview:_browser];
}

- (IBAction)tapAction1:(id)sender {
    [_browser showWithImageView:_imageView1 index:0];
}
- (IBAction)tapAction2:(id)sender {
    [_browser showWithImageView:_imageView2 index:1];
}
- (IBAction)tapAction3:(id)sender {
    [_browser showWithImageView:_imageView3 index:2];
}
- (IBAction)tapAction4:(id)sender {
    [_browser showWithImageView:_imageView4 index:3];
}
- (IBAction)tapAction5:(id)sender {
    [_browser showWithImageView:_imageView5 index:4];
}
- (IBAction)tapAction6:(id)sender {
    [_browser showWithImageView:_imageView6 index:5];
}
- (IBAction)tapAction7:(id)sender {
    [_browser showWithImageView:_imageView7 index:6];
}

@end
