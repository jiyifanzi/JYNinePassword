//
//  JYNinePassWord.m
//  NinePassWord
//
//  Created by JiYi's on 16/8/19.
//  Copyright © 2016年 JiYi's. All rights reserved.
//

#import "JYNinePassWord.h"

@interface JYNinePassWord  ()

//  顶部的小窗口
@property (nonatomic, strong) UIView * topView;

@property (nonatomic, strong) NSMutableArray * topBtnArray;

@end

@implementation JYNinePassWord

//#pragma mark - 懒加载
- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}
- (NSMutableArray *)topBtnArray {
    if (!_topBtnArray) {
        _topBtnArray = [NSMutableArray array];
    }
    return _topBtnArray;
}


#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {

    if (self == [super initWithFrame:frame]) {
        
        
        _topView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2.0f - 40, 30, 80, 80)];
        _topView.userInteractionEnabled = NO;
        [self addSubview:_topView];
        
        
        //  初始化顶部小图的UIButton
        for (int i = 0; i < 9; i++) {
            UIButton * button  = [UIButton buttonWithType:UIButtonTypeCustom];
            button.userInteractionEnabled = NO;
            [button setBackgroundImage:[UIImage imageNamed:@"black"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateSelected];
            [self.topView addSubview:button];
            
            //  遍历设置9个button的frame
            CGFloat width = 20;
            CGFloat height = 20;
            CGFloat Margin=(80 - 3 * width) / 4;
            
            int row = i / 3;
            int col = i % 3;
            button.tag = i + 100;
            button.frame = CGRectMake(col * (Margin + width) + Margin, row * (Margin +height) + Margin, width, height);
            
            [self.topBtnArray addObject:button];
        }
        
        
        //  初始化所有的按钮
        for (int i = 0; i < 9; i++) {
            UIButton * button  = [UIButton buttonWithType:UIButtonTypeCustom];
            button.userInteractionEnabled = NO;
            [button setBackgroundImage:[UIImage imageNamed:@"black"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateSelected];
            [self addSubview:button];
            //  遍历设置9个button的frame
            CGFloat width=74;
            CGFloat height=74;
            CGFloat Margin=(self.bounds.size.width-3*width)/4;
            
            button.tag= i;
            int row = i / 3;
            int col = i % 3;
            button.frame = CGRectMake(col * (Margin + width) + Margin, row * (Margin +height) + 170, width, height);
        }
    }
    return self;
}


#pragma mark - 获取触摸的点
- (CGPoint)pointWithTouch:(NSSet *)touches {
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    return point;
}
#pragma mark - 根据触摸的点获取按钮
- (UIButton *)buttonWithPoint:(CGPoint)point{
    
    NSMutableArray * btnSubViews = [NSMutableArray array];
    for (UIView * tempView in self.subviews) {
        if ([tempView isKindOfClass:[UIButton class]]) {
            [btnSubViews addObject:tempView];
        }
    }
    
    
    for (UIButton * button in btnSubViews) {
        if (CGRectContainsPoint(button.frame, point)) {
            return button;
        }
    }
    return nil;
}


#pragma mark - 触摸的代理方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //  先遍历topView的TopBtn，让所有的顶部按钮都为不选中
    for (UIButton * topBtn in self.topBtnArray) {
        topBtn.selected = NO;
    }
    
    
    //  取到触摸的点
    CGPoint point = [self pointWithTouch:touches];
    //  根据触摸的点，获取按钮
    UIButton * touchBtn = [self buttonWithPoint:point];
    if (touchBtn && touchBtn.selected == NO) {
        touchBtn.selected = YES;
        //  将这个点保存
        [self.buttonArray addObject:touchBtn];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //  移动的时候，也拿到触摸的点
    CGPoint point = [self pointWithTouch:touches];
    //  根据触摸点，获取按钮
    UIButton * touchBtn = [self buttonWithPoint:point];
    if (touchBtn && touchBtn.selected == NO) {
        touchBtn.selected = YES;
        //  继续添加
        [self.buttonArray addObject:touchBtn];
    }else {
        self.currentPoint = point;
    }
    //  重新绘制
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //  触摸结束的时候
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(lockView:didFinishPath:)]) {
        //  拥有代理，并且代理实现了代理方法
        NSMutableString * lockPath = [NSMutableString string];
        for (UIButton * tempBtn in self.buttonArray) {
            //  从数组中获取按钮的tag值，用来确定路径
            [lockPath appendFormat:@"%ld",tempBtn.tag];
            
            //  根据lockPath来让顶部的小图显示
            for (UIButton * topTempBtn in self.topBtnArray) {
                if (tempBtn.tag == topTempBtn.tag - 100) {
                    topTempBtn.selected = YES;
                }
            }
        }
        [self.delegate lockView:self didFinishPath:lockPath];
    }
    

    
    //  让按钮取消选择状态
    NSMutableArray * btnSubViews = [NSMutableArray array];
    for (UIView * tempView in self.subviews) {
        if ([tempView isKindOfClass:[UIButton class]]) {
            [btnSubViews addObject:tempView];
        }
    }
    
    for (UIButton * tempBtn in btnSubViews) {
        tempBtn.selected = NO;
    }
    
    //  清空
    [self.buttonArray removeAllObjects];
    
    //  重新绘制
    [self setNeedsDisplay];
}


- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}



#pragma mark - 重新绘图
- (void)drawRect:(CGRect)rect {
    if (self.buttonArray.count == 0) {
        return;
    }
    
    UIBezierPath * lockPath = [UIBezierPath bezierPath];
    lockPath.lineWidth = 8;
    lockPath.lineJoinStyle = kCGLineCapRound;
    
    [[UIColor colorWithRed:32/255.0 green:210/255.0 blue:254/255.0 alpha:1.0]set];
    
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //  遍历
        if (idx == 0) {
            //  设置起点
            [lockPath moveToPoint:obj.center];
        }else {
            [lockPath addLineToPoint:obj.center];
        }
    }];
    //  设置终点
    [lockPath addLineToPoint:self.currentPoint];
    [lockPath stroke];
}


#pragma mark - 外部提供的一些方法
- (void)hideTopView {
    self.topView.hidden = YES;
}




@end
