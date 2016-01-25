//
//  AdvertDetailViewController.m
//  
//
//  Created by 文彬 on 15/7/19.
//
//

#import "AdvertDetailViewController.h"
#import "SDWebImageDownloader.h"
#import "AppNavView.h"
#import "UIColor+NSString.h"
@interface AdvertDetailViewController ()
@property (nonatomic, strong) AppNavView *navView;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (strong, nonatomic) NSMutableArray *imageArray;

@end

@implementation AdvertDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavView];

    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.title = @"活动详情";
    [self.listTableView reloadData];
    self.listTableView.backgroundColor = [UIColor clearColor];
    
    self.imageArray = [[NSMutableArray alloc]initWithObjects:@"",@"",@"", nil];
    NSArray *images = self.infoDict[@"imgPaths"];
    if (images.count>0)
    {
        [self downloadPicture];
    }
}
-(void)makeNavView
{
    self.navView = [AppNavView new];
    self.navView.delegate = self;
    [self.view addSubview:self.navView];
    self.navView.titleLabel.text = @"活动详情";
    
    self.navView.leftImgView.image = [UIImage imageNamed:@"whiteBack"];
    
//    [self.navView.navLeftBtn addTarget : self
//                                action : @selector(navLeftBtnDown)
//                      forControlEvents : UIControlEventTouchUpInside];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.navView.size = CGSizeMake(SCREEN_WIDTH, Dev_NavigationBar_Height);
    
}
#pragma mark - navBtnClick
-(void)navLeftBtnDown
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 功能函数
/**re
 *	@brief	获取图片在cell里展示的最佳frame  图片宽大于高时：长度最大为tableview的宽度 高度为其对应缩放
 图片高大于宽时：最大高度为屏幕高度 宽度为其对应缩放
 *
 *	@param 	image 	图片数据
 *
 *	@return
 */
- (CGRect)getRectWithImage:(UIImage*)image

{
    CGRect rect = CGRectMake(150, 150, 10, 10);
    float maxHeight;
    if (image.size.width>image.size.height)
    {
        maxHeight = 300;
    }
    else
    {
        maxHeight = ScreenHeight-64;
    }
    
    CGRect frame = CGRectMake(10, 0, SCREEN_WIDTH-20, maxHeight);
    //图片尺寸比view小 按原图尺寸显示
    if (image.size.width<frame.size.width&&image.size.height<maxHeight)
    {
        rect = CGRectMake((frame.size.width-image.size.width)/2, 5,
                          image.size.width, image.size.height);
    }
    else
    {
        CGRect showRect = CGRectMake(0, 0, frame.size.width ,maxHeight);
        float rate = image.size.width/image.size.height;
        
        float rateBox = showRect.size.width/(showRect.size.height);
        if(rate > rateBox){
            rect.size.width = frame.size.width;
            rect.size.height = frame.size.width/rate;
        }else{
            rect.size.height = showRect.size.height;
            rect.size.width = (showRect.size.height)*rate;
        }
        
        rect.origin.x= (frame.size.width-rect.size.width)/2;
        rect.origin.y = 5;
    }
    return rect;
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *images =  self.infoDict[@"imgPaths"];
    return images.count +1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = [self.infoDict[@"title"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size.height;
    return height+35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
         float height = [self.infoDict[@"content"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size.height;
        return height+10;
    }
    //图片下载完成时返回图片的适应大小  图片未下载完完返回50
    if ([self.imageArray[indexPath.row-1] isKindOfClass:[UIImage class]])
    {
        return [self getRectWithImage:self.imageArray[indexPath.row-1]].size.height+10;
    }
    else
    {
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float height = [self.infoDict[@"title"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size.height;
    
    UIView *headVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height+35)];
    //*********************标题文字***************************
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.text = self.infoDict[@"title"];
    [headVeiw addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@5);
        make.right.equalTo(@-10);
        make.height.equalTo(@(height+5));
    }];
    
    //*********************时间文字***************************
    //时间戳转化为日期
    NSString * timeStampString = [NSString stringWithFormat:@"%@", self.infoDict[@"publishDate"]];
    NSTimeInterval _interval=[timeStampString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *time = [objDateformat stringFromDate: date];
    time = [time substringToIndex:16];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor = [UIColor darkGrayColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.text = time;
    [headVeiw addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(titleLabel.bottom).offset(5);
        make.right.equalTo(@-20);
        make.height.equalTo(@20);
    }];
    
    return headVeiw;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if(indexPath.row==0)
    {
        //*********************详情文字***************************
        float height = [self.infoDict[@"content"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size.height;
        
        UILabel *detailLabel = [[UILabel alloc]init];
        detailLabel.font = [UIFont systemFontOfSize:15];
        detailLabel.numberOfLines = 0;
        detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        detailLabel.text = self.infoDict[@"content"];
        [cell.contentView addSubview:detailLabel];
        [detailLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@5);
            make.right.equalTo(@-10);
            make.height.equalTo(@(height+5));
        }];
        
    }
    else
    {
      
        //图片下载完成
        if ([self.imageArray[indexPath.row-1] isKindOfClass:[UIImage class]])
        {
            CGRect rect = [self getRectWithImage:self.imageArray[indexPath.row-1]];
            
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, tableView.frame.size.width-20, 180)];
            imgView.image = self.imageArray[indexPath.row-1];
            [cell.contentView addSubview:imgView];
            [imgView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(rect.origin.y));
                make.left.equalTo(@(rect.origin.x+10));
                make.width.equalTo(@(rect.size.width));
                make.height.equalTo(@(rect.size.height));
            }];
            
            
            
//            imgView.frame = CGRectMake(, , , );
        }
        else
        {
            //图片没下载下载时  显示转圈
            UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//            activity.frame = CGRectMake((SCREEN_WIDTH-50)/2, 5, 50, 50);
            [activity startAnimating];
            [cell.contentView addSubview:activity];
            [activity makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(@5);
                make.left.equalTo(@((SCREEN_WIDTH-50)/2));
                make.width.equalTo(@50);
                make.height.equalTo(@50);
            }];
        }
    }

    return cell;
}

#pragma mark HTTP
/**
 *  下载图片
 */
- (void)downloadPicture
{
    NSArray *images = self.infoDict[@"imgPaths"];
    for (int i=0;i<images.count;i++)
    {
        NSString *path = images[i];
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:path] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (image!=nil)
            {
                [self.imageArray replaceObjectAtIndex:i withObject:image];
                [self.listTableView reloadData];
            }
           
        }];
    }
}

@end
