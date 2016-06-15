//
//  CALayerVC.m
//  AnimationDemo
//
//  Created by 权仔 on 16/6/14.
//  Copyright © 2016年 XZQ. All rights reserved.
//

#import "CALayerVC.h"

@interface CALayerVC ()

@property (nonatomic, strong) UIView *aView;

@end

@implementation CALayerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 了解CALayer和其属性
    [self calayer];
}

- (void)calayer
{
    /* UIView没有暴露出来的CALayer的功能：
        1.阴影、圆角，带颜色的边框
        2.3D变换
        3.非矩形范围
        4.透明遮罩
        5.多级非线性动画
    */
    // 关于CALayer的几个注意点
    // 1.由于CALayer在设计之初就考虑它的动画操作功能，CALayer很多属性在修改时都能形成动画效果，这种属性称为“隐式动画属性”
    // 2.但是对于UIView的根图层而言属性的修改并不形成动画效果，因为很多情况下根图层更多的充当容器的做用，如果它的属性变动形成动画效果会直接影响子图层。
    // 3.UIView的根图层创建工作完全由iOS负责完成，无法重新创建，但是可以往根图层中添加子图层或移除子图层。
    
    // 关于CALayer的属性需要的几个注意点
    // 1.隐式属性动画的本质是这些属性的变动默认隐含了CABasicAnimation动画实现，详情大家可以参照Xcode帮助文档中“Animatable Properties”一节。
    
    // 2.在CALayer中很少使用frame属性，因为frame本身不支持动画效果，通常使用bounds和position代替。
    
    // 3.CALayer中透明度使用opacity表示而不是alpha；中心点使用position表示而不是center。
    
    // 4.anchorPoint属性是图层的锚点，范围在（0~1,0~1）表示在x、y轴的比例，这个点永远可以同position（中心点）重合，当图层中心点固定后，调整anchorPoint即可达到调整图层显示位置的作用（因为它永远和position重合）
    // position anchorPoint点在父控件的位置
    // frame.origin.x = position.x - anchorPoint.x * bounds.size.width；
    // frame.origin.y = position.y - anchorPoint.y * bounds.size.height；
    // 当改变anchorPoint时，position不变，origin改变
    
    _aView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    _aView.backgroundColor = [UIColor whiteColor];
    
    // 给CALayer添加图片需要添加前缀（__bridge id）
    UIImage *image = [UIImage imageNamed:@"nimei"];
    _aView.layer.contents = (__bridge id)image.CGImage;
    
    // contentsGravity
    //    _aView.contentMode = UIViewContentModeScaleAspectFit;
    // 与上面的方法等效
//    _aView.layer.contentsGravity = kCAGravityResizeAspect;
    /*
    kCAGravityCenter           中部
    kCAGravityTop              中下部
    kCAGravityBottom           中上部
    kCAGravityLeft             中左部
    kCAGravityRight            中右部
    kCAGravityTopLeft          左下部
    kCAGravityTopRight         右下部
    kCAGravityBottomLeft       左上部
    kCAGravityBottomRight      右上部
    kCAGravityResize           按当前视图比例拉伸图片填充
    kCAGravityResizeAspect     按原图片比例显示所有图片
    kCAGravityResizeAspectFill 按当前视图比例拉伸图片填充
    */
    
    _aView.layer.contentsGravity = kCAGravityResize;
    // contentsScale
    //contentsScale定义了CGImage的像素尺寸和视图大小比例，默认情况下为1.0
    //如何理解这句话，我是这么理解的，屏幕有非retina屏幕(像素和尺寸是1：1)
    //还有retina屏幕，像素和尺寸比是2：1
    //现在还出现了@3x图片，像素和尺寸比理论上是3：1，但实际上在显示的时候，苹果进行了调整（具体可以看ios9的新特性）
    //那么，像我下面这么写，就是说像素点按照屏幕来调整，如果是非retaina，那么就是1：1，如果是retina，就是2：1
    //图层并不知道当前设备的分辨率信息。图层只是简单的存储一个指向位图的指针，并用给定的有效像素以最佳的方式显示。如果你赋值一个图片给图层的contents属性，你必须给图层的contentsScale属性设置一个正确的值以告诉Core Animation关于图片的分辨率。默认的属性值为1.0，对于在标准分辨率的屏幕上显示图片是正确的。如果你的图片要在Retina屏幕上显示，该值需要设定为2.0。使用[[UIScreen mainScreen] scale]可获取正确的缩放率。
    _aView.layer.contentsScale = [UIScreen mainScreen].scale;
    
    // masksTobounds
    // 决定是否显示超出边界的内容
//    _aView.clipsToBounds = YES;
    // 与上面的方法等效
    _aView.layer.masksToBounds = YES;
    
    /*
     CALayer的contentsRect属性允许我们在图层边框里显示寄宿图的一个子域。这涉及到图片是如何显示和拉伸的，所以要比contentsGravity灵活多了
     
     和bounds，frame不同，contentsRect不是按点来计算的，它使用了单位坐标，单位坐标指定在0到1之间，是一个相对值（像素和点就是绝对值）。所以它们是相对与寄宿图的尺寸的。iOS使用了以下的坐标系统：
     
     点 —— 在iOS和Mac OS中最常见的坐标体系。点就像是虚拟的像素，也被称作逻辑像素。在标准设备上，一个点就是一个像素，但是在Retina设备上，一个点等于2*2个像素。iOS用点作为屏幕的坐标测算体系就是为了在Retina设备和普通设备上能有一致的视觉效果。
     像素 —— 物理像素坐标并不会用来屏幕布局，但是仍然与图片有相对关系。UIImage是一个屏幕分辨率解决方案，所以指定点来度量大小。但是一些底层的图片表示如CGImage就会使用像素，所以你要清楚在Retina设备和普通设备上，它们表现出来了不同的大小。
     单位 —— 对于与图片大小或是图层边界相关的显示，单位坐标是一个方便的度量方式， 当大小改变的时候，也不需要再次调整。单位坐标在OpenGL这种纹理坐标系统中用得很多，Core Animation中也用到了单位坐标。
     默认的contentsRect是{0, 0, 1, 1}，这意味着整个寄宿图默认都是可见的，如果我们指定一个小一点的矩形
     */
    // 显示比例
    _aView.layer.contentsRect = CGRectMake(0.5, 0, 0.5, 0.5);
    
    /*
     当这个图片被拉伸后，contentsCenter属性定义的区域会被全面拉伸（也就是从四个方向进行放大或者缩小），而被这个方框分割后的其他方格会按照上图所表示的进行横向或者纵向的拉伸，或者某些方框根本不拉伸！这就是contentsCenter属性的意义。
     contentsCenter属性和contentsRect属性一样，同样是以比例作单位。两个属性可以叠加，如果contentsRect属性被设置，contentsCenter属性就会操作contentsRect属性所定义的范围。
     */
     // 左下角四分之一拉伸
    _aView.layer.contentsCenter = CGRectMake(0, 0.5, 0.5, 0.5);
    
    [self.view addSubview:_aView];
    
//    CALayer *layer = [[CALayer alloc] init];
//    layer.backgroundColor = [UIColor blueColor].CGColor;
//    layer.shadowOffset = CGSizeMake(2, 2);
//    layer.shadowOpacity = 0.9;
//    UIImage *image = [UIImage imageNamed:@"IMG_0053.jpg"];
//    layer.contents = (__bridge id)image.CGImage;
//    
//    layer.anchorPoint = CGPointZero;
//    layer.position = CGPointMake(100, 100);
//    layer.bounds = CGRectMake(0, 0, 50, 50);
////    layer.contentsGravity = @"kCAGravityResize";
//    
//    [_aView.layer addSublayer:layer];

}

@end
