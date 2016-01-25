//
//  ErrorViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-21.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "MessageViewController.h"
@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.hidesBackButton = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   self.navigationItem.title = @"信息提示";
    
    if (![StaticTools isEmptyString:self.messStr])
    {
        self.messLabel.text = self.messStr;
    }
    
    if (self.messType == kMessageTypeSeccuss)
    {
        self.imgView.image = [UIImage imageNamed:@"transaction_success"];
    }
    else if(self.messType == kMessageTypeFail)
    {
        self.imgView.image = [UIImage imageNamed:@"transaction_fail"];
    }
    else if(self.messType == kMessageTypeNomal)
    {
        self.imgView.hidden = YES;
        self.messLabel.frame = CGRectMake(self.messLabel.frame.origin.x, self.messLabel.frame.origin.y-50, self.messLabel.frame.size.width, self.messLabel.frame.size.height);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClickHandle:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.clickBlock)
    {
        self.clickBlock();
    }

}

@end
