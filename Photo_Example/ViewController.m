//
//  ViewController.m
//  Photo_Example
//
//  Created by YiMan on 16/5/9.
//  Copyright © 2016年 Ecar. All rights reserved.
//

#import "ViewController.h"
#import "YQAssetOperator.h"

#define WeakSelf(type)  __weak typeof(type) weak##type = type;

@interface ViewController (){
    YQAssetOperator *_assetOperator;
}

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

- (IBAction)deleteFile:(UIButton *)sender;
- (IBAction)addFiles:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    _assetOperator = [YQAssetOperator defaultOperator];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteFile:(UIButton *)sender {
    NSString *videoPath =[[NSBundle mainBundle] pathForResource:@"0425_103546" ofType:@"mp4"];
    [_assetOperator deleteFile:videoPath];
}

- (IBAction)addFiles:(UIButton *)sender {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.view.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
    
    //保存图片
    NSString *imagePath =[[NSBundle mainBundle] pathForResource:@"tip_scanner" ofType:@"JPG"];
    [_assetOperator saveImagePath:imagePath orImage:nil completionHandler:^(BOOL success, NSError * _Nullable error) {
        
    }];
    
    //保存视频
    WeakSelf(self)
    NSString *videoPath =[[NSBundle mainBundle] pathForResource:@"0425_103546" ofType:@"mp4"];
    [_assetOperator saveVideoPath:videoPath completionHandler:^(BOOL success, NSError * _Nullable error) {
        [weakself handleSaveImageCallback:success error:error];
    }];
}

- (void)handleSaveImageCallback:(BOOL)success error:(NSError *)error {
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = @"保存失败";
    }   else {
        label.text = @"保存成功";
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}


@end
