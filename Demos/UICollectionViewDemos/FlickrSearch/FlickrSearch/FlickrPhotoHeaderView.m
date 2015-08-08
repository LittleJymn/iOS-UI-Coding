//
//  FlickrPhotoHeaderView.m
//  FlickrSearch
//
//  Created by Jymn_Chen on 15/8/8.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import "FlickrPhotoHeaderView.h"

@implementation FlickrPhotoHeaderView

- (void)awakeFromNib {
    // Initialization code
}

-(void)setSearchText:(NSString *)text {
    self.searchLabel.text = text;
    UIImage *shareButtonImage = [[UIImage imageNamed:@"header_bg.png"] resizableImageWithCapInsets:
                                 UIEdgeInsetsMake(68, 68, 68, 68)];
    self.backgroundImageView.image = shareButtonImage;
    self.backgroundImageView.center = self.center;
}

@end
