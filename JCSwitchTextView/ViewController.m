//
//  ViewController.m
//  JCSwitchTextView
//
//  Created by mac on 15/12/9.
//  Copyright © 2015年 Jcdroid. All rights reserved.
//

#import "ViewController.h"
#import "JCSwitchTextView.h"

#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()

@property (strong, nonatomic) JCSwitchTextView *switchTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *textArray = @[@"#主要看气质#", @"#郑恺回应摔衣#", @"#空气污染红色预警#", @"#亚洲新歌榜#", @"#整容当网红#"];
    
    _switchTextView = ({
        JCSwitchTextView *switchTextView = [[JCSwitchTextView alloc] initWithFrame:CGRectMake(10, 40, kScreenWidth - 2 * 10, 40) iconImage:[UIImage imageNamed:@"search"] textArray:textArray timeInterval:2.0];
        [switchTextView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
        [self.view addSubview:switchTextView];
        switchTextView;
    });
}

- (void)dealloc {
    [_switchTextView endTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private M

- (void)click:(id)sender {
    NSLog(@"JCSwitchTextView clicked");
}

@end
