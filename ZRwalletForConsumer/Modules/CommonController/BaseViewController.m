//
//  BaseViewController.m
//  
//
//  Created by 文彬 on 14-5-11.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "BaseViewController.h"
//#import "BaiduMobStat.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.view.backgroundColor = RGBCOLOR(236, 236, 236);
    
    if (!self.navigationItem.hidesBackButton&&self.navigationController.viewControllers.count>1)
    {
        [self initNavgationcontrollerLeftButton];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (addKeyBoardNotification)
    {
        [self addKeyboardNotification];
    }
    
}

-(void) viewDidAppear:(BOOL)animated{
    
    //    NSString *cName = [NSString stringWithFormat:@"%@", self.class, nil];
    //    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
}

-(void) viewDidDisappear:(BOOL)animated{
    
    //    NSString *cName = [NSString stringWithFormat:@"%@", self.class, nil];
    //    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle

{
    return UIStatusBarStyleBlackTranslucent;
}


- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark--定制导航栏左侧返回按钮
/**
 *  定制返回按钮  在基类的viewdidload里调用 不需要返回按钮或需定制和基类不一样的按钮时 可在子类里自行处理
 */
- (void)initNavgationcontrollerLeftButton
{
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ip_anjy_co_s"] forBarMetrics:UIBarMetricsDefault];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 13, 12, 20)];
    backImg.image = [UIImage imageNamed:@"whiteBack"];
    [leftView addSubview:backImg];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 60, 44);
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftView addSubview:backBtn];
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    
}

/**
 *  点击导航栏左侧返回按钮  如有必要  可在子类重写
 */
- (void)back
{
     [[HttpRequest sharedRequest] cancelLastRequst];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRestartAnimation object:nil];
}

#pragma mark -keyboardDelegate
/**
 *  增加键盘显示、隐藏的通知
 */
- (void)addKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

-(void)keyboardWasShown:(NSNotification *)notification
{
    NSValue  *valu_=[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGRect rectForkeyBoard=[valu_ CGRectValue];
    keyBoardLastHeight=rectForkeyBoard.size.height;
    
    [self keyBoardShowWithHeight:keyBoardLastHeight];
}

-(void)keyboardWasHidden:(NSNotification *)notification
{
    keyBoardLastHeight=0;
    [self keyBoardHidden];
}

/**
 *  键盘显示时调用 需要处理键盘弹出的可在子类重写该函数
 *
 *  @param height 键盘高度
 */
- (void)keyBoardShowWithHeight:(float)height
{
    
}

//键盘隐藏时调用 需要处理键盘隐藏的可在子类重写该函数
- (void)keyBoardHidden
{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
