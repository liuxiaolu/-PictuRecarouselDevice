//
//  LXLCirculationImage.h
//  3个imageview的图片轮播器
//
//  Created by mac on 2016/11/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXLCirculationImage : UIView
//设置titleView的位置
typedef NS_ENUM(NSInteger, LXLTitleViewStatus){
    
    LXLTitleViewBottomOnlyPageControl = 0,
    LXLTitleViewBottomOnlyTitle,
    LXLTitleViewBottomPageControlAndTitle,
    LXLTitleViewBottomPageTitleAndControl,
    LXLTitleViewTopOnlyTitle,
    LXLTitleViewTopOnlyPageControl,
    LXLTitleViewTopPageControlAndTitle,
    LXLTitleViewTopPageTitleAndControl,
};

/**
 * 图片的填充模式
 */
@property (nonatomic, assign) UIViewContentMode imageContentMode;
/**
 *  是否隐藏页面控件，默认为 NO
 */
@property (nonatomic, assign) BOOL hiddenTitleView;

/**
 *  页面控件位置，默认是底部显示pagecontrol
 */
@property (nonatomic, assign) LXLTitleViewStatus titleViewStatus;

/**
 *  页面控件未选时颜色，默认为灰色
 */
@property (nonatomic, strong) UIColor *defaultPageColor;
/**
 *  页面控件选中时颜色，默认为红色
 */
@property (nonatomic, strong) UIColor *currentPageColor;
///**
// *  停顿时间, 默认 3s
// */
//@property (nonatomic, assign) float pauseTime;

/**
 *  标题的对齐方式
 */
@property (nonatomic, assign) NSTextAlignment titleAlignment;

/**
 *  标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 *  初始化(本地图片)
 *
 *  @param frame
 *  @param array      图片名数组
 *  @param placeImage 加载失败时的占位图片
 *  @param titles     数组标题
 *
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage andTitles:(NSArray *)titles pluseTime:(float)pluseTime;
-(instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage andTitles:(NSArray *)titles;
-(instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array;
-(instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array andTitles:(NSArray *)titles;
-(instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage;
/**
 *  初始化
 *
 *  @param frame
 *  @param array      图片的地址
 *  @param placeImage 加载失败时的占位图片
 *  @param titles     标题数组
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage andTitles:(NSArray *)titles pluseTime:(float)pluseTime;
- (instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage andTitles:(NSArray *)titles;
- (instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array;
- (instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage;
- (instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array andTitles:(NSArray *)titles;


@end
