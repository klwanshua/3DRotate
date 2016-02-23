//
//  ViewController.m
//  RYMutipleFoldImage
//
//  Created by billionsfinance-resory on 15/11/15.
//  Copyright © 2015年 Resory. All rights reserved.
//

#import "ViewController.h"

#define IMAGE_PER_HEIGIT 300.0
#define BU_SHU(a) (1-c)
#define ARC4RANDOM_MAX      0x100000000
@interface ViewController ()

@property (nonatomic, strong) UIImageView *one;
@property (nonatomic, strong) UIImageView *two;
@property (nonatomic, strong) UIImageView *three;
@property (nonatomic, strong) UIImageView *four;

@property (nonatomic, strong) UIView *oneShadowView;
@property (nonatomic, strong) UIView *threeShadowView;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configFourFoldImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Configuration
CGFloat value = 0;
- (void)configFourFoldImage
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 300, IMAGE_PER_HEIGIT)];

    self.bgView = bgView;
    [self.view addSubview:bgView];
    
    CGFloat ratio = 0.25;
    for (int i = 0; i < 4; i++) {
        _two = [[UIImageView alloc] init];
        _two.image = [UIImage imageNamed:@"Kiluya.jpg"];
        _two.layer.contentsRect = CGRectMake(ratio*i, 0, ratio, 0.5);

        _two.frame = CGRectMake(IMAGE_PER_HEIGIT*ratio*i, 0, IMAGE_PER_HEIGIT
                                *ratio, IMAGE_PER_HEIGIT*0.5);
        if (i == 0) {
            _two.layer.contentsRect = CGRectMake(0, 0, ratio, 0.5);
            _two.frame = CGRectMake(0, 0, IMAGE_PER_HEIGIT
                                    *ratio, IMAGE_PER_HEIGIT*0.5);
        }
        [bgView addSubview:_two];
    }
    
    for (int i = 0; i < 4; i++) {
        _two = [[UIImageView alloc] init];
        _two.image = [UIImage imageNamed:@"Kiluya.jpg"];
        _two.layer.contentsRect = CGRectMake(ratio*i, 0.5, ratio, 0.5);
        
        _two.frame = CGRectMake(IMAGE_PER_HEIGIT*ratio*i, 0.5*IMAGE_PER_HEIGIT, IMAGE_PER_HEIGIT
                                *ratio, IMAGE_PER_HEIGIT*0.5);
        if (i == 0) {
            _two.layer.contentsRect = CGRectMake(0, 0.5, ratio, 0.5);
            _two.frame = CGRectMake(0, 0.5*IMAGE_PER_HEIGIT, IMAGE_PER_HEIGIT
                                    *ratio, IMAGE_PER_HEIGIT*0.5);
        }
        [bgView addSubview:_two];
    }
}

#pragma mark -
#pragma mark - Action

// 动效是否执行中
static bool isFolding = NO;
- (IBAction)fold:(id)sender
{      
        isFolding = YES;

        [UIView animateWithDuration:1.0
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
//            // 阴影显示
//            _oneShadowView.alpha = 0.2;
//            _threeShadowView.alpha = 0.2;

            // 折叠
                             [self.bgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                 UIImageView *imageView = obj;
                                 imageView.layer.transform = [self config3DTransformWithRotateAngle:[self getRandomNumber:0 to:360] andPositionX:[self getRandomNumber:0 to:100] andPositionY:[self getRandomNumber:0 to:300]];
                             }];
                             
        } completion:^(BOOL finished) {
            
            if(finished)
            {
                isFolding = NO;
            }
        }];
 
}

- (IBAction)resetLayerTransform
{
    value = 0;
    isFolding = NO;
    /*delay延迟多久调用完成finished
    动画效果usingSpringWithDamping的范围为0.0f到1.0f，数值越小「弹簧」的振动效果越明显
    initialSpringVelocity（默认0）则表示初始的速度，数值越大一开始移动越快，值得注意的是，初始速度取值较高而时间较短时，也会出现反弹情况http://www.renfei.org/blog/ios-8-spring-animation.html
 */
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:00
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.bgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                             UIImageView *imageView = obj;
                             imageView.layer.transform = CATransform3DIdentity;
                         }];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (CATransform3D)config3DTransformWithRotateAngle:(double)angle andPositionX:(double)x andPositionY:(double)y
{
    CATransform3D transform = CATransform3DIdentity;
    
    //  iOS的三维透视投影 实现view（layer）的透视效果（就是近大远小），是通过设置m34的参考：http://blog.csdn.net/yongyinmg/article/details/38780953
    transform.m34 = 1/0;
    /*
       旋转 CATransform3DRotate (CATransform3D t, CGFloat angle,CGFloat x, CGFloat y, CGFloat z) angle旋转弧度：角度 * M_PI / 180，
       x值范围-1 --- 1之间 正数表示左侧看向外旋转，负数表示向里CATransform3DRotate(transform, M_PI*angle/180, 1, 0, 0）图1
       y值范围-1 --- 1之间 正数左侧看表示向外旋转，负数表示向里CATransform3DRotate(transform, M_PI*angle/180, 0, 1, 0）图2
       同时设置x，y表示沿着对角线翻转
           CATransform3DRotate(transform, M_PI*angle/180, 1, 1, 0）图3
       z值范围-1 --- 1之间 正数逆时针旋转，负数表示顺CATransform3DRotate(transform, M_PI*angle/180, 0, 0, -1）图4
        同时设置x,y,z按照设定的数值进行旋转
       CATransform3D rotateTransform = CATransform3DRotate(transform, M_PI*angle/180, 1, 1, 1);图5
     */
    
    CATransform3D rotateTransform = CATransform3DRotate(transform, M_PI*angle/180, 1, 1, 1);
    // 移动(这里的y坐标是平面移动的的距离,我们要把他转换成3D移动的距离.这是关键,没有它图片就没办法很好地对接。)
    CATransform3D moveanim = CATransform3DMakeTranslation(x, y, 0);
    // 合并
    CATransform3D concatTransform = CATransform3DConcat(rotateTransform, moveanim);
    return concatTransform;
}


-(CGFloat)getRandomNumber:(int)from to:(int)to

{

    return (from+ 1 + (arc4random() % (to - from + 1)));
    
}



- (void)text{
    
    CGFloat c = [self getRandomNumber:0 to:1000]; // 0-1在之间随机数
    NSMutableArray *numArray = [[NSMutableArray alloc] initWithObjects:@(c
    ),nil];
    CGFloat total = 0.0; // 记录总和
    for (int i = 0; i < 10; i++) {
        for (NSNumber *single in numArray) {
            total = [single floatValue] + total;
        }
       c = [self getRandomNumber:0 to:(1-total)*1000];
        [numArray addObject:@(c)];
    }

    NSLog(@"%@",numArray);
}

//    CGFloat r = 0;
//    
//    for (int i = 0; i < 3; i++) {
//        c = [self getRandomNumber:(1-c)*10 to:10];
//        _two = [[UIImageView alloc] init];
//        _two.image = [UIImage imageNamed:@"Kiluya.jpg"];
//        _two.layer.contentsRect = CGRectMake(c, 0, c, d);
//        //    _two.layer.anchorPoint = CGPointMake(0.5, 1.0);
//        _two.frame = CGRectMake(300*BU_SHU(c)*0.1+i*2, 0, 300*BU_SHU(c)*0.1, 300*d);
//        [bgView addSubview:_two];
//        
//    }




@end
