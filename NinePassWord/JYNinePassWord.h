//
//  JYNinePassWord.h
//  NinePassWord
//
//  Created by JiYi's on 16/8/19.
//  Copyright © 2016年 JiYi's. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYNinePassWord;

@protocol JYNinePassWordDelegate <NSObject>

- (void)lockView:(JYNinePassWord *)passWord didFinishPath:(NSString *)path;

@end


@interface JYNinePassWord : UIView

//  按钮的数组
@property (nonatomic, strong) NSMutableArray * buttonArray;
//  当前的触摸点
@property (nonatomic, assign) CGPoint currentPoint;

//  代理
@property (nonatomic, weak) id<JYNinePassWordDelegate>delegate;


- (void)hideTopView;


@end
