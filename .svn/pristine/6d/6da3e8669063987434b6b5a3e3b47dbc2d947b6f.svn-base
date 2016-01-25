//
//  FeedbackViewController.m
//  ZRwalletForConsumer
//
//  Created by 陈焕鲁 on 15/6/30.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "FeedbackViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+NSString.h"
#import "SKPSMTPMessage.h"
#define textViewTag 100
@interface FeedbackViewController ()<UITextViewDelegate,SKPSMTPMessageDelegate>
{
    long remainTextNum_;
    SKPSMTPMessage *sendMsg ;
}
@property (nonatomic,strong)UILabel *placeholderLabel;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
 
    //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //_textView.layer.borderColor = UIColor.grayColor.CGColor;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _textView.hidden = NO;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 6;
    _textView.layer.masksToBounds = YES;
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.text = @"请输入您宝贵得意见！";
    _placeholderLabel.font = [UIFont systemFontOfSize:15];
    _placeholderLabel.enabled = NO;//lable必须设置为不可用
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.frame = CGRectMake(10, 0, 200, 30);
    [_textView addSubview:_placeholderLabel];
    _textView.delegate = self;
    _textView.tag = textViewTag +1;
    
    _BottomLabel.text  = @"建议留下手机号以便我们帮您解决问题";
    _BottomLabel.font = [UIFont systemFontOfSize: 14];
    //提交
    [_SubmitButton setBackgroundImage:[UIImage imageNamed:@"ip_yj_su"] forState:UIControlStateNormal];
    [_SubmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _SubmitButton.layer.cornerRadius = 5;
    _SubmitButton.clipsToBounds = YES;
    
   _LeftLabel.font = [UIFont systemFontOfSize:14];
}


- (void)back
{
    [[HttpRequest sharedRequest] hideHUD];
    sendMsg.delegate =nil;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UITextFieldDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView

{
    
//    textView.text=@"";
    
    _textView.textColor = [UIColor blackColor];
    
    return YES;
    
}
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect frame = textView.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}
//输入框编辑完成以后，将视图恢复到原始状态
-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSString *info = [NSString stringWithFormat:@"还可输入%ld个字",remainTextNum_];
    _LeftLabel.text =info;
    self.view.frame =CGRectMake(0, Dev_NavigationBar_Height, self.view.frame.size.width, self.view.frame.size.height);

}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
       
        [self.view endEditing:YES];//UITextView return键隐藏键盘
        return NO;
    }
    
    if (range.location>=140)
        
    {
        
        [SVProgressHUD showErrorWithStatus:@"您已输入140个字"];
        return NO;
        
    }
           else
        
    {
        
        return YES;
        
    }
}
#pragma mark 回收键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];  //放弃所有响应者
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSString  * nsTextContent=textView.text;
    long   existTextNum=[nsTextContent length];
    remainTextNum_=140-existTextNum;
    if (textView.text.length == 0) {
         _placeholderLabel.text = @"请输入您宝贵得意见！";
    }else{
        _placeholderLabel.text = @"";
    }
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
#pragma mark 提交意见
- (IBAction)CommitButton:(id)sender {
    
    
//    if ([_textView.text isEqualToString:@""])
//    {
//        
//        [SVProgressHUD showErrorWithStatus:@"您还没有给我们意见哟"];
//        
//    }
    
    if ([StaticTools isEmptyString:self.textView.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入内容"];
        return;
    }
    
    
//    [SVProgressHUD showWithStatus:@"正在发送..." maskType:SVProgressHUDMaskTypeClear];
    [[HttpRequest sharedRequest] showHUDwihtMess:@"正在发送"];
    
    sendMsg = [[SKPSMTPMessage alloc] init];
    sendMsg.fromEmail = @"jia_people@163.com";
    sendMsg.toEmail =@"18253596008@163.com";
    sendMsg.relayHost = @"smtp.163.com";
    sendMsg.requiresAuth = YES;
    sendMsg.login = @"jia_people@163.com";
    sendMsg.pass = @"jia_people_test";
    sendMsg.subject = @"peoplepay IOS feedback"; // 中文会乱码  意见反馈
    //testMsg.bccEmail = @"tinghuisun@163.com"; // 抄送
    sendMsg.wantsSecure = YES; // smtp.gmail.com doesn't work without TLS!
    
    // Only do this for self-signed certs!
    sendMsg.validateSSLChain = NO;
    sendMsg.delegate = self;
    
    NSString *content =   [NSString stringWithFormat:@"%@ %@", self.textView.text, [UserDefaults objectForKey:KUSERNAME]];
    /***
     NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
     content,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
     ***/
    
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                               [NSString stringWithCString:[content UTF8String] encoding:NSUTF8StringEncoding],kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    
    sendMsg.parts = [NSArray arrayWithObjects:plainPart,nil];
    
    [sendMsg send];

}
#pragma mark SKPSMTPMessage Delegate Methods
- (void)messageState:(SKPSMTPState)messageState;
{
    //    NSLog(@"HighestState:%d", HighestState);
    //    if (messageState > HighestState)
    //        HighestState = messageState;
    //
    //    ProgressBar.progress = (float)HighestState/(float)kSKPSMTPWaitingSendSuccess;
}
- (void)messageSent:(SKPSMTPMessage *)SMTPmessage
{
//    [SVProgressHUD dismiss];
    [[HttpRequest sharedRequest] hideHUD];
    
    [SVProgressHUD showSuccessWithStatus:@"提交成功"];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)messageFailed:(SKPSMTPMessage *)SMTPmessage error:(NSError *)error
{
//    [SVProgressHUD dismiss];
       [[HttpRequest sharedRequest] hideHUD];
    [SVProgressHUD showErrorWithStatus:@"提交失败，请稍后再试"];
    NSLog(@"email faild: %@",[error localizedDescription]);
    
}

@end
