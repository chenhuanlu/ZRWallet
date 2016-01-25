//
//  MoreDetailViewController.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/12.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
static CGFloat imgWidth;
static NSInteger scrBtnTag = 7000;
static NSInteger tagNumber = 1000;

#import "MoreDetailViewController.h"
#import "UIColor+NSString.h"
#import "AppNavView.h"
#import "MoreDetailCell.h"
#import "InvestmentRecordCell.h"
#import "MyPreferentialModel.h"
#import "UIImageView+WebCache.h"
#import "PicDetailViewController.h"
#import "MJRefresh.h"
//#import "MJPhotoBrowser.h"
#import "SDPhotoBrowser.h"


@interface MoreDetailViewController ()<SDPhotoBrowserDelegate>
{
    PicDetailViewController *picVC;
    int currentPage;
    BOOL isFresh; //是否为下拉刷新

}
@property (nonatomic, strong) NSMutableArray *dataArray;
//@property (nonatomic, strong) NSString *descriptionType;
//@property (nonatomic, strong) NSString *recordType;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) AppNavView *navView;
@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, strong) UIView *topBtnLayerView;
@property (nonatomic, strong) UIView *middleLine;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scrView;
@property (nonatomic, strong) UIImageView *scrImgView;
@property (nonatomic, strong) UIButton *scrImgBtn;

@property (nonatomic, strong) NSArray *descripFirstTitleArr;
@property (nonatomic, strong) NSMutableArray *descripaDataArr;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) NSArray *photoBrowserPicArr;


@end

@implementation MoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.type = 1;

    [self makeNavView];
    [self makeView];
    
    //------------------------上拉下拉加载更多-------------------------------------------
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefeshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.tableView setFooterHidden:YES];
    [self.tableView setHeaderHidden:YES];

    [self projectDescripData];

}
-(void)projectDescripData
{
   self.descripFirstTitleArr = [self.projectDesp allKeys];
    self.descripaDataArr = [NSMutableArray new];
    for (int i = 0 ; i < self.descripFirstTitleArr.count ; i++) {
        NSDictionary *dic = self.projectDesp[self.descripFirstTitleArr[i]];
        [self.descripaDataArr addObject:dic];
    }
    [self.tableView reloadData];
}
//投资接口
- (void)investmentDataRequest:(int)page
{
    NSDictionary *dic = @{ @"projectId" : self.projectId,
                           @"currPage"  : @(page),
                           @"perPage"   : @"10"
                          };
    [[HttpRequest sharedRequest]sendRequestWithMessage:@"" path:@"p2c/historyInvestment" param:dic succuss:^(id result) {
        
        if (self.dataArray == nil) {
            self.dataArray = [NSMutableArray arrayWithCapacity:10];
        }
        if (page == 1) {
            
            [self.dataArray removeAllObjects];
        }
        if (isFresh)
        {
            currentPage = 1;
            isFresh = NO;
            [self.dataArray removeAllObjects];
            [self.tableView headerEndRefreshing];
        }
        else
        {
            currentPage++;
            [self.tableView footerEndRefreshing];
        }
        
        int totalPage = [result[@"totalPage"] intValue];
        if (currentPage < totalPage)
        {
            [self.tableView setFooterHidden:NO];
        }
        else
        {
            [self.tableView setFooterHidden:YES];
        }

        NSArray *dataArr = result[@"list"];
        if (![(NSNull*)dataArr isEqual:[NSNull null]]) {
            for (NSDictionary *dic in dataArr) {
                MyPreferentialModel *preferentialModel = [[MyPreferentialModel alloc] init];
                [preferentialModel setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:preferentialModel];
                
            }
        }
        
        [self.tableView reloadData];
        
    } fail:^{
        
    }];
    
}
-(void)makeNavView
{
    self.navView = [AppNavView new];
    self.navView.delegate = self;
    [self.view addSubview:self.navView];
    self.navView.leftImgView.image = [UIImage imageNamed:@"whiteBack"];
    
    self.topBtnLayerView = [UIView new];
    self.topBtnLayerView.backgroundColor = [UIColor clearColor];
    self.topBtnLayerView.layer.borderWidth = 1.2;
    self.topBtnLayerView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.topBtnLayerView.layer.cornerRadius = 4.0;
    self.topBtnLayerView.layer.masksToBounds = YES;
    [self.navView addSubview:self.topBtnLayerView];
    
    NSArray *titleArray = @[@"描述",@"投资记录"];
    
    for (int i = 0 ; i < 2; i++) {
        self.topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.topBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        self.topBtn.layer.cornerRadius = 4.0;
        self.topBtn.layer.masksToBounds = YES;

        [self.topBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        [self.topBtn setTitleColor: RGBCOLOR(206, 0, 33) forState:UIControlStateSelected];
        [self.topBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        if(i == 0)
        {
            self.topBtn.selected = YES;
            self.topBtn.backgroundColor = [UIColor whiteColor];
        }
        [self.topBtn addTarget : self
                        action : @selector(navSelectBtnDown:)
              forControlEvents : UIControlEventTouchUpInside];
        self.topBtn.tag = tagNumber + i;
        [self.topBtnLayerView addSubview:self.topBtn];
    }
    
    self.middleLine = [UIView new];
    self.middleLine.backgroundColor = [UIColor whiteColor];
    [self.topBtnLayerView addSubview:self.middleLine];
    
}
-(void)navSelectBtnDown:(UIButton *)btn
{
    NSInteger index = btn.tag - tagNumber + 1;
    for (int i = 0 ; i < 3; i++) {
        UIButton *tempBtn = (UIButton *)[self.view viewWithTag:tagNumber + i];
        if(tempBtn == btn)
        {
            tempBtn.selected = YES;
            tempBtn.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            tempBtn.selected = NO;
            tempBtn.backgroundColor = [UIColor clearColor];
        }
    }
    
    self.type = index;
    if (self.type == 1) {
        
        [self projectDescripData];
        
        [self.tableView setFooterHidden:YES];
        [self.tableView setHeaderHidden:YES];
        
    }else
    {
        [self investmentDataRequest:1];
        
//        [self.tableView setFooterHidden:NO];
        [self.tableView setHeaderHidden:NO];

    }
    [self.tableView reloadData];

}
-(void)makeView
{
    self.tableView = [UITableView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = NO;
    self.tableView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
    [self.view addSubview:self.tableView];
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.navView.size = CGSizeMake(SCREEN_WIDTH, Dev_NavigationBar_Height);
    
    self.topBtnLayerView.size = CGSizeMake(140, 28);
    self.topBtnLayerView.viewCenterX = SCREEN_WIDTH/2;
    self.topBtnLayerView.viewCenterY = Dev_NavigationBar_Height/2 + 10;
    
    for ( int i = 0; i < 2; i++) {
        self.topBtn = (UIButton *)[self.view viewWithTag:tagNumber + i];
        self.topBtn.size = CGSizeMake(self.topBtnLayerView.size.width/2,
                                      self.topBtnLayerView.size.height);
        self.topBtn.viewLeft = i*self.topBtn.size.width;
    }

    self.middleLine.size = CGSizeMake(4, self.topBtnLayerView.size.height);
    self.middleLine.viewLeft = (self.topBtnLayerView.size.width - 2)/2;
    
    self.tableView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - Dev_NavigationBar_Height);
    self.tableView.viewTop = Dev_NavigationBar_Height;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.type == 1) {
        return  self.descripFirstTitleArr.count;
        
    }else{
        return 1;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
    
    if (self.type == 1) {
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.frame = CGRectMake(15, 6, SCREEN_WIDTH/2, 15);
        titleLabel.font = [UIFont systemFontOfSize:16];
        [headerView addSubview:titleLabel];
        
        titleLabel.text = self.descripFirstTitleArr[section];
        
    }else{
        
        NSArray *titleArray = @[@"用户",@"投资金额",@"投资时间"];
        for ( int i = 0 ; i < 3; i++) {
            UILabel *titleLabel = [UILabel new];
            titleLabel.frame = CGRectMake( i*SCREEN_WIDTH/3, 12, SCREEN_WIDTH/3, 15);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.text = titleArray[i];
            [headerView addSubview:titleLabel];
            [headerView addLine];
        }
    }
    
    return headerView;
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.type == 1) {
        return 28.0;
    }else
    {
        return 40;
    }
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == 1) {
        
        NSDictionary *dic =  self.descripaDataArr[section];
        NSArray *arr = [dic allKeys];
        return arr.count;
        
    }else{
        
        return self.dataArray.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 1) {
        
//        NSString *picTitleStr = self.descripFirstTitleArr[indexPath.section];
//        NSInteger length = [picTitleStr length];
//        NSString *compareStr = [picTitleStr substringFromIndex:length-2];
        NSDictionary *dic =  self.descripaDataArr[indexPath.section];
        NSArray *valueArr = [dic allValues];
        NSString *ste = valueArr[indexPath.row];
        NSString *stes = [ste substringToIndex:4];
        
        if ([stes isEqualToString:@"http"]) {
            imgWidth = (SCREEN_WIDTH - 50)/4;
            return imgWidth*2;
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0)
        {
            return  [self heightWithLabel:valueArr[indexPath.row]
                             fontWithFont:[UIFont systemFontOfSize: 13]].height+50;
        }
        else
        {
           return self.detailLabel.size.height + 50;
        }
    }
    else{
        return kCellHeight;
    }

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 1) {
        MoreDetailCell *cell = [[MoreDetailCell alloc]init];
        NSDictionary *dic =  self.descripaDataArr[indexPath.section];
        NSArray *titleArr = [dic allKeys];
        NSArray *valueArr = [dic allValues];
        
//        NSString *picTitleStr = self.descripFirstTitleArr[indexPath.section];
//        NSInteger length = [picTitleStr length];
//        NSString *compareStr = [picTitleStr substringFromIndex:length-2];
        NSString *ste = valueArr[indexPath.row];
        NSString *stes = [ste substringToIndex:4];

        if ([stes isEqualToString:@"http"]) {
            //图片
            self.scrView = [UIScrollView new];
            self.scrView.userInteractionEnabled = YES;
            self.scrView.showsHorizontalScrollIndicator = NO;
            self.scrView.delegate = self;
            
            [cell.contentView addSubview:self.scrView];
            
            self.scrView.size = CGSizeMake(SCREEN_WIDTH, 150);
            self.scrView.viewTop = 20;

            NSString *tempStr = valueArr[indexPath.row];

            NSArray *imagesArr = [tempStr componentsSeparatedByString:@","];

            imgWidth = (SCREEN_WIDTH - 50)/4;
            self.scrView.contentSize = CGSizeMake(10 + imagesArr.count *(imgWidth + 10) , 150);

            for (int i = 0 ; i < imagesArr.count ; i++) {
                self.scrImgView = [UIImageView new];
                
                self.scrImgView.size = CGSizeMake(imgWidth, imgWidth/1.2);
                self.scrImgView.viewTop = 10;
                self.scrImgView.viewLeft = 10 + i*(imgWidth + 10);
                
                self.scrImgView.userInteractionEnabled = YES;
                self.scrImgView.clipsToBounds = YES;
                self.scrImgView.contentMode = UIViewContentModeScaleAspectFill;
                
                //先用占位图占位

//                [self.picDatas addObject:[UIImage imageNamed:@"ip_shgywm_log"]];
//                [self.scrImgView sd_setImageWithURL:imagesArr[i]  placeholderImage:[UIImage imageNamed:@"ip_shgywm_log"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    [self.picDatas replaceObjectAtIndex:i withObject:image];
//                    [picVC updatePicWithIndex:i picData:image];
//
//                }];
                [self.scrImgView sd_setImageWithURL:imagesArr[i] placeholderImage:[UIImage imageNamed:@"Icon"]];
                
                [self.scrView addSubview:self.scrImgView];
                
                self.scrImgBtn = [UIButton new];
                self.scrImgBtn.accessibilityValue = tempStr;
                self.scrImgBtn.tag = scrBtnTag + i;
                self.scrImgBtn.size = self.scrImgView.size;
                [self.scrImgBtn addTarget : self
                                   action : @selector(scrollViewImgBtnDown:)
                         forControlEvents : UIControlEventTouchUpInside
                 ];
                [self.scrImgView addSubview : self.scrImgBtn];
                
            }

        }else
        {
            self.detailLabel = [UILabel new];
            self.detailLabel.font = [UIFont systemFontOfSize:13];
            self.detailLabel.numberOfLines = 0;
            self.detailLabel.textColor = [UIColor grayColor];
            self.detailLabel.text = valueArr[indexPath.row];
            
            self.detailLabel.size = [self heightWithLabel:self.detailLabel.text
                                             fontWithFont:[UIFont systemFontOfSize: 13]];
            self.detailLabel.viewTop = 30;
            self.detailLabel.viewLeft = 15;
            [cell.contentView addSubview:self.detailLabel];
        
        }

        cell.titleLabel.text = titleArr[indexPath.row];
        return cell;
        
    }else{
        
        static NSString *iden2 = @"iden2";
        InvestmentRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
        if (cell == nil) {
            cell = [[InvestmentRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden2];
        }
        for (id temp in cell.contentView.subviews) {
            [temp removeFromSuperview];
        }
        if (self.dataArray.count > 0) {
            
            MyPreferentialModel *model = self.dataArray[indexPath.row];
            
            cell.usePhone.text = model.userPhone;
            cell.volume.text = [NSString stringWithFormat:@"%d元",[model.volume intValue]];
            cell.insertTime.text = model.investmentTime;
            
        }
         return cell;
    }
}
-(void)scrollViewImgBtnDown:(UIButton *)btn
{
    //    picVC.picArr = self.picDatas;
//    picVC = [PicDetailViewController new];
//    picVC.picArr = [btn.accessibilityValue componentsSeparatedByString:@","];
//    picVC.currentIndex =  [NSString stringWithFormat:@"%ld",btn.tag - scrBtnTag];
//    [self presentViewController:picVC animated:YES completion:^{
//    }];
    
//    MJPhotoBrowser *photoVC = [MJPhotoBrowser new];
//    photoVC.picArr = [btn.accessibilityValue componentsSeparatedByString:@","];
//    photoVC.currentPhotoIndex = btn.tag - scrBtnTag;
//    [self presentViewController:photoVC animated:YES completion:^{
//    }];
    self.photoBrowserPicArr = [btn.accessibilityValue componentsSeparatedByString:@","];
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    //    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = self.photoBrowserPicArr.count; // 图片总数
    browser.currentImageIndex = (int)(btn.tag - scrBtnTag);
    
    browser.delegate = self;
    [browser show];


}
#pragma mark - photobrowser代理方法

//返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
      return nil;
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = self.photoBrowserPicArr[index];
    return [NSURL URLWithString:urlStr];
}

#pragma getCellHight
-(CGSize)heightWithLabel:(NSString *)text fontWithFont:(UIFont *) font
{
    
    NSDictionary *fontDic = @{ NSFontAttributeName : font };
    
    CGSize labelSize = [text
                              boundingRectWithSize : CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                              options : NSStringDrawingUsesLineFragmentOrigin
                              attributes : fontDic
                              context : nil
                              ].size;
    
    return labelSize;
    
}

#pragma mark - navBtnClick
-(void)navLeftBtnDown
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - refresh
- (void)headerRefeshing
{
    isFresh = YES;
    [self investmentDataRequest:1];
}
- (void)footerRereshing
{
    [self investmentDataRequest:currentPage + 1];
}

@end
