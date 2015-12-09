//
//  JCSwitchTextView.h
//  JCSwitchTextView
//
//  Created by Jcdroid on 15/12/8.
//  Copyright © 2015年 Jcdroid. All rights reserved.
//
//  原理：在UIView的layer中添加一个ScrollLayer，再给ScrolLayer添加两个TextLayer，通过计时器，定时更改ScrollLayer中得亮哥TextLayer的frame以达到向上滚动的效果

#import <UIKit/UIKit.h>

@interface JCSwitchTextView : UIView

- (instancetype)initWithFrame:(CGRect)frame iconImage:(UIImage *)image textArray:(NSArray *)textArray timeInterval:(NSTimeInterval)timeInterval;

- (void)endTimer;

@end
