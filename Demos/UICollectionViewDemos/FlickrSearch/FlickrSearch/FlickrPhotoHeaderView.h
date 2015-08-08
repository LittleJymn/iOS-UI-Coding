//
//  FlickrPhotoHeaderView.h
//  FlickrSearch
//
//  Created by Jymn_Chen on 15/8/8.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPhotoHeaderView : UICollectionReusableView

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UILabel *searchLabel;

-(void)setSearchText:(NSString *)text;

@end
