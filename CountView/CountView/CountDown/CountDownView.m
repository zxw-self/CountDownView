//
//  CountDownView.m
//  倒计时
//
//  Created by zzz on 15/10/9.
//  Copyright (c) 2015年 zzz. All rights reserved.
//

#import "CountDownView.h"


@interface CountDownView ()


@property (nonatomic, strong) CADisplayLink * link;
@property (nonatomic, strong) UILabel * label;

@property(nonatomic, strong) UITapGestureRecognizer * tap;
@property(nonatomic, strong) UITapGestureRecognizer * doubelTap;


@end

@implementation CountDownView


+ (CountDownView *)countDownViewWithFrame:(CGRect)frame type:(CountDownViewType)type andFinishblock:(FinishCountDownBlock)block{
    CountDownView * downV = [[CountDownView alloc] initWithFrame:frame];
    downV.type = type;
    downV.finishblock = block;
    return downV;
}
- (void)beginCountDown{
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)showInKeyWindowTop{
    
    if ([UIApplication sharedApplication].keyWindow) {
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
    }else{
        NSLog(@"keyWindow = %@",[UIApplication sharedApplication].keyWindow);
    }
    
}




#pragma mark - 复写方法
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.2 blue:0.6 alpha:0.4];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginAndEndLink)];
        [self addGestureRecognizer:tap];
        
        self.lineWidth = 10;
        self.count = 10;
        self.lineColor = [UIColor colorWithRed:0 green:0.4 blue:0.8 alpha:0.8];
        self.isTouchBegin = YES;
        self.isTouchEnd = YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.label.frame = self.bounds;
}





// 开始画图
- (void)drawRect:(CGRect)rect{
    
    
    if (self.type == CountDownViewTypePercent) {
        self.label.text = [NSString stringWithFormat:@"%0.2f％",(1.0 - (_currentCount / self.count)) * 100];
    }else{
        
        int index =  (self.count == _currentCount)?(int)_currentCount:(int)_currentCount +1;
        index = _currentCount <= 0 ? 0 : index;
        self.label.text = [NSString stringWithFormat:@"%d",index];
        
    }
    
    if (self.type == CountDownViewTypeLine || self.type == CountDownViewTypePercent) {
        
        // 1.开启上下文
        CGContextRef context = UIGraphicsGetCurrentContext();

        
        CGFloat Width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        
        CGFloat Now = Width * (_currentCount / self.count);
        
        CGContextAddRect(context, CGRectMake(0, height - self.lineWidth -5,Width - Now, self.lineWidth));
        
        CGContextSetLineWidth(context, self.lineWidth);
        [(self.lineColor)?self.lineColor:[UIColor blackColor] set];
        
        CGContextSetLineCap(context, kCGLineCapRound);
        
        CGContextFillPath(context);
        
        return;
    }
    // 1.开启上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);
    
    CGFloat radius = (CGRectGetWidth(self.bounds) / 2.0) - 10;
    
    CGFloat startAngle = M_PI * 1.5;
    
    CGFloat endAngle = startAngle + (M_PI * 2.0) * (_currentCount / self.count);
    
    // 0 表示顺时针
    CGContextAddArc(context, centerX, centerY, radius, startAngle, endAngle, 0);
    
    CGContextSetLineWidth(context, self.lineWidth);
    [(self.lineColor)?self.lineColor:[UIColor blackColor] setStroke];

    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextStrokePath(context);
}





#pragma mark - 私有方法
- (void)beginAndEndLink{
    if (_link && self.isTouchEnd) {
        
        [_link invalidate];
        _link = nil;
        
        return;
    
    }else if (_currentCount <= 0 || (!self.isTouchBegin)) {
        
        return;
    }
    
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}




// 每秒调用60次
- (void) linkLoop{
    
    [self setNeedsDisplay];
    
    if (_currentCount <= 0) {
        [_link invalidate];
        
        if (self.finishblock) {
            self.finishblock(self,_link);
        }
        return;
    }
    
    _currentCount -= 1 / 60.000000;
}







- (CADisplayLink *)link{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkLoop)];
        
    }
    return _link;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:self.frame.size.height / 2.0];
        [_label setTextColor:[UIColor colorWithRed:0.4 green:0 blue:0.8 alpha:0.6]];
        [self addSubview:_label];
    }
    return _label;
}



- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    [self.label setTextColor:_textColor];
}



- (void)setCount:(CGFloat)count{
    _count = count;
    _currentCount = _count;
}
- (void)setCurrentCount:(CGFloat)currentCount{
    _currentCount = currentCount;
    [self setNeedsDisplay];
}


- (void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
    self.label.font = textFont;
}

- (void)setType:(CountDownViewType)type{
    _type = type;
    
    if (_type == CountDownViewTypeCircle) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width/2.0;

    } else if (_type == CountDownViewTypeRect){
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 1;
        
    }else if (_type == CountDownViewTypeRect){
        
        
    }
}

- (void)setHiddenText:(BOOL)hiddenText{
    _hiddenText = hiddenText;
    self.label.hidden = _hiddenText;
    
}






@end
