//
//  FlickrPhotoCell.m
//  FlickrSearch
//
//  Created by Jymn_Chen on 15/8/8.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import "FlickrPhotoCell.h"

@interface FlickrPhotoCell ()

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation FlickrPhotoCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        bgView.backgroundColor = [UIColor blueColor];
        bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
        bgView.layer.borderWidth = 4;
        self.selectedBackgroundView = bgView;
    }
    return self;
}

- (void)configWithURLString:(NSString *)urlstring {
    NSURL *url = [NSURL URLWithString:urlstring];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            _photoImageView.image = img;
        });
    });
}

@end
