//
//  PayOfPreferentialViewController.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/25.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
static CGFloat topBtnHeight;
static NSInteger tagNumber = 1000;
#import "PayOfPreferentialViewController.h"
#import "PaymentViewController.h"
#import "MyPreferentalCell.h"
#import "MyPreferentialModel.h"
#import "UIColor+NSString.h"
#import "SDKQRView.h"
#import "AppNavView.h"

@interface PayOfPreferentialViewController ()
@property (nonatomic, strong) AppNavView *navView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *arr1;    //优惠券数组
@property (nonatomic, strong) NSMutableArray *arr2;    //通用数组

@property (nonatomic, strong) UIView *QRLayerView;
@property (nonatomic, strong) UIImageView *QRImgView;

@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, strong) UIView *topBtnView;
@property (nonatomic, strong) UIView *topBtnLayerView;

@property (nonatomic, assign) NSInteger type;


@end

@implementation PayOfPreferentialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.type = 1;
    [self makeNavView];
    [self makeView];
    
    [self makeQRLayerView];

    [self getPreferentialData];
    
   
}
-(void)getPreferentialData
{
    if (self.arr2 == nil) {
        self.arr2 = [[NSMutableArray alloc] init];
    }
    if (self.arr1 == nil) {
        self.arr1 = [[NSMutableArray alloc] init];
    }

    [self.arr1 removeAllObjects];
    [self.arr2 removeAllObjects];
    
    if (![(NSNull *)self.preferentialDataArray isEqual:[NSNull null]]) {
        for (NSDictionary *dic in self.preferentialDataArray) {
            MyPreferentialModel *model = [MyPreferentialModel new];
            [model setValuesForKeysWithDictionary:dic];
            [self typeWithModel:model];
        }

    }
 
    [self.tableView reloadData];
}
-(void)typeWithModel:(MyPreferentialModel *)model
{
    if([model.type isEqualToString:@"1"])
    {
        [self.arr1 addObject:model];
    
    }if ([model.type isEqualToString:@"2"]) {
        [self.arr2 addObject:model];

    }
}
-(void)makeNavView
{
    self.navView = [AppNavView new];
    self.navView.delegate = self;
    [self.view addSubview:self.navView];
    
    self.navView.titleLabel.text = @"我的优惠券";
    self.navView.leftImgView.image = [UIImage imageNamed:@"whiteBack"];
//    [self.navView.navLeftBtn addTarget:self
//                                action:@selector(navLeftBtnDown)
//                      forControlEvents:UIControlEventTouchUpInside
//     ];
    [self.navView.navRightBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [self.navView.navRightBtn addTarget:self action:@selector(navRightBtnDown) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)makeQRLayerView
{
    self.QRLayerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.QRLayerView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
    self.QRLayerView.userInteractionEnabled = YES;
    self.QRLayerView.alpha = 0;
    [self.view addSubview:self.QRLayerView];
    
    UITapGestureRecognizer *QRLayerViewTap = [[UITapGestureRecognizer alloc] initWithTarget : self
                                                                                     action : @selector(QRTap:)];
    [self.QRLayerView addGestureRecognizer:QRLayerViewTap];
    
    
    self.QRImgView = [UIImageView new];
    self.QRImgView.size = CGSizeMake( SCREEN_WIDTH - 40, SCREEN_WIDTH - 40);
    self.QRImgView.viewLeft = 20;
    self.QRImgView.viewCenterY = SCREEN_HEIGHT/2;
    [self.QRLayerView addSubview:self.QRImgView];
    
}
-(void)makeView
{
    topBtnHeight = 50;
    self.topBtnView = [UIView new];
    self.topBtnView.backgroundColor = [UIColor whiteColor];
    [self.topBtnView addLine];
    self.topBtnView.userInteractionEnabled = YES;
    [self.view addSubview:self.topBtnView];
    
    self.topBtnLayerView = [UIView new];
    self.topBtnLayerView.backgroundColor = [UIColor clearColor];
    self.topBtnLayerView.layer.borderWidth = 1.2;
    self.topBtnLayerView.layer.borderColor = RGBCOLOR(206, 0, 33).CGColor;
    self.topBtnLayerView.layer.cornerRadius = 4.0;
    self.topBtnLayerView.layer.masksToBounds = YES;
    [self.topBtnView addSubview:self.topBtnLayerView];
    
    NSArray *titleArray = @[@"商户券",@"通用券"];
    for (int i = 0 ; i < titleArray.count; i++) {
        self.topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.topBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        
        self.topBtn.layer.cornerRadius = 4.0;
        self.topBtn.layer.masksToBounds = YES;
        [self.topBtn setTitleColor: RGBCOLOR(206, 0, 33) forState:UIControlStateNormal];
        [self.topBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateSelected];
        [self.topBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        if(i == 0)
        {
            self.topBtn.selected = YES;
            self.topBtn.backgroundColor =  RGBCOLOR(206, 0, 33);
        }
        [self.topBtn addTarget : self
                        action : @selector(topBtnDown:)
              forControlEvents : UIControlEventTouchUpInside];
        self.topBtn.tag = tagNumber + i;
        [self.topBtnView addSubview:self.topBtn];
    }
    
    
    self.tableView = [UITableView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
    [self.view addSubview:self.tableView];
}
-(void)topBtnDown:(UIButton *)btn
{
    NSInteger index = btn.tag - tagNumber + 1;
    for (int i = 0 ; i < 2; i++) {
        UIButton *tempBtn = (UIButton *)[self.view viewWithTag:tagNumber + i];
        if(tempBtn == btn)
        {
            tempBtn.selected = YES;
            tempBtn.backgroundColor =  RGBCOLOR(206, 0, 33);
        }
        else
        {
            tempBtn.selected = NO;
            tempBtn.backgroundColor = [UIColor clearColor];
        }
    }
    self.type = index;
    
    [self getPreferentialData];
    
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.navView.size = CGSizeMake(SCREEN_WIDTH, Dev_NavigationBar_Height);
    self.topBtnView.size = CGSizeMake(SCREEN_WIDTH, topBtnHeight);
    self.topBtnView.viewTop = Dev_NavigationBar_Height;
    
    self.topBtnLayerView.size = CGSizeMake(SCREEN_WIDTH - 20, topBtnHeight - 20);
    self.topBtnLayerView.viewLeft = 10;
    self.topBtnLayerView.viewTop = 10;
    
    for ( int i = 0; i < 2; i++) {
        self.topBtn = (UIButton *)[self.view viewWithTag:tagNumber + i];
        
        self.topBtn.size = CGSizeMake((SCREEN_WIDTH - 20)/2, topBtnHeight - 20);
        self.topBtn.viewTop = 10;
        self.topBtn.viewLeft = 10 + i*(SCREEN_WIDTH - 20)/2;
    }
    
    self.tableView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - Dev_NavigationBar_Height - topBtnHeight) ;
    self.tableView.viewTop = self.topBtnView.viewBottom;


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH/3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == 1) {
        return self.arr1.count;
    }else{
        return self.arr2.count;
    }

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"iden";
    MyPreferentalCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[MyPreferentalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    for (id temp in cell.contentView.subviews) {
        [temp removeFromSuperview];
    }
    NSArray *newArr;
    if (self.type == 1) {
        newArr = [NSArray arrayWithArray:self.arr1];
    }else{
        newArr = [NSArray arrayWithArray:self.arr2];
    }

    if (newArr.count > 0) {
        MyPreferentialModel *preferentialModel = [newArr objectAtIndex:indexPath.row];
        NSString *shopNameStr;
        
        if ([(NSNull *)preferentialModel.merchantName isEqual:[NSNull null]]) {
            shopNameStr = @"暂无商户名称";
        }else
        {
            shopNameStr = preferentialModel.merchantName;
        }
        cell.titleLabel.text = shopNameStr;
        
        cell.infoLabel.text = [NSString stringWithFormat: @"全场通用，店内满%@使用",
                               preferentialModel.lowercash];
        
        
        
        NSRange range = [preferentialModel.expired rangeOfString:@"-"];
        NSString *beginTime = [preferentialModel.expired substringToIndex:range.location];
        NSString *endTime = [preferentialModel.expired substringFromIndex:range.location + 1];
        
        NSMutableString *begin = [NSMutableString stringWithString:beginTime];
        NSMutableString *end = [NSMutableString stringWithString:endTime];
        
        [begin insertString:@"-" atIndex:4];
        [begin insertString:@"-" atIndex:7];
        
        [end insertString:@"-" atIndex:4];
        [end insertString:@"-" atIndex:7];
        
        cell.dateLabel.text = [NSString stringWithFormat:@"使用期限%@至%@",begin,end];
        
        NSString *backImg;
        UIColor *inforBackColor;
        NSString *isUse = [NSString stringWithFormat:@"%@",preferentialModel.couponStatus];
    
//        if ([preferentialModel.couponStatus isEqualToString:@"2"])
//        {
//            backImg = @"ip_yhq_bj_expbj";
//            inforBackColor = RGBCOLOR(74, 74, 74);
//        }
//        else
//        {
//            //已使用
//            if ([isUse isEqualToString:@"1"]) {
//                backImg = @"ip_yhq_bj_hasbj.png";
//                inforBackColor = RGBCOLOR(173, 133, 9);
//                
//            }
//            //未使用
//            else{
//                backImg = @"ip_yhq_bj_dobj.png";
//                inforBackColor = RGBCOLOR(21, 137, 24);
//            }
//        }
        backImg = @"ip_yhq_bj_ddoobj";
        inforBackColor = RGBCOLOR(21, 137, 24);
        
        if (preferentialModel.code == self.selectPrefential.code)
        {
            cell.selectImg.hidden = NO;
            
            cell.backView.layer.borderWidth = 2;
            cell.backView.layer.borderColor = RGBCOLOR(206, 0, 34).CGColor;
        }
        else
        {
            cell.selectImg.hidden = YES;
            cell.backView.layer.borderWidth = 0;
        }
        
        cell.infoLabel.backgroundColor = inforBackColor;
        
        UIFont *amountFont = [UIFont systemFontOfSize:14];
        NSString *amountStr = [NSString stringWithFormat:@"￥%@",preferentialModel.amount];
        NSRange amountRange = [amountStr rangeOfString:@"￥"];
        NSMutableAttributedString *amountAttributedStr = [[NSMutableAttributedString alloc] initWithString:amountStr];
        [amountAttributedStr addAttribute : NSFontAttributeName
                                    value : amountFont
                                    range : amountRange
         ];
        cell.moneyLabel.attributedText = amountAttributedStr;
        
        
        cell.backView.image = [UIImage imageNamed:backImg];
        
        cell.phoneNumLabel.text = preferentialModel.code;
        
        CGSize size = CGSizeMake(SCREEN_WIDTH - 40, SCREEN_WIDTH - 40);
        NSString *qrStr = [NSString stringWithFormat:@"rilipay#%@",preferentialModel.code];
        UIImage *QRImage = [SDKQRView qrImageWithString:qrStr size:size];
        
        [cell.QRImgViewBtn setImage:QRImage forState:UIControlStateNormal];
        [cell.QRImgViewBtn addTarget : self
                              action : @selector(QRTap:)
                    forControlEvents : UIControlEventTouchUpInside];
        cell.QRImgViewBtn.accessibilityValue = [NSString stringWithFormat:@"%@",cell.QRImgViewBtn.imageView.image];
        
        cell.phoneBtn.accessibilityValue = preferentialModel.merchantPhoneNumber;
        [cell.phoneBtn addTarget : self
                          action : @selector(phoneBtnDown:)
                forControlEvents : UIControlEventTouchUpInside];
        
    }
    
    return cell;
    

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *newArr;
    if (self.type == 1) {
        newArr = [NSArray arrayWithArray:self.arr1];
    }else{
        newArr = [NSArray arrayWithArray:self.arr2];
    }
    MyPreferentialModel *preferentialModel = [newArr objectAtIndex:indexPath.row];
    
    
    if (self.selectPrefential.code!=preferentialModel.code)
    {
        self.selectPrefential = preferentialModel;
    }
    else
    {
        self.selectPrefential = nil;
    }
    [self.tableView reloadData];
    
//    self.frontContoller.preferntialAmount = preferentialModel.amount;
//    self.frontContoller.preferntialCode = preferentialModel.code;
//
//    [self.navigationController popViewControllerAnimated:YES];
}
-(void)phoneBtnDown:(UIButton *)btn
{
    NSString *phoneNum = btn.accessibilityValue;
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
}
-(void)QRTap:(UIButton *)btn
{
     [UIView animateWithDuration:0.25 animations:^{
         self.QRLayerView.alpha = self.QRLayerView.alpha==0?1:0;
     } completion:^(BOOL finished) {
     }];
    
    [UIView animateWithDuration:2.5 animations:^{
        
         if (self.QRLayerView.alpha == 1) {
             self.QRImgView.image = btn.imageView.image;
         }else{
            
        }
    } completion:^(BOOL finished) {
     }];
 }
#pragma mark - navBtnClick
-(void)navLeftBtnDown
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navRightBtnDown
{
    self.frontContoller.selectPreferntial = self.selectPrefential ;
    [self.frontContoller refreshStatus];
    [self.navigationController popViewControllerAnimated:YES];
   
}
@end
