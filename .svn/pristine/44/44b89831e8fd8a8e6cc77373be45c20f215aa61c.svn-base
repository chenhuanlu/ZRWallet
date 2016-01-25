//
//  HelpCenterViewController.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/8/26.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
static int tableCellHeight = 50;

#import "UIColor+NSString.h"
#import "HelpCenterViewController.h"
#import "HelpAboutViewController.h"
@interface HelpCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帮 助";
       
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeView];
}

- (void)makeView
{
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
    [self.view addSubview:self.tableView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableCellHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *titleArray = @[ @"自动登录",
                             @"消息推送设置",
                             @"黑名单",
                             @"诊断",
                             @"使用IP",
                             @"退群时删除会话",
                             @"iOS离线推送昵称",
                             @"显示视频通话信息",
                             @"个人信息"
                            ];
    cell.textLabel.text = titleArray[indexPath.row];
    cell.textLabel.textColor =  RGBCOLOR(58, 58, 58);
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
    self.lineView = [UIView new];
    self.lineView.size = CGSizeMake(self.view.size.width - 10, 1);
    self.lineView.viewLeft = 5;
    self.lineView.viewTop = tableCellHeight - 1;
    self.lineView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
    [cell.contentView addSubview:self.lineView];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelpAboutViewController *helpAboutVC = [HelpAboutViewController new];
    [self.navigationController pushViewController:helpAboutVC animated:YES];

  


}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.tableView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - Dev_NavigationBar_Height);
    self.tableView.viewTop = 0;
    
    
    
}
@end
