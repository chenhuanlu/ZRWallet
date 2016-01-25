//
//  BillDetailViewController.m
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/7/9.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "BillDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface BillDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (strong, nonatomic) NSDictionary *infoDict;

@end

@implementation BillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"账单详情";
    
    [self getOrderDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.infoDict==nil)
    {
        return 0;
    }
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 50;
    }
    else if(indexPath.row==1)
    {
        return 80;
    }
    else if(indexPath.row==2)
    {
        if([self.orderType isEqualToString:@"9"]||
           [self.orderType isEqualToString:@"2"]||
           [self.orderType isEqualToString:@"10"]) //二维码消费
        {
            return 160;
        }
        
        return 80;
    }
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (indexPath.row==0)
    {
        //*********************状态图片***************************
        UIImageView *leftImage = [[UIImageView alloc]init];
        leftImage.backgroundColor = [UIColor clearColor];
        leftImage.image = [UIImage imageNamed:@"transaction_success"];
        [cell.contentView addSubview:leftImage];
        [leftImage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@5);
            make.width.equalTo(@35);
            make.height.equalTo(@35);
        }];
        
        //*********************状态文字***************************
        UILabel *rightLabel = [[UILabel alloc]init];
        [cell.contentView addSubview:rightLabel];
        rightLabel.text = @"交易成功";
        rightLabel.font = [UIFont systemFontOfSize:17];
        [rightLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@55);
            make.top.equalTo(@10);
            make.right.equalTo(@-5);
            make.height.equalTo(@30);
        }];
    }
    else if(indexPath.row==1)
    {
        
        //*********************文字***************************
        UILabel *topLabel = [[UILabel alloc]init];
        [cell.contentView addSubview:topLabel];
        topLabel.text = @"交易金额";
        topLabel.textColor = [UIColor darkGrayColor];
        topLabel.font = [UIFont systemFontOfSize:15];
        [topLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@10);
            make.right.equalTo(@-5);
            make.height.equalTo(@30);
        }];
        
        
        //*********************金额***************************
        UILabel *moneyLabel = [[UILabel alloc]init];
        [cell.contentView addSubview:moneyLabel];
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        NSString *moneyStr = [NSString stringWithFormat:@"%@元",[StaticTools formatMoney:self.infoDict[@"amount"]]];
        
        NSMutableAttributedString *moneyAtr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        
        [moneyAtr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:30] range:NSMakeRange(0, moneyStr.length-1)];
        [moneyAtr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(moneyStr.length-1,1)];
        moneyLabel.attributedText = moneyAtr;
        [moneyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@40);
            make.right.equalTo(@-10);
            make.height.equalTo(@30);
        }];
            
        }
        else if(indexPath.row==2)
        {
            if([self.orderType isEqualToString:@"5"])  //提现
            {
                //*********************文字***************************
                UILabel *topLabel = [[UILabel alloc]init];
                [cell.contentView addSubview:topLabel];
                topLabel.text = @"提现账户";
                topLabel.textColor = [UIColor darkGrayColor];
                topLabel.font = [UIFont systemFontOfSize:15];
                [topLabel makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@10);
                    make.top.equalTo(@10);
                    make.width.equalTo(@70);
                    make.height.equalTo(@30);
                }];
                
                for (int i=0; i<2; i++)
                {
                    UILabel *detailLabel = [[UILabel alloc]init];
                    [cell.contentView addSubview:detailLabel];
                    detailLabel.font = [UIFont systemFontOfSize:15];
                    [detailLabel makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(@80);
                        make.top.equalTo(@(10+i*30));
                        make.right.equalTo(@-10);
                        make.height.equalTo(@30);
                    }];
                    
                    if (i==0)
                    {
                        detailLabel.text = self.infoDict[@"recipient"];
                    }
                    else if(i==1)
                    {
                        detailLabel.text = self.infoDict[@"toBankCard"];
                    }
                }
            }
            else  if([self.orderType isEqualToString:@"3"]|| //理财投资
                     [self.orderType isEqualToString:@"6"]|| //投资到期，归还本金
                     [self.orderType isEqualToString:@"4"])  //理财收益
             {
                 //*********************文字***************************
               
                 
                 for (int i=0; i<2; i++)
                 {
                     UILabel *leftLabel = [[UILabel alloc]init];
                     [cell.contentView addSubview:leftLabel];
                     leftLabel.textColor = [UIColor darkGrayColor];
                     leftLabel.font = [UIFont systemFontOfSize:15];
                     [leftLabel makeConstraints:^(MASConstraintMaker *make) {
                         make.left.equalTo(@10);
                         make.top.equalTo(@(10+i*30));
                         make.width.equalTo(@70);
                         make.height.equalTo(@30);
                     }];
                     
                     UILabel *detailLabel = [[UILabel alloc]init];
                     [cell.contentView addSubview:detailLabel];
                     detailLabel.font = [UIFont systemFontOfSize:15];
                     [detailLabel makeConstraints:^(MASConstraintMaker *make) {
                         make.left.equalTo(@100);
                         make.top.equalTo(@(10+i*30));
                         make.right.equalTo(@-10);
                         make.height.equalTo(@30);
                     }];
                     
                     if (i==0)
                     {
                         leftLabel.text = @"投资项目";
                         detailLabel.text = self.infoDict[@"projectName"];
                     }
                     else if(i==1)
                     {
                         leftLabel.text = @"预期收益";
                         detailLabel.text = [NSString stringWithFormat:@"%.2f元",[self.infoDict[@"earning"] floatValue]];
                     }
                 }
             }
            
            else if([self.orderType isEqualToString:@"9"]||
                    [self.orderType isEqualToString:@"2"]||
                    [self.orderType isEqualToString:@"10"]) //二维码消费
            {
                //商户头像
                UIImageView *leftImgView = [[UIImageView alloc]init];
                leftImgView.backgroundColor = [UIColor clearColor];
                [leftImgView sd_setRoundImageWithURL:[NSURL URLWithString:self.infoDict[@"merAvatar"]] placeholderImage:[UIImage imageNamed:@"ip_shhyxx_def"]];
                [cell.contentView addSubview:leftImgView];
                [leftImgView makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(@10);
                    make.left.equalTo(@10);
                    make.width.equalTo(@60);
                    make.height.equalTo(@60);
                }];
                
                //商户名称
                UILabel *nameLabel = [[UILabel alloc]init];
                nameLabel.font = [UIFont boldSystemFontOfSize:15];
                nameLabel.text = self.infoDict[@"merName"];
                [cell.contentView addSubview:nameLabel];
                [nameLabel makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@85);
                    make.top.equalTo(@15);
                    make.right.equalTo(@-10);
                    make.height.equalTo(@30);
                }];
                
                //1:100,2:10,3:6666610101,4:10,5:110  表示余额支付100元信用支付10元并使用了编号为666面值10元的优惠券总共支付了110
                NSArray *arr = [self.infoDict[@"detail"] componentsSeparatedByString:@","];
            
                NSString *countMoney = [arr[0] stringByReplacingOccurrencesOfString:@"1:" withString:@""];
               NSString *creditMoney = [arr[1] stringByReplacingOccurrencesOfString:@"2:" withString:@""];
               NSString *couponMoney = [arr[3] stringByReplacingOccurrencesOfString:@"4:" withString:@""];
                NSString *totalMoney = [NSString stringWithFormat:@"%.2f",[countMoney floatValue]+[creditMoney floatValue]+[couponMoney floatValue]];
                
                
                for (int i=0; i<4; i++)
                {
                    //*********************文字***************************
                    UILabel *topLabel = [[UILabel alloc]init];
                    [cell.contentView addSubview:topLabel];
                    topLabel.textColor = [UIColor darkGrayColor];
                    topLabel.font = [UIFont systemFontOfSize:13];
                    [topLabel makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(@10);
                        make.top.equalTo(@(70+i*20));
                        make.width.equalTo(@90);
                        make.height.equalTo(@30);
                    }];
                    
                    
                    UILabel *detailLabel = [[UILabel alloc]init];
                    [cell.contentView addSubview:detailLabel];
                    detailLabel.font = [UIFont systemFontOfSize:13];
                    [detailLabel makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(@100);
                        make.top.equalTo(@(70+i*20));
                        make.right.equalTo(@-10);
                        make.height.equalTo(@30);
                    }];
                    
                    if (i==0)
                    {
                        topLabel.text = @"订单金额";
                        detailLabel.text = [NSString stringWithFormat:@"%@元",totalMoney];
                    }
                    else if(i==1)
                    {
                        topLabel.text = @"账户余额支付";
                        detailLabel.text = [NSString stringWithFormat:@"%@元",countMoney];
                        
                    }
                    else if(i==2)
                    {
                        topLabel.text = @"信用额支付";
                        detailLabel.text = [NSString stringWithFormat:@"%@元",creditMoney];
                    }
                    else if(i==3)
                    {
                        topLabel.text = @"优惠券抵扣";
                        detailLabel.text = [NSString stringWithFormat:@"%@元",couponMoney];
                    }
                }
                
            }
        
    }
    else if(indexPath.row==3)
    {
        for (int i=0; i<3; i++)
        {
            //*********************文字***************************
            UILabel *topLabel = [[UILabel alloc]init];
            [cell.contentView addSubview:topLabel];
            topLabel.textColor = [UIColor darkGrayColor];
            topLabel.font = [UIFont systemFontOfSize:15];
            [topLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@10);
                make.top.equalTo(@(10+i*30));
                make.width.equalTo(@70);
                make.height.equalTo(@30);
            }];
            
            
            UILabel *detailLabel = [[UILabel alloc]init];
            [cell.contentView addSubview:detailLabel];
            detailLabel.font = [UIFont systemFontOfSize:15];
            [detailLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@100);
                make.top.equalTo(@(10+i*30));
                make.right.equalTo(@-10);
                make.height.equalTo(@30);
            }];
            
            if (i==0)
            {
                topLabel.text = @"交易类型";
                if([self.orderType isEqualToString:@"1"]) //充值
                {
                    detailLabel.text = @"充值";
                }
                else if([self.orderType isEqualToString:@"4"]) //理财收益
                {
                    detailLabel.text = @"理财收益";
                }
                else if([self.orderType isEqualToString:@"5"]) //提现
                 {
                     detailLabel.text = @"提现";
                 }
                else if([self.orderType isEqualToString:@"3"]) //投资
                {
                    detailLabel.text = @"理财投资";
                }
                else if([self.orderType isEqualToString:@"6"]) //投资到期
                {
                    detailLabel.text = @"投资到期，归还本金";
                }
                else if([self.orderType isEqualToString:@"9"]||
                        [self.orderType isEqualToString:@"2"]||
                        [self.orderType isEqualToString:@"10"]) //消费
                {
                     detailLabel.text = @"消费";
                }
                
            }
            else if(i==1)
            {
                if ([self.orderType isEqualToString:@"6"]||
                    [self.orderType isEqualToString:@"4"])
                {
                   detailLabel.text = self.infoDict[@"operationTime"];
                }
                else
                {
                    detailLabel.text = self.infoDict[@"createTime"];
                }
                topLabel.text = @"创建时间";
                
            }
            else if(i==2)
            {
                topLabel.text = @"交易单号";
                detailLabel.text = self.orderId;
                detailLabel.numberOfLines = 0;

            }
        }
    }
 
    return cell;
}

#pragma mark http
/**
 *  获取订单详情
 */
- (void)getOrderDetail
{
 
    
    [[HttpRequest sharedRequest] sendRequestWithMessage:nil path:@"account/getOrderDetail" param:@{@"orderId":self.orderId,@"orderType":self.orderType} succuss:^(id result) {
        
        self.infoDict = [NSDictionary dictionaryWithDictionary:result];
        [self.listTableView reloadData];
    } fail:nil];
}

@end
