//
//  ViewController.m
//  倒计时
//
//  Created by zzz on 15/10/9.
//  Copyright (c) 2015年 zzz. All rights reserved.
//

#import "ViewController.h"
#import "CountDownView.h"


@interface ViewController ()
{
    
}
@property(nonatomic, strong) CountDownView * downV;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CountDownView * Circle =[CountDownView countDownViewWithFrame:CGRectMake(10, 40, 140, 140) type:CountDownViewTypeCircle andFinishblock:^(UIView *countDownView, CADisplayLink *link) {
        NSLog(@"%s",__func__);
    }];
    [Circle showInKeyWindowTop];
    
    
    CountDownView * Rect =[CountDownView countDownViewWithFrame:CGRectMake(160, 40, 140, 140) type:CountDownViewTypeRect andFinishblock:^(UIView *countDownView, CADisplayLink *link) {
        NSLog(@"%s",__func__);
    }];
    [self.view addSubview:Rect];
    
    
    
    
    CountDownView * downV =[CountDownView countDownViewWithFrame:CGRectMake(20, 200, 280, 80) type:CountDownViewTypeLine andFinishblock:^(UIView *countDownView, CADisplayLink *link) {
        NSLog(@"%s",__func__);
    }];
    [downV showInKeyWindowTop];
    
    
    CountDownView * downV1 =[CountDownView countDownViewWithFrame:CGRectMake(20, 300, 280, 40) type:CountDownViewTypePercent andFinishblock:^(UIView *countDownView, CADisplayLink *link) {
        NSLog(@"%s",__func__);
    }];
    [self.view addSubview:downV1];
    downV1.lineWidth = 30;
    
    
    self.downV = downV1;
    
}




- (void)tapAction:(UITapGestureRecognizer *)tap{
    CADisplayLink * link = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkLoop)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)linkLoop{
    self.downV.currentCount -= 1.0/60.0;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
