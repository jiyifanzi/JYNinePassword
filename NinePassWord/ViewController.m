//
//  ViewController.m
//  NinePassWord
//
//  Created by JiYi's on 16/8/19.
//  Copyright © 2016年 JiYi's. All rights reserved.
//

#import "ViewController.h"

//  九宫格解锁
#import "JYNinePassWord.h"

@interface ViewController ()<JYNinePassWordDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    JYNinePassWord * passWord = [[JYNinePassWord alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    passWord.backgroundColor = [UIColor whiteColor];
    passWord.delegate = self;
    
    [self.view addSubview:passWord];
}



- (void)lockView:(JYNinePassWord *)passWord didFinishPath:(NSString *)path {
    if ([path isEqualToString:@"012345678"]) {
        NSLog(@"密码正确");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码正确" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alert show];
        
    }else if(path.length == 9){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码错误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
