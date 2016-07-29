//
//  CountDownView.h
//  倒计时
//
//  Created by zzz on 15/10/9.
//  Copyright (c) 2015年 zzz. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^FinishCountDownBlock)(UIView *countDownView,CADisplayLink *link);


typedef enum : NSUInteger {
    CountDownViewTypeCircle,
    CountDownViewTypeRect,
    CountDownViewTypeLine,
    CountDownViewTypePercent
} CountDownViewType;

@interface CountDownView : UIView

/**
 *  倒计时最大时间
 */
@property(nonatomic, assign) CGFloat count;                //默认为: 10.00s

/**
 *  当前时间点（可以用作进度条）
 */
@property(nonatomic, assign) CGFloat currentCount;


@property(nonatomic, strong) UIColor * lineColor;           //默认为: Red:0.4 green:0 blue:0.8 alpha:0.6
@property(nonatomic, strong) UIColor * textColor;           //默认为: Red:0 green:0.4 blue:0.8 alpha:0.8
@property(nonatomic, strong) UIFont * textFont;             //默认为: 高度的一半

@property(nonatomic, assign) CGFloat lineWidth;             //默认为: 10.0

@property(nonatomic, assign) BOOL isTouchBegin;             //默认为: YES
@property(nonatomic, assign) BOOL isTouchEnd;               //默认为: YES
@property(nonatomic, assign) BOOL hiddenText;               //默认为: NO

@property(nonatomic, assign) CountDownViewType type;        // 默认为:CountDownViewTypeCircle
@property(nonatomic ,copy) FinishCountDownBlock finishblock;


+ (CountDownView *) countDownViewWithFrame:(CGRect)frame type:(CountDownViewType)type andFinishblock:(FinishCountDownBlock)block;


- (void)setFinishblock:(FinishCountDownBlock)finishblock;

- (void)beginCountDown;

/**
 *  此方法必须要有keyWindow，才有用
 */
- (void)showInKeyWindowTop;

@end
