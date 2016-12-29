//
//  LXLCirculationImage.m
//  3个imageview的图片轮播器
//
//  Created by mac on 2016/11/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LXLCirculationImage.h"
#import <UIImageView+WebCache.h>


#define LXLCircleW self.bounds.size.width
#define LXLCircleH self.bounds.size.height

@interface LXLCirculationImage ()<UIScrollViewDelegate>
/**添加scrollview*/
@property (nonatomic, strong)UIScrollView *scrollView;
/**添加页码指示控制器*/
@property (nonatomic, strong)UIPageControl *pageControl;
/**添加左边显示的控件*/
@property (nonatomic, strong)UIImageView *leftImageView;
/**添加右边显示的控件*/
@property (nonatomic, strong)UIImageView *rightImageView;
/**添加中间显示的控件*/
@property (nonatomic, strong)UIImageView *centerImageView;
/**保存图片的数组*/
@property (nonatomic, strong)NSArray *imageArray;
/**图片的当前索引**/
@property (nonatomic, assign)int currentIndex;
/**图片总数*/
@property (nonatomic,assign)NSUInteger imageCount;
/**创建一个定时器*/
@property (nonatomic,strong)NSTimer *timer;
/**是否是URl**/
@property (nonatomic, assign) BOOL isURL;
/**占位图片*/
@property (nonatomic, strong) UIImage *placeImage;
/**设置titles*/
@property (nonatomic, strong) NSArray *titleArray;
/**设置titlView*/
@property (nonatomic, strong) UIView   *titleView;
/**title*/
@property (nonatomic, strong) UILabel *titleLbl;

/**
 *  停顿时间, 默认 3s
 */
@property (nonatomic, assign) float pauseTime;



@end

@implementation LXLCirculationImage
#pragma mark ---懒加载
-(UIView *)titleView{
    if (_titleView == nil) {
        CGRect pageRect = CGRectZero;
        CGRect titleRect = CGRectZero;
        CGRect rect = [self setupPageControlFrame:&pageRect titleLabelFrame:&titleRect];
        _titleView = [[UIView alloc] initWithFrame:rect];
        [self addSubview:_titleView];
        
        UILabel *mask = [[UILabel alloc] initWithFrame:_titleView.bounds];
        mask.backgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:.3];
        [_titleView addSubview:mask];
        if(pageRect.size.width != 0) {
            self.pageControl = [[UIPageControl alloc] initWithFrame:pageRect];
            self.pageControl.currentPage = self.currentIndex;
            self.pageControl.userInteractionEnabled = NO;
            self.pageControl.numberOfPages = self.imageArray.count;
            self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
            self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
            [_titleView addSubview:self.pageControl];
        }
        self.titleLbl = [[UILabel alloc] initWithFrame:titleRect];
        self.titleLbl.font = [UIFont systemFontOfSize:14];
        self.titleLbl.text = self.titleArray.count ? self.titleArray[self.currentIndex] : @"";
        [_titleView addSubview:self.titleLbl];
    }
    return _titleView;
}
#pragma mark ----系统方法
-(instancetype)init{
    @throw [NSException exceptionWithName:@"初始化方法" reason:@"请使用 initWithFrame:andImageNamesArray: 初始化" userInfo:nil];
}

-(instancetype)initWithFrame:(CGRect)frame{
      @throw [NSException exceptionWithName:@"初始化方法" reason:@"请使用 initWithFrame:andImageNamesArray: 初始化" userInfo:nil];
}
-(void)dealloc{
    [self closeTimer];
}
#pragma mark ----初始化
-(instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array{
    return [self initWithFrame:frame andImageNamesArray:array andPlaceImage:nil andTitles:nil];
}
-(instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array andTitles:(NSArray *)titles{
     return [self initWithFrame:frame andImageNamesArray:array andPlaceImage:nil andTitles:titles];
}
-(instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage{
     return [self initWithFrame:frame andImageNamesArray:array andPlaceImage:placeImage andTitles:nil];
}
-(instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage andTitles:(NSArray *)titles{
    return [self initWithFrame:frame andImageNamesArray:array andPlaceImage:placeImage andTitles:titles pluseTime:0];
//    NSAssert(array.count > 2, @"图片的数量不能少于3张");
//    if (titles != nil || titles.count >0) {
//        NSAssert(array.count == titles.count, @"图片和名称数组不对应");
//    }
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.currentIndex = 0;
//        self.isURL = NO;
//        self.imageArray = array;
//        self.titleArray = titles;
//        self.placeImage = placeImage;
//        self.imageCount = array.count;
//        [self setupLayout];
//        
//    }
//    return self;
}
-(instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage andTitles:(NSArray *)titles pluseTime:(float)pluseTime{
    NSAssert(array.count > 2, @"图片的数量不能少于3张");
    if (titles != nil || titles.count >0) {
        NSAssert(array.count == titles.count, @"图片和名称数组不对应");
    }
    self = [super initWithFrame:frame];
    if (self) {
        self.currentIndex = 0;
        self.isURL = NO;
        self.imageArray = array;
        self.titleArray = titles;
        self.placeImage = placeImage;
        self.imageCount = array.count;
        self.pauseTime = pluseTime;
        [self setupLayout];
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array{
    return [self initWithFrame:frame andImageURLsArray:array andTitles:nil];
}
-(instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array andTitles:(NSArray *)titles{
    return [self initWithFrame:frame andImageURLsArray:array andPlaceImage:nil andTitles:titles];
}
-(instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage{
    return [self initWithFrame:frame andImageURLsArray:array andPlaceImage:placeImage andTitles:nil];
}
-(instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage andTitles:(NSArray *)titles{
    return [self initWithFrame:frame andImageNamesArray:array andPlaceImage:placeImage andTitles:titles pluseTime:0];
//    NSAssert(array.count > 2, @"图片的数量不能少于3张");
//    if (titles != nil || titles.count >0) {
//        NSAssert(array.count == titles.count, @"图片和名称数组不对应");
//    }
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.currentIndex = 0;
//        self.isURL = YES;
//        self.imageArray = array;
//        self.titleArray = titles;
//        self.placeImage = placeImage;
//        self.imageCount = array.count;
//        [self setupLayout];
//        
//    }
//    return self;
}
-(instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage andTitles:(NSArray *)titles pluseTime:(float)pluseTime{
    NSAssert(array.count > 2, @"图片的数量不能少于3张");
    if (titles != nil || titles.count >0) {
        NSAssert(array.count == titles.count, @"图片和名称数组不对应");
    }
    self = [super initWithFrame:frame];
    if (self) {
        self.currentIndex = 0;
        self.isURL = YES;
        self.imageArray = array;
        self.titleArray = titles;
        self.placeImage = placeImage;
        self.imageCount = array.count;
        self.pauseTime = pluseTime;
        [self setupLayout];
        
    }
    return self;
}
#pragma mark ---- 基本设置
//0.设置布局
-(void)setupLayout{
    //1.创建Scrollview
    [self createdScrollView];
    //2.创建pageControl
    [self addSubview:self.titleView];
    //3.创建imageView
    [self createImageView];
    //4.设置图片
    [self setImageByIndex:self.currentIndex];
    //5.开启一个定时器
    [self startTimer];
    
}
//1.创建scroolview
-(void)createdScrollView{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, LXLCircleW, LXLCircleH)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(LXLCircleW, 0);
    self.scrollView.contentSize = CGSizeMake(LXLCircleW * 3 , LXLCircleH);
    [self addSubview:self.scrollView];
}

//3创建imageView
-(void)createImageView{
    CGFloat mW =self.scrollView.frame.size.width;
    CGFloat mH = self.scrollView.frame.size.height;
    self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mW, mH)];
    [self.scrollView addSubview:self.leftImageView];
    
    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LXLCircleW, 0, mW, mH)];
    [self.scrollView addSubview:self.centerImageView];
    
    self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LXLCircleW * 2, 0, mW, mH)];
    [self.scrollView addSubview:self.rightImageView];
    
}

//4.设置图片的变换
-(void)setImageByIndex:(int)currentIndex{
    if (self.isURL) {
        [self.centerImageView sd_setImageWithURL:[self pathToURL:currentIndex] placeholderImage:self.placeImage];
        [self.leftImageView sd_setImageWithURL:[self pathToURL:self.currentIndex-1>=0?self.currentIndex-1:self.imageArray.count-1] placeholderImage:self.placeImage];
        [self.rightImageView sd_setImageWithURL:[self pathToURL:self.currentIndex+1<=self.imageArray.count-1?self.currentIndex+1:0] placeholderImage:self.placeImage];
    }else{
        self.centerImageView.image = [self addImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageArray[self.currentIndex]]]];;
        ;
        self.leftImageView.image = [self addImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageArray[self.currentIndex-1>=0?self.currentIndex-1:self.imageArray.count-1]]]];
        self.rightImageView.image = [self addImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageArray[self.currentIndex+1<=self.imageArray.count-1?self.currentIndex+1:0]]]];
    }
    self.pageControl.currentPage = currentIndex;
}

-(NSURL *)pathToURL:(NSInteger)index{
    return [NSURL URLWithString:self.imageArray[index]];
}
-(UIImage *)addImage:(UIImage *)image{
    if (image == nil) {
        return  self.placeImage;
    }
    return image;
}

- (void)startTimer
{
    if(self.timer == nil){
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.pauseTime target:self selector:@selector(change) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
    }
}

- (void)closeTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
-(CGRect)setupPageControlFrame:(CGRect *)pRect titleLabelFrame:(CGRect *)tRect{
    CGRect rect = CGRectMake(0, LXLCircleH - LXLCircleH * 0.1, LXLCircleW, LXLCircleH *0.1);
    CGRect prect = CGRectZero;
    CGRect trect = CGRectZero;
    switch (self.titleViewStatus) {
        case LXLTitleViewBottomOnlyPageControl:
            prect = CGRectMake(0, 0, LXLCircleW, LXLCircleH*0.1);
            break;
        case LXLTitleViewBottomOnlyTitle:
            trect = CGRectMake(0, 0, LXLCircleW, LXLCircleH * 0.1);
            break;
            
        case LXLTitleViewBottomPageControlAndTitle:
            prect = CGRectMake(0, 0, LXLCircleW * 0.3, LXLCircleH * 0.1);
            trect = CGRectMake(LXLCircleW * 0.3, 0, LXLCircleW * 0.7, LXLCircleH * 0.1);
            break;
            
        case LXLTitleViewBottomPageTitleAndControl:
            trect = CGRectMake(0, 0, LXLCircleW * 0.7, LXLCircleH * 0.1);
            prect = CGRectMake(LXLCircleW* 0.7, 0, LXLCircleW * 0.3, LXLCircleH * 0.1);
            break;
            
        case LXLTitleViewTopOnlyTitle:
            rect = CGRectMake(0, 0, LXLCircleW, LXLCircleH * 0.1);
            trect = CGRectMake(0, 0, LXLCircleW, LXLCircleH * 0.1);
            break;
            
        case LXLTitleViewTopOnlyPageControl:
            rect = CGRectMake(0, 0, LXLCircleW, LXLCircleH * 0.1);
            prect = CGRectMake(0, 0, LXLCircleW, LXLCircleH * 0.1);
            break;
            
        case LXLTitleViewTopPageControlAndTitle:
            rect = CGRectMake(0, 0, LXLCircleW, LXLCircleH * 0.1);
            prect = CGRectMake(0, 0, LXLCircleW * 0.3, LXLCircleH * 0.1);
            trect = CGRectMake(LXLCircleW * 0.3, 0, LXLCircleW * 0.7, LXLCircleH * 0.1);
            break;
            
        case LXLTitleViewTopPageTitleAndControl:
            rect = CGRectMake(0, 0, LXLCircleW, LXLCircleH * 0.1);
            trect = CGRectMake(0, 0, LXLCircleW * 0.7, LXLCircleH * 0.1);
            prect = CGRectMake(LXLCircleW * 0.7, 0, LXLCircleW * 0.3, LXLCircleH * 0.1);
            break;
            
        default:
            break;
    }
    *pRect = prect;
    *tRect = trect;
    return rect;
}
#pragma mark ---NStimer的方法
-(void)change{
    NSLog(@"----------------------------");
    
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self.scrollView setContentOffset:CGPointMake(LXLCircleW, 0) animated:YES];
    
    self.currentIndex++;
    if (self.currentIndex  > self.imageCount-1 ) {
        self.currentIndex = 0;
    }
    [self setImageByIndex:self.currentIndex];
    self.pageControl.currentPage = self.currentIndex;
    self.titleLbl.text = self.titleArray.count ? self.titleArray[self.currentIndex]:@"";
}
#pragma mark ----刷新图片
-(void)refreshImage
{
    if (self.scrollView.contentOffset.x>LXLCircleW) {
        self.currentIndex=((self.currentIndex+1)%self.imageCount);
    }
    else if(self.scrollView.contentOffset.x<LXLCircleW){
        self.currentIndex=((self.currentIndex-1+(int)self.imageCount)%self.imageCount);
    }
    [self setImageByIndex:self.currentIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startTimer];
    [self refreshImage];
    [self.scrollView setContentOffset:CGPointMake(LXLCircleW, 0) animated:NO];
    self.pageControl.currentPage = self.currentIndex;
    self.titleLbl.text = self.titleArray.count ? self.titleArray[self.currentIndex] : @"";
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self closeTimer];
}

#pragma mark ----imageViewMode
-(void)setImageContentMode:(UIViewContentMode)imageContentMode{
    _imageContentMode = imageContentMode;
    self.leftImageView.contentMode = imageContentMode;
    self.rightImageView.contentMode = imageContentMode;
    self.centerImageView.contentMode = imageContentMode;
}
-(void)setHiddenTitleView:(BOOL)hiddenTitleView{
    _hiddenTitleView = hiddenTitleView;
    self.titleView.hidden = hiddenTitleView;
}
-(void)setTitleViewStatus:(LXLTitleViewStatus)titleViewStatus{
    _titleViewStatus = titleViewStatus;
    [self.titleView removeFromSuperview];
    self.titleView = nil;
    [self addSubview:self.titleView];
}
-(void)setDefaultPageColor:(UIColor *)defaultPageColor{
    self.pageControl.pageIndicatorTintColor = defaultPageColor;
}

-(void)setCurrentPageColor:(UIColor *)currentPageColor{
    self.pageControl.currentPageIndicatorTintColor = currentPageColor;
}

//-(float)pauseTime{
//    return (_pauseTime? _pauseTime:3);
//}
-(float)pauseTime{
    return (_pauseTime? _pauseTime:3);
}
-(void)setTitleAlignment:(NSTextAlignment)titleAlignment{
    _titleAlignment = titleAlignment;
    self.titleLbl.textAlignment = titleAlignment;
}

-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    self.titleLbl.textColor = titleColor;
}
//-(void)setPauseTime:(float)pauseTime{
//    _pauseTime = pauseTime;
//}
@end
