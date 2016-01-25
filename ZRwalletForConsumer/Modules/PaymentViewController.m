//
//  PaymentViewController.m
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/7/21.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "PaymentViewController.h"
#import "UIImageView+WebCache.h"
#import "PayOfPreferentialViewController.h"
#import "SecurityTool.h"
#import "AppNavView.h"
#import "UIColor+NSString.h"
#import "PayPasswordViewController.h"

#define kTag_Button_UseAccountMoney  100 //账户余额选择
#define kTag_Button_UseCreditMoney   101 //信用额付款选择
#define kTag_Button_OK              102 //确认付款

@interface PaymentViewController ()
{
    PayPasswordViewController *payPasswordController ;
    BOOL openPayWay; //是否展开支付方式选择
    int moneyStatus; /*0:余额和信用额都足够支付订单  1：余额够支付  信用额不够支付  2：余额不够支付 信用额够支付
                      3:余额不够支付  信用额不够支付 但是加起来够支付  4：余额和信息用额加起来都不够支付*/
    UIButton *upBtn;
    UIButton *downBtn;
    
    float order;
    float account;
    float credict;
    
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIView *payView; //底部支付
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;//实付款

@property (strong, nonatomic) NSDictionary *infoDict; //订单数据
@property (strong, nonatomic) NSDictionary *selectCouponDict; //选择优惠券信息
@property (strong, nonatomic) NSString *payMoney; //实付金额
@property (strong, nonatomic) NSArray *preferentialDataArray; //优惠劵数据数组
@property (strong, nonatomic) PayOfPreferentialViewController *preferentVC;
@property (nonatomic, strong) AppNavView *navView;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.navigationItem.title = @"付款";
    
    //订单数据取到前  页面显示空白
    self.listTableView.hidden = YES;
    self.payView.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [self makeNavView];
    
    upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upBtn.tag = kTag_Button_UseAccountMoney;
    [upBtn setBackgroundImage:[UIImage imageNamed:@"radio_unchecked"] forState:UIControlStateNormal];
    [upBtn setBackgroundImage:[UIImage imageNamed:@"radio_checked"] forState:UIControlStateSelected];
    [upBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    
    downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.tag = kTag_Button_UseCreditMoney;
    [downBtn setBackgroundImage:[UIImage imageNamed:@"radio_unchecked"] forState:UIControlStateNormal];
    [downBtn setBackgroundImage:[UIImage imageNamed:@"radio_checked"] forState:UIControlStateSelected];
    [downBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self getOrderInfo];
}
-(void)makeNavView
{
    self.navView = [AppNavView new];
    self.navView.delegate = self;
    [self.view addSubview:self.navView];
    
    self.navView.titleLabel.text = @"付款";
    self.navView.leftImgView.image = [UIImage imageNamed:@"whiteBack"];
//    [self.navView.navLeftBtn addTarget:self
//                                action:@selector(navLeftBtnDown)
//                      forControlEvents:UIControlEventTouchUpInside
//     ];
    
    
    
}
#pragma mark - navBtnClick
-(void)navLeftBtnDown
{
    [APPDataCenter.scanNav dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.navView.size = CGSizeMake(SCREEN_WIDTH, Dev_NavigationBar_Height);
}
-(void)viewWillAppear:(BOOL)animated{
    
//    [self.listTableView reloadData];
//    [self getOrderInfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 功能函数

/**
 *  根据实付金额 账户余额 信用额  判断可用用户付款类型
 */
- (void)refreshStatus
{
    if (self.selectPreferntial!=nil)
    {
        float amountMoney = [self.infoDict[@"amount"]floatValue] - [self.selectPreferntial.amount floatValue];
        //优惠券金额大于订单金额
        if (amountMoney<0)
        {
            amountMoney= 0;
        }
        self.payMoney = [NSString stringWithFormat:@"%.2f",amountMoney];
    }
    else
    {
        self.payMoney = [StaticTools formatMoney:self.infoDict[@"amount"]];
    }
   
    self.payMoneyLabel.text = [NSString stringWithFormat:@"实付款 ￥%@",self.payMoney];

    
    /*0:余额和信用额都足够支付订单 0：余额够支付 信用额也够支付  1：余额够支付  信用额不够支付  2：余额不够支付 信用额够支付
                      3:余额不够支付  信用额不够支付 但是加起来够支付  4：余额和信息用额加起来都不够支付*/
    
    order = [self.payMoney floatValue];
    account = [self.infoDict[@"cashRemain"] floatValue];
    credict = [self.infoDict[@"creditRemain"] floatValue];

    //账户余额为零  账户按钮不能操作
    if (account==0)
    {
        upBtn.selected = NO;
        upBtn.userInteractionEnabled = NO;
        upBtn.hidden = YES;
    }
    else
    {
        upBtn.userInteractionEnabled = YES;
         upBtn.hidden = NO;
    }
    
    //可用信用额为0 信用额按钮不能操作
    if (credict==0)
    {
        downBtn.selected = NO;
        downBtn.userInteractionEnabled = NO;
        
        downBtn.hidden = YES;
        
    }
    else
    {
        downBtn.userInteractionEnabled = YES;
        downBtn.hidden = NO;
    }
    
    if (account>=order&&credict>=order)
    {
        moneyStatus = 0;
        
        upBtn.selected = YES;
        downBtn.selected = NO;
    }
    else if (account>=order&&credict<order) //余额够支付  信用额不够支付
    {
         upBtn.selected = YES;
        
        moneyStatus = 1;
        downBtn.selected = NO;
        downBtn.userInteractionEnabled = NO;
        
        downBtn.hidden  = YES;
    
    }
    else if(account<order&&credict>=order)
    {
        upBtn.selected = YES;
        
        moneyStatus = 2;
    }
    else if(account<order&&credict<order&&(account+credict)>=order)
    {
        moneyStatus = 3;
        upBtn.selected = YES;
        upBtn.userInteractionEnabled = NO;
        
        downBtn.selected = NO;
        downBtn.userInteractionEnabled = NO;
        
        downBtn.hidden = YES;
    }
    else if(account<order&&credict<order&&(account+credict)<order)
    {
        moneyStatus = 4;
        
        upBtn.selected = NO;
        upBtn.userInteractionEnabled = NO;
        
        downBtn.selected = NO;
        downBtn.userInteractionEnabled = NO;
        
        upBtn.hidden = YES;
        downBtn.hidden = YES;
    }
    
 
    
    [self.listTableView reloadData];
}

#pragma mark 按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
//    UIButton *upBtn = (UIButton*)[[self.listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]] viewWithTag:kTag_Button_UseAccountMoney];
//    UIButton *downBtn = (UIButton*)[[self.listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]] viewWithTag:kTag_Button_UseCreditMoney];
    
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case kTag_Button_UseAccountMoney: //余额支付选择
        {
            if (upBtn.selected)
            {
                return;
            }
            downBtn.selected = NO;
            upBtn.selected = !upBtn.selected;
//            openPayWay = NO;
            [self.listTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case kTag_Button_UseCreditMoney: //信用额支付选择
        {
            if (downBtn.selected)
            {
                return;
            }
            upBtn.selected = NO;
            downBtn.selected = !downBtn.selected;
//            openPayWay = NO;
            [self.listTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case kTag_Button_OK: //确认付款
        {
            
            if (moneyStatus==4)
            {
                [SVProgressHUD showErrorWithStatus:@"余额不足，请充值后操作。"];
                return;
            }
            payPasswordController = [[PayPasswordViewController alloc]init];
            payPasswordController.payMoneyStr = self.payMoney;
            payPasswordController.view.frame = self.view.bounds;
            payPasswordController.okClickBlock = ^(id result){
                
                 [self payOrderWithPassword:result];
                
            };
            [self.view addSubview:payPasswordController.view];
            
            
            //??? TODO IOS7 使用下面方法时  dismiss后页面黑屏 只能采用上面方法 在本页面初始化一个支付密码页面 原因未知
//            [StaticTools showPayPasswordWithMoney:self.payMoney ClickOk:^(id password) {
//                
//                [self payOrderWithPassword:password];
//            }];
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0||section==1)
    {
        return 1;
    }
    else if(section==2)
    {
        if (openPayWay)
        {
            return 3;
        }
        else
        {
            return 1;
        }
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 120;
    }
    else if(indexPath.section==1)
    {
        return kCellHeight;
    }
    else if(indexPath.section==2)
    {
        if (indexPath.row==0)
        {
            return kCellHeight;
        }
        else
        {
            return 70;
        }
    }
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //传0的话 间距系统自动变成20了  所以传了个0.1
    if(section==0)
    {
        return 0.1;
    }
    return 10;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==2&&moneyStatus==4)
    {

        UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 30)];
        statusLabel.text = @"     账户可用余额和可用信用额不足以支付订单";
        statusLabel.textColor = [UIColor redColor];
        statusLabel.font = [UIFont systemFontOfSize:10];
        return statusLabel;
        
    }
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (indexPath.section==0)
    {
        //头像大背景图
        UIImageView *topImgView = [[UIImageView alloc]init];
        topImgView.backgroundColor = [UIColor lightGrayColor];
        topImgView.image = [UIImage imageNamed:@"ip_yhfk_bjh"];
        [cell.contentView addSubview:topImgView];
        [topImgView makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        
        //头像图片
        UIImageView *headImgView = [[UIImageView alloc]init];
        [headImgView sd_setRoundImageWithURL:[NSURL URLWithString:self.infoDict[@"avatarPath"]] placeholderImage:[UIImage imageNamed:@"ip_shhyxx_def"]];
        [cell.contentView addSubview:headImgView];
        [headImgView makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@((SCREEN_WIDTH-80)/2));
            make.top.equalTo(@5);
            make.width.equalTo(@80);
            make.height.equalTo(@80);
        }];
        
        //商户名称
        UILabel *merchantNameLabel = [[UILabel alloc]init];
        merchantNameLabel.textColor = [UIColor whiteColor];
        merchantNameLabel.textAlignment = NSTextAlignmentCenter;
        merchantNameLabel.font = [UIFont boldSystemFontOfSize:18];
        merchantNameLabel.text = self.infoDict[@"merchantName"];
        [cell.contentView addSubview:merchantNameLabel];
        [merchantNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.height.equalTo(@30);
            make.bottom.equalTo(@-5);
        }];
    }
    else
    {
        //左侧标题
        UILabel *leftTileLabel = [[UILabel alloc]init];
        leftTileLabel.font = [UIFont boldSystemFontOfSize:16];
        leftTileLabel.textColor  = RGBCOLOR(125, 125, 125);
        [cell.contentView addSubview:leftTileLabel];
        [leftTileLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.centerY.equalTo(cell.contentView.centerY);
            make.width.equalTo(@140);
            make.height.equalTo(@30);
        }];
        
        //右侧详情文字
        UILabel *rightLabel = [[UILabel alloc]init];
        rightLabel.font = [UIFont boldSystemFontOfSize:15];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.textColor = RGBCOLOR(58, 58, 58);
        [cell.contentView addSubview:rightLabel];
        [rightLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-30);
            make.centerY.equalTo(cell.contentView.centerY);
            make.left.equalTo(@120);
            make.height.equalTo(@30);
        }];
        
        if (indexPath.section==1) //优惠券
        {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
            leftTileLabel.text = @"优惠券";
            
            NSArray *coupons = self.infoDict[@"coupons"];
            //可用优惠券提醒
            UIButton *couponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            couponBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [couponBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            couponBtn.backgroundColor = RGBCOLOR(206, 0, 33);
            if (coupons.count==0)
            {
              [couponBtn setTitle:@"无可用" forState:UIControlStateNormal];
            }
            else
            {
                [couponBtn setTitle:[NSString stringWithFormat:@"%lu张可用",coupons.count] forState:UIControlStateNormal];
            }
            
            couponBtn.layer.cornerRadius = 5;
            [cell.contentView addSubview:couponBtn];
            [couponBtn makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(@60);
                make.top.equalTo(@2);
                make.width.equalTo(@65);
                make.height.equalTo(@25);
            }];
 
            if (self.selectPreferntial != nil)
            {
                rightLabel.text = [NSString stringWithFormat:@"已抵用%.2f元",[self.selectPreferntial.amount floatValue]];
            }
        }
        else if(indexPath.section==2) //付款方式
        {
            
            if (indexPath.row==0)
            {
                
                 cell.selectionStyle = UITableViewCellSelectionStyleGray;
                leftTileLabel.text = @"支付方式";
            
                rightLabel.numberOfLines=0;
                rightLabel.adjustsFontSizeToFitWidth = YES;
                if (moneyStatus==0)
                {
                    if (upBtn.selected)
                    {
                          rightLabel.text = @"账户可用余额付款";
                    }
                    else if(downBtn.selected)
                    {
                        rightLabel.text = @"信用额付款";
                    }
                }
                else if(moneyStatus==1)
                {
                    rightLabel.text = @"账户可用余额付款";
                }
                else if(moneyStatus==2)
                {
                    if (upBtn.selected)
                    {
                        rightLabel.text =  [NSString stringWithFormat:@"账户余额支付%.2f \n信用额支付%.2f",account,order-account];
                    }
                    else if(downBtn.selected)
                    {
                        rightLabel.text = @"信用额付款";
                    }
                }
                else if(moneyStatus==3)
                {
                    rightLabel.text = [NSString stringWithFormat:@"账户余额支付%.2f \n信用额支付%.2f",account,order-account];
                }
            
                //右侧箭头图片
                UIImageView *stateImgView = [[UIImageView alloc]init];
                stateImgView.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:stateImgView];
                if (openPayWay)
                {
                    stateImgView.image = [UIImage imageNamed:@"ip_yhfk_modow"];
                    [stateImgView makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(@-15);
                        make.top.equalTo(@15);
                        make.width.equalTo(@15);
                        make.height.equalTo(@10);
                    }];
                }
                else
                {
                    stateImgView.image = [UIImage imageNamed:@"ip_aqsz_mo"];
                    [stateImgView makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(@-15);
                        make.top.equalTo(@15);
                        make.width.equalTo(@10);
                        make.height.equalTo(@15);
                    }];
                }
                
               
                
            }
            else
            {
                //左侧标题
                UILabel *leftTileLabel = [[UILabel alloc]init];
                leftTileLabel.font = [UIFont boldSystemFontOfSize:16];
                leftTileLabel.textColor  = RGBCOLOR(125, 125, 125);
                [cell.contentView addSubview:leftTileLabel];
                leftTileLabel.textColor = [UIColor blackColor];
                [leftTileLabel updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@30);
                    make.top.equalTo(@8);
                    make.width.equalTo(@(SCREEN_WIDTH-80));
                    make.height.equalTo(@30);
                }];
                
                //单选按钮
//                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                button.tag = 100+indexPath.row-1;
//                [button setBackgroundImage:[UIImage imageNamed:@"radio_unchecked"] forState:UIControlStateNormal];
//                [button setBackgroundImage:[UIImage imageNamed:@"radio_checked"] forState:UIControlStateSelected];
//                [button addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
                
               
                
                //提示
                UILabel *messLabel = [[UILabel alloc]init];
                messLabel.font = [UIFont systemFontOfSize:15];
                messLabel.adjustsFontSizeToFitWidth = YES;
                [cell.contentView addSubview:messLabel];
                [messLabel makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@60);
                    make.top.equalTo(@33);
                    make.right.equalTo(@-10);
                    make.height.equalTo(@30);
                }];
                
                if (indexPath.row==1)
                {
                    [cell.contentView addSubview:upBtn];
                    [upBtn makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(@30);
                        make.top.equalTo(@35);
                        make.width.equalTo(@25);
                        make.height.equalTo(@25);
                    }];
                    
                    leftTileLabel.text = [NSString stringWithFormat:@"账户可用余额 %@",self.infoDict[@"cashRemain"]];
                    if (moneyStatus==2||moneyStatus==3)
                    {
                          messLabel.text = @"扣除账户余额后剩余部分用信用额支付";
                    }
                    else
                    {
                          messLabel.text = @"使用账户可用余额付款";
                    }
                  
                    if (upBtn.hidden)
                    {
                        messLabel.hidden = YES;
                        
                    }
                    
                    
                }
                else if(indexPath.row==2)
                {
                    [cell.contentView addSubview:downBtn];
                    [downBtn makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(@30);
                        make.top.equalTo(@35);
                        make.width.equalTo(@25);
                        make.height.equalTo(@25);
                    }];
                    
                    leftTileLabel.text = [NSString stringWithFormat:@"可用信用额 %@",self.infoDict[@"creditRemain"]];
                    messLabel.text = @"使用信用额付款";
                   
                    if (downBtn.hidden)
                    {
                        messLabel.hidden = YES;
                    }
                }
                
                
               
            }
        }
        else if(indexPath.section==3)
        {
            
            if (indexPath.row==0)
            {
                leftTileLabel.text = @"订单金额";
                rightLabel.attributedText = [StaticTools getMoneyTextAtributionWithText:[NSString stringWithFormat:@"￥%@",self.infoDict[@"amount"]] frontFont:nil frontColor:nil moneyFont:[UIFont boldSystemFontOfSize:18] moneyColor:[UIColor redColor]];
            }
            else if(indexPath.row==1)
            {
                leftTileLabel.text = @"优惠金额";
                rightLabel.attributedText = [StaticTools getMoneyTextAtributionWithText:self.selectPreferntial == nil?@"￥0": [NSString stringWithFormat:@"￥%@",self.selectPreferntial.amount] frontFont:[UIFont systemFontOfSize:22] frontColor:[UIColor redColor] moneyFont:[UIFont boldSystemFontOfSize:18] moneyColor:[UIColor redColor]];
            }
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==2&&indexPath.row==0)
    {
        openPayWay = !openPayWay;
        [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    }
    if (indexPath.section == 1) {
        self.preferentVC = [PayOfPreferentialViewController new];
        self.preferentVC.preferentialDataArray = self.preferentialDataArray;
        self.preferentVC.frontContoller = self;
        self.preferentVC.selectPrefential = self.selectPreferntial;
        [self.navigationController pushViewController:self.preferentVC animated:YES];
    }
}

#pragma mark HTTP
/**
 *  获取订单信息
 */
- (void)getOrderInfo
{
 
    [[HttpRequest sharedRequest] sendRequestWithMessage:@"正在获取订单信息" path:@"consume/getOrderInfo" param:@{@"orderId":self.orderId} succuss:^(id result) {
        NSLog(@"%@",result);
        
        self.listTableView.hidden = NO;
        self.payView.hidden = NO;
        
        self.infoDict = [NSDictionary dictionaryWithDictionary:result];
   
        self.preferentialDataArray = result[@"coupons"];
        
        [self refreshStatus];
        
    } fail:nil];
}


/**
 *  订单支付
 *
 *  @param password 支付密码
 */
- (void)payOrderWithPassword:(NSString*)password
{
    NSString *payWay;
    if (moneyStatus==0)
    {
        if (upBtn.selected)
        {
            payWay= @"1";
        }
        else if (downBtn.selected)
        {
            payWay = @"2";
        }
    }
    else if(moneyStatus==1)
    {
        payWay = @"1";
    }
    else if(moneyStatus==2)
    {
        if (upBtn.selected)
        {
            payWay= @"1";
        }
        else if (downBtn.selected)
        {
            payWay = @"2";
        }
    }
    else if(moneyStatus==3)
    {
        payWay=@"1";
    }
    
    NSDictionary *dict = @{@"orderId":self.orderId,
                           @"payPassword":[SecurityTool md5:password],
                           @"couponIds":self.selectPreferntial==nil?@"": self.selectPreferntial.code, //优惠券编号
                           @"actualAmount":self.payMoney, //实际支付
                           @"payType":payWay}; //支付方式，优先 1 余额 2信用  如过余额不足 自动扣除信用  如果信用额加余额还不足 直接提示余额不足
    
    [[HttpRequest sharedRequest] sendRequestWithMessage:@"正在支付" path:@"consume/payOrder" param:dict succuss:^(id result) {
        
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            
            [APPDataCenter.scanNav dismissViewControllerAnimated:YES completion:nil];
            
        } title:nil message:@"支付成功" cancelButtonName:@"确定" otherButtonTitles:nil];
        
    } fail:nil];
    
}

@end
