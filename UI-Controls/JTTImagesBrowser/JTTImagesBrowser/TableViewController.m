//
//  TableViewController.m
//  JTTImagesBrowser
//
//  Created by Jymn_Chen on 15/7/27.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import "TableViewController.h"
#import "JTTImagesBrowser.h"

@interface TableViewController ()

@property (nonatomic, strong) JTTImagesBrowser *browser;
@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageViews = [NSMutableArray array];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    for (NSInteger i = 0; i < 7; i++) {
        NSString *imgName = [NSString stringWithFormat:@"img%zd", i + 1];
        UIImage *image = [UIImage imageNamed:imgName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(8, 70 * i + 10, 60, 60);
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        [cell addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        
        [_imageViews addObject:imageView];
        
        if (_imageViews.count == 7) {
            self.browser = [[JTTImagesBrowser alloc] initWithImageViews:_imageViews.copy];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 500;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    UIImageView *imgView = (UIImageView *)(tap.view);
    [_browser showWithIndex:imgView.tag];
}

@end
