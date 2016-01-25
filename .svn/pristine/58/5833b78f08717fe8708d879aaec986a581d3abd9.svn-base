//
//  CarouselsPageControl.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/2.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
static CGFloat PageControlImgSize = 8;

#import "CarouselsPageControl.h"
@interface CarouselsPageControl()

@property (nonatomic, strong) NSMutableDictionary *imagesDic;
@property (nonatomic, strong) NSMutableArray *pageViewsArray;

@end
@implementation CarouselsPageControl
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit
{
    self.page = 0;
    self.imagesDic = [NSMutableDictionary dictionary];
    self.pageViewsArray = [NSMutableArray array];
}
- (void)setPage:(NSInteger)page
{
    _page = page;
    [self setNeedsLayout];
    
}
- (void)layoutSubviews
{
    [self.pageViewsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        [view removeFromSuperview];
    }];
    [self.pageViewsArray removeAllObjects];
    
    for (int i = 0; i < self.pageCount; i++) {
        
        UIImageView *imageView = [self imageViewForKey:@"pageKey"];
        imageView.frame = CGRectMake( i * (PageControlImgSize + 4), 0, PageControlImgSize, PageControlImgSize);
        if (i == self.page) {
            imageView.highlighted = YES;
        }
        [self addSubview:imageView];
        [self.pageViewsArray addObject:imageView];
        
    }
}
- (UIImageView *)imageViewForKey:(NSString *)key
{
    NSDictionary *imageDataDic = self.imagesDic[key];
    UIImageView *imageView = [[UIImageView alloc] initWithImage : imageDataDic[@"normal"]
                                               highlightedImage : imageDataDic[@"highlighted"]];
    return imageView;
}
#pragma mark External method
- (void)setImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage forKey:(NSString *)key
{
    NSDictionary *imageDataDic = @{ @"normal" : image,
                                    @"highlighted" : highlightedImage };
    
    [self.imagesDic setObject:imageDataDic forKey:key];
    [self setNeedsLayout];
}





@end
