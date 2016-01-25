//
//  PicDetailViewController.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/13.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
static  NSInteger currentIndex;
static  NSInteger picImgTag = 1000;
static CGRect scaleOriginRect;

#import "PicDetailViewController.h"
#import "UIColor+NSString.h"
#import "UIImageView+WebCache.h"

@interface PicDetailViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation PicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self makeView];
    [self addGestureRecognizerForImages];

}
-(void)makeView
{
    self.scrView = [UIScrollView new];
    self.scrView.userInteractionEnabled = YES;
    self.scrView.showsHorizontalScrollIndicator = NO;
    self.scrView.pagingEnabled = YES;
    self.scrView.delegate = self;
    self.scrView.maximumZoomScale = 2.0;
    self.scrView.minimumZoomScale = 0.5;
    [self.view addSubview:self.scrView];
    
    self.scrView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    currentIndex = [self.currentIndex integerValue];
    self.scrView.contentSize = CGSizeMake(SCREEN_WIDTH * self.picArr.count, SCREEN_HEIGHT);
    [self.scrView setContentOffset:CGPointMake(SCREEN_WIDTH*currentIndex ,0.f) animated:YES];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget : self
                                         action : @selector(singleTapDown:)];
    [self.scrView addGestureRecognizer:singleTap];
    
    for (int i = 0 ; i < self.picArr.count; i++) {
        
        self.picImgView = [UIImageView new];
        self.picImgView.userInteractionEnabled = YES;
        
         self.picImgView.tag = picImgTag + i;
        [self.picImgView sd_setImageWithURL:self.picArr[i] placeholderImage:nil];
        
        //判断图片是否下载完成
        NSString *imgStr = [NSString stringWithFormat:@"%@",self.picImgView.image];
        if([imgStr isEqualToString:@"(null)"])
        {
            self.picImgView.image = [UIImage imageNamed:@"Icon"];
        }
        float scaleX = SCREEN_WIDTH/self.picImgView.image.size.width;
        float scaleY = SCREEN_HEIGHT/self.picImgView.image.size.height;
        
        //倍数小的，先到边缘
        if (scaleX > scaleY)
        {
            //Y方向先到边缘
            float imgViewWidth = self.picImgView.image.size.width*scaleY;
            scaleOriginRect = (CGRect){SCREEN_WIDTH/2-imgViewWidth/2,0,imgViewWidth,SCREEN_HEIGHT};
        }
        else
        {
            //X先到边缘
            float imgViewHeight = self.picImgView.image.size.height*scaleX;
            scaleOriginRect = (CGRect){0,SCREEN_HEIGHT/2-imgViewHeight/2,SCREEN_WIDTH,imgViewHeight};
        }

        self.picImgView.size = scaleOriginRect.size;
        self.picImgView.viewLeft = i*(SCREEN_WIDTH + scaleOriginRect.origin.x);
        self.picImgView.viewCenterY = SCREEN_HEIGHT/2;
        self.picImgView.viewTop = scaleOriginRect.origin.y;

        [self.scrView addSubview:self.picImgView];
        
    }
}
-(void)singleTapDown:(UITapGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}
#pragma  mark - 添加手势
-(void)addGestureRecognizerForImages{
    //遍历所有图片，
    for (UIView * subView in self.scrView.subviews) {
        //如果不是图片，跳过
        if([subView  isKindOfClass:[UIImageView class]] == NO){
            continue;
        }
        //捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(dealPinch:)];
        subView.userInteractionEnabled = YES;
        [subView addGestureRecognizer:pinch];
    }
}

-(void)dealPinch:(UIPinchGestureRecognizer *)recognizer{
    //    NSLog(@"捏合, %f", recognizer.scale);
    static CGFloat scale=1;
    //scale上次捏合的结果
    //随着捏合，
    recognizer.view.transform=CGAffineTransformMakeScale(scale * recognizer.scale, scale * recognizer.scale);
    if(recognizer.state==UIGestureRecognizerStateEnded){
        //如果是捏合的结束，累加当前的缩放
        scale *= recognizer.scale;
    }
}
@end
