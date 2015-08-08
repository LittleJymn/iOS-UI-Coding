//
//  ViewController.m
//  FlickrSearch
//
//  Created by Jymn_Chen on 15/8/8.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import "ViewController.h"
#import "FlickrPhotoCell.h"
#import "FlickrPhotoHeaderView.h"


///////////////////////////////////////////////////////////////////////////////////////////


@interface ViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign, getter=isSharing) BOOL sharing;
@property(nonatomic, strong) NSMutableArray *searchResults;
@property(nonatomic, strong) NSMutableArray *selectedPhotos;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sharing = NO;
    self.searchResults = [@[] mutableCopy];
    self.selectedPhotos = [@[] mutableCopy];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    
    UIImage *navBarImage = [[UIImage imageNamed:@"navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(27, 27, 27, 27)];
    [self.toolbar setBackgroundImage:navBarImage forToolbarPosition:UIToolbarPositionAny
                          barMetrics:UIBarMetricsDefault];
    
    UIImage *shareButtonImage = [[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.shareButton setBackgroundImage:shareButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *textFieldImage = [[UIImage imageNamed:@"search_field.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.textField setBackground:textFieldImage];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FlickrPhotoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FlickrCell"];
}


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - UITextFieldDelegate methods

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [_searchResults addObject:@"http://f.hiphotos.baidu.com/image/pic/item/11385343fbf2b211c664bd26c88065380cd78e0b.jpg"];
    [_searchResults addObject:@"http://d.hiphotos.baidu.com/image/pic/item/1b4c510fd9f9d72afb759714d62a2834349bbba2.jpg"];
    [_searchResults addObject:@"http://f.hiphotos.baidu.com/image/pic/item/7a899e510fb30f24e7689976ca95d143ac4b03d0.jpg"];
    
    [textField resignFirstResponder];
    
    [self.collectionView reloadData];
    
    return YES; 
}


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return _searchResults.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlickrPhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSString *urlstring = _searchResults[indexPath.row];
    [cell configWithURLString:urlstring];
    
    return cell;
}

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    FlickrPhotoHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                         UICollectionElementKindSectionHeader withReuseIdentifier:@"FlickrPhotoHeaderView" forIndexPath:indexPath];
    NSString *text = [NSString stringWithFormat:@"Section %zd", indexPath.section];
    [headerView setSearchText:text];
    
    return headerView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSharing) {
        NSString *urlstring = _searchResults[indexPath.row];
        [_selectedPhotos addObject:urlstring];
    }
    else {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Tap" message:[NSString stringWithFormat:@"Section%zd Row%zd", indexPath.section, indexPath.row] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSharing) {
        NSString *urlstring = _searchResults[indexPath.row];
        [_selectedPhotos removeObject:urlstring];
    }
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        NSInteger x = indexPath.row % 3;
//        if (x == 0) {
//            return CGSizeMake(200, 300);
//        }
//        else if (x == 2) {
//            return CGSizeMake(250, 150);
//        }
//        
//        return CGSizeMake(100, 100);
//    }
//    else {
//        NSInteger x = indexPath.row % 3;
//        if (x == 0) {
//            return CGSizeMake(400, 100);
//        }
//        else if (x == 2) {
//            return CGSizeMake(50, 150);
//        }
//        
//        return CGSizeMake(100, 100);
//    }
    
    return CGSizeMake(100, 100);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    // collectionView:layout:insetForSectionAtIndex: returns the spacing between the cells, headers, and footers.
    return UIEdgeInsetsMake(50, 20, 50, 20);
}


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Button Actions

- (IBAction)shareButtonTapped:(id)sender {
    UIBarButtonItem *shareButton = (UIBarButtonItem *)sender;
    if (self.isSharing == NO) {
        self.sharing = YES;
        [shareButton setTitle:@"Done"];
        [_collectionView setAllowsMultipleSelection:YES];
    }
    else {
        self.sharing = NO;
        [shareButton setTitle:@"Share"];
        [_collectionView setAllowsMultipleSelection:NO];
        if ([_selectedPhotos count] > 0) {
            [[[UIAlertView alloc] initWithTitle:@"Finish Selecting" message:_selectedPhotos.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        
        for (NSIndexPath *indexPath in _collectionView.indexPathsForSelectedItems) {
            [_collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }
        [_selectedPhotos removeAllObjects];
    }
}

@end
