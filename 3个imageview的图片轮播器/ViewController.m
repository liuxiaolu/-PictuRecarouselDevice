//
//  ViewController.m
//  3个imageview的图片轮播器
//
//  Created by mac on 2016/11/4.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "LXLCirculationImage.h"



#define LXLScreenW [UIScreen mainScreen].bounds.size.width
#define LXLScrollH 200

@interface ViewController ()
@property (nonatomic, strong)LXLCirculationImage *image;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *pathArray = @[
                           @"0c",
                           @"1c",
                           @"2c",
                           @"3c",
                           @"4c"
                           ];
    LXLCirculationImage *imageView2 = [[LXLCirculationImage alloc]initWithFrame:CGRectMake(0, 220, self.view.bounds.size.width, 200) andImageNamesArray:pathArray];
    imageView2.currentPageColor = [UIColor greenColor];
    
    [self.view addSubview:imageView2];
  //  self.image = imageView2;
    
}


@end
