//
//  MyTabBarController.m
//  
//
//  Created by 文彬 on 15-1-24.
//
//

#import "MyTabBarController.h"

#define kTag_Button_Middle 100
#define kTag_View_ModdleLine 200

@interface MyTabBarController ()
{
    CAKeyframeAnimation * animation;
}

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIView *tabbarview;

@end

@implementation MyTabBarController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRestartAnimation object:nil];
}

//修复重新添加viewcontrollers时产生点击错误
-(void)updateTabView
{
    
    for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
            if ([view.subviews containsObject:self.tabbarview]) {
                
               
                 [view bringSubviewToFront:self.tabbarview];
            }
			break;
		}
	}
}

/**
 *  启动扫描动画
 */
- (void)restartAnimation
{
    UIView *view = [[self.tabbarview viewWithTag:kTag_Button_Middle] viewWithTag:kTag_View_ModdleLine];
    
    [view.layer removeAnimationForKey:@"LineAnimation"];
    [view.layer addAnimation:animation forKey:@"LineAnimation"];
}

/**
 *  设置tab项图片
 *
 *  @param imgs
 */
-(void)setImages:(NSArray*)imgs
{
    self.tabbarview = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    self.tabbarview.backgroundColor = [UIColor whiteColor];
    
    
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartAnimation) name:kRestartAnimation object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartAnimation) name:kBecomeActivie object:nil];
    
     CGMutablePathRef path = CGPathCreateMutable();
    if (SCREEN_HEIGHT<=568)
    {
       
        CGPathMoveToPoint(path,NULL,32,21);
        CGPathAddLineToPoint(path, NULL, 32, 35);
        CGPathAddLineToPoint(path, NULL,32,21);
    }
    else if(SCREEN_HEIGHT==667)
    {
    
        CGPathMoveToPoint(path,NULL,38,21);
        CGPathAddLineToPoint(path, NULL, 38, 35);
        CGPathAddLineToPoint(path, NULL,38,21);
    }
    else
    {
        CGPathMoveToPoint(path,NULL,41,21);
        CGPathAddLineToPoint(path, NULL, 41, 35);
        CGPathAddLineToPoint(path, NULL,41,21);
    }
    
    
     animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setPath:path];
    [animation setDuration:3];
    [animation setRepeatCount:HUGE_VALF];
//    [animation setAutoreverses:YES];
    animation.removedOnCompletion = NO;
    CFRelease(path);
    
    [animation setKeyTimes:
     [NSArray arrayWithObjects:
      [NSNumber numberWithFloat:0],
      [NSNumber numberWithFloat:0.5],
      [NSNumber numberWithFloat:1], nil]];

    for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
            //去掉tabbar顶部线条
            UITabBar *bar = (UITabBar*)view;
            CGRect rect = CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height);
            UIGraphicsBeginImageContext(rect.size);
            CGContextRef context =UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
            CGContextFillRect(context, rect);
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [bar setBackgroundImage:img];
            [bar setShadowImage:img];
            
			[view addSubview:self.tabbarview];
            [view bringSubviewToFront:self.tabbarview];
            
			break;
        }
	}

    self.buttons = [NSMutableArray arrayWithCapacity:[imgs count]];
    
    CGFloat width = SCREEN_WIDTH / ([imgs count]+1);
    for (int i = 0; i < [imgs count]; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.showsTouchWhenHighlighted = YES;
        btn.tag = i;
        btn.frame = CGRectMake(i<2?width * i:width*i+width, 0, width+1, self.tabbarview.frame.size.height);
        [btn setImage:[[imgs objectAtIndex:i] objectForKey:@"Default"] forState:UIControlStateNormal];
        [btn setImage:[[imgs objectAtIndex:i] objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
        [btn setImage:[[imgs objectAtIndex:i] objectForKey:@"Seleted"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
//        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -5, 0);
        [self.buttons addObject:btn];
        [self.tabbarview addSubview:btn];
    }
    
    //中间突出的按钮
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.tabbarview.clipsToBounds = NO;
    btn.showsTouchWhenHighlighted = YES;
    btn.tag = kTag_Button_Middle;
    [btn addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
    //        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -5, 0);
    [self.tabbarview addSubview:btn];
    
    UIImageView *lineView = [[UIImageView alloc]init];
    lineView.tag = kTag_View_ModdleLine;
    
    lineView.image = [UIImage imageNamed:@"ip_yhlin"];
    [btn addSubview:lineView];
    [lineView.layer addAnimation:animation forKey:@"LineAnimation"];
    
    if(SCREEN_HEIGHT<=568)
    {
        lineView.frame = CGRectMake(0, 0, width-45, 2);
        [btn setImage:[UIImage imageNamed:@"icon_aa_n"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_aa_n"] forState:UIControlStateHighlighted];
        btn.frame = CGRectMake(width*2, -13.5, width+1, self.tabbarview.frame.size.height+15);
    }
    else
    {
        lineView.frame = CGRectMake((width-20)/2, 0,22, 2);
        btn.frame = CGRectMake(width*2, -18.5, width+1, self.tabbarview.frame.size.height+17);
        [btn setImage:[UIImage imageNamed:@"icon_aa_n_big"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_aa_n_big"] forState:UIControlStateHighlighted];
    }
  
   
    [self selectTabAtIndex:0];
}

/**
 *  设置当前选择tab
 *
 *  @param index 
 */
- (void)selectTabAtIndex:(NSInteger)index
{
	for (int i = 0; i < [self.buttons count]; i++)
	{
		UIButton *b = [self.buttons objectAtIndex:i];
		b.selected = NO;
		b.userInteractionEnabled = YES;
	}
	UIButton *btn = [self.buttons objectAtIndex:index];
	btn.selected = YES;
	btn.userInteractionEnabled = NO;
}

-(void) touchButton:(id)sender
{
    UIButton *btn = sender;
    
    if (btn.tag==1||btn.tag==2) //钱包和我的 需要登录后才能查看
    {
        if (![[UserDefaults objectForKey:kIsLogin] isEqualToString:@"1"])
        {
            
            [StaticTools showLoginControllerWithSuccess:^{
                
                [self selectTabAtIndex:btn.tag];
                
                self.selectedIndex = btn.tag;
                
            } fail:^{
                
            }];
            
            return;
        }
    }


    if (btn.tag==kTag_Button_Middle)
    {
        if (self.middleButtonClick!=nil)
        {
            self.middleButtonClick();
        }
        return;
    }
    
    [self selectTabAtIndex:btn.tag];
    
    self.selectedIndex = btn.tag;
}

@end
