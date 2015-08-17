//
//  JTTSuspendMenuButton.m
//  SuspendMenuButton
//
//  Created by Jymn_Chen on 15/8/17.
//  Copyright (c) 2015年 com.jymnchen. All rights reserved.
//

#import "JTTSuspendMenuButton.h"


///////////////////////////////////////////////////////////////////////////////////////////


static CGFloat const kJTTPadding = 5;
static CGFloat const kJTTVerticalSpacing = 60;

@interface JTTSuspendMenuButton ()

@property (nonatomic, assign) CGPoint beginPoint;

@end

@implementation JTTSuspendMenuButton


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addTarget:self action:@selector(showMenuAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didMoveToSuperview {
    [self commitFadeInAnimation];
}


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Animations

- (CGRect)calculateLastFrame {
    float marginLeft = self.frame.origin.x;
    float marginRight = self.superview.frame.size.width - self.frame.origin.x - self.frame.size.width;
    float marginTop = self.frame.origin.y;
    float marginBottom = self.superview.frame.size.height - self.frame.origin.y - self.frame.size.height;
    
    if (marginTop < kJTTVerticalSpacing) {
        CGFloat x = 0;
        if (marginLeft < marginRight) {
            if (marginLeft < kJTTPadding) {
                x = kJTTPadding;
            }
            else {
                x = CGRectGetMinX(self.frame);
            }
        }
        else {
            if (marginRight < kJTTPadding) {
                x = CGRectGetWidth(self.superview.frame) - CGRectGetWidth(self.frame) - kJTTPadding;
            }
            else {
                x = CGRectGetMinX(self.frame);
            }
        }
        
        CGRect frame = self.frame;
        frame.origin.x = x;
        frame.origin.y = kJTTPadding;
        
        return frame;
    }
    else if (marginBottom < kJTTVerticalSpacing) {
        CGFloat x = 0;
        if (marginLeft < marginRight) {
            if (marginLeft < kJTTPadding) {
                x = kJTTPadding;
            }
            else {
                x = CGRectGetMinX(self.frame);
            }
        }
        else {
            if (marginRight < kJTTPadding) {
                x = CGRectGetWidth(self.superview.frame) - CGRectGetWidth(self.frame) - kJTTPadding;
            }
            else {
                x = CGRectGetMinX(self.frame);
            }
        }
        
        CGRect frame = self.frame;
        frame.origin.x = x;
        frame.origin.y = CGRectGetHeight(self.superview.frame) - CGRectGetHeight(self.frame) - kJTTPadding;

        return frame;
    }
    else {
        CGFloat x = 0;
        if (marginLeft < marginRight) {
            x = kJTTPadding;
        }
        else {
            x = CGRectGetWidth(self.superview.frame) - CGRectGetWidth(self.frame) - kJTTPadding;
        }
        
        CGRect frame = self.frame;
        frame.origin.x = x;
        
        return frame;
    }
}

- (void)commitAdsorbAnimation {
    if (self.superview) {
        CGRect frame = [self calculateLastFrame];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = frame;
        } completion:^(BOOL finished) {
            ;
        }];
    }
}

- (void)commitFadeInAnimation {
    if (self.superview) {
        self.hidden = YES;
        CGRect frame = [self calculateLastFrame];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = frame;
        } completion:^(BOOL finished) {
            self.hidden = NO;
        }];
    }
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = YES;
    
    UITouch *touch = [touches anyObject];
    self.beginPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
    
    UITouch *touch = [touches anyObject];
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - self.beginPoint.x;
    float offsetY = nowPoint.y - self.beginPoint.y;
    
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.highlighted) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
        self.highlighted = NO;
    }
    
    [self commitAdsorbAnimation];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.highlighted) {
        self.highlighted = NO;
    }
    
    [self commitAdsorbAnimation];
}

#pragma mark - Rotate

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    self.hidden = YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self commitFadeInAnimation];
}


///////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Button Actions

- (void)showMenuAction:(id)sender {
    NSLog(@"Show Menu");
}

@end
