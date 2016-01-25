//
//  CarouselsView.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/2.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

static CGFloat pageControlViewWidth;
static CGFloat pageControlViewHight = 20;
#import "CarouselsView.h"
@interface CarouselsView (){
    int curPage;
    NSMutableArray *curImagesArray; //存放当前滚动的三张图片
    NSTimer *timer;
    BOOL isFirst;
    
}
@property (nonatomic, strong) UIScrollView *scr;
@property (nonatomic, strong) NSMutableArray *picArr;
@property (nonatomic, strong) CarouselsPageControl *pagerView;
@end

@implementation CarouselsView
-(instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)initPage
{
    self.picArr = [NSMutableArray new];
    [self.picArr addObjectsFromArray:[self.delegate getPageOfImgArr]];
    
    if(self.picArr.count > 0 ){
        [self isInitPage];
        
    }
}
-(void)isInitPage
{
    curImagesArray = [NSMutableArray new];
    
    self.scr = [UIScrollView new];
    self.scr.userInteractionEnabled = YES;
    self.scr.delegate = self;
    [self addSubview:self.scr];
    self.scr.pagingEnabled = YES;
    
    //自定义PageControl
    
    self.pagerView = [CarouselsPageControl new];
    [self.pagerView setImage:[UIImage imageNamed:@"page_control_dot2.png"]
            highlightedImage:[UIImage imageNamed:@"page_control_dot1.png"]
                      forKey:@"pageKey"];
    self.pagerView.pageCount = self.picArr.count;
    [self addSubview:self.pagerView];
    curPage = 0;
    
    [self refreshScrollView];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:[self.delegate getTimerOfPageControl]
                                             target:self
                                           selector:@selector(scrollToNextPage)
                                           userInfo:nil
                                            repeats:YES];
    
    
}


-(void)scrollToNextPage
{
    CGPoint newOffset = CGPointMake(self.scr.contentOffset.x + CGRectGetWidth(self.scr.frame), self.scr.contentOffset.y);
    [self.scr setContentOffset:newOffset animated:YES];
    
}
-(void)refreshScrollView
{
    self.pagerView.page = curPage;
    NSArray *subViews =[self.scr subviews];
    if([subViews count]!= 0)
    {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self getDisplayImagesWithCurpage:curPage];
    
    UIImageView *preView = [[UIImageView alloc] initWithFrame:self.bounds];
    UIImageView *curView = [[UIImageView alloc] initWithFrame:self.bounds];
    UIImageView *lastView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    NSURL * preURL = curImagesArray[0];
    NSURL *curURL = curImagesArray[1];
    NSURL *lastURL = curImagesArray[2];
    
    [preView sd_setImageWithURL:preURL placeholderImage:nil];
    [curView sd_setImageWithURL:curURL placeholderImage:nil];
    [lastView sd_setImageWithURL:lastURL placeholderImage:nil];
    
    
    preView.userInteractionEnabled = YES;
    curView.userInteractionEnabled = YES;
    lastView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *preTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(handleTap:)];
    [preView addGestureRecognizer:preTap];
    
    UITapGestureRecognizer *curTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(handleTap:)];
    [curView addGestureRecognizer:curTap];
    
    UITapGestureRecognizer *lastTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(handleTap:)];
    [lastView addGestureRecognizer:lastTap];
    
    [self.scr addSubview:preView];
    [self.scr addSubview:curView];
    [self.scr addSubview:lastView];
    
    preView.frame = CGRectOffset(preView.frame, 0, 0);
    curView.frame = CGRectOffset(curView.frame, self.frame.size.width, 0);
    lastView.frame = CGRectOffset(lastView.frame, self.frame.size.width*2, 0);
    
    [self.scr setContentOffset:CGPointMake(self.frame.size.width, 0)];
    
}
- (void)handleTap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [self.delegate didClickPage:self atIndex:curPage];
    }
}
- (NSArray*)getDisplayImagesWithCurpage:(int)page
{
    int pre=[self validPageValue:curPage - 1];
    int last=[self validPageValue:curPage + 1];
    if(curImagesArray.count!= 0)
        [curImagesArray removeAllObjects];
    
    [curImagesArray addObject:[self.picArr objectAtIndex:pre]];
    [curImagesArray addObject:[self.picArr objectAtIndex:curPage]];
    [curImagesArray addObject:[self.picArr objectAtIndex:last]];
    
    return curImagesArray;
}
- (int)validPageValue:(NSInteger)value
{
    if(value == -1)
        value = self.picArr.count - 1;
    if(value == self.picArr.count)
        value = 0;
    return value;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int x = scrollView.contentOffset.x;
    
    if(x >= 2*self.frame.size.width)
    {
        curPage = [self validPageValue:curPage + 1];
        [self refreshScrollView];
    }
    if(x <= 0)
    {
        if (isFirst == NO) {
            curPage = 0;
        }else{
            curPage = [self validPageValue:curPage - 1];
        }
        isFirst = YES;
        [self refreshScrollView];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [timer invalidate];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    timer = [NSTimer scheduledTimerWithTimeInterval:[self.delegate getTimerOfPageControl]
                                             target:self
                                           selector:@selector(scrollToNextPage)
                                           userInfo:nil
                                            repeats:YES];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.scr.frame = self.bounds;
    pageControlViewWidth = self.picArr.count * 11;
    self.scr.contentSize = CGSizeMake(self.frame.size.width*3, self.bounds.size.height);
    self.pagerView.frame = CGRectMake((self.frame.size.width - pageControlViewWidth)/2, self.bounds.size.height - pageControlViewHight, pageControlViewWidth, pageControlViewHight);
    
}


@end
