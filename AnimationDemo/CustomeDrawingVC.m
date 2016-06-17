//
//  CustomeDrawingVC.m
//  AnimationDemo
//
//  Created by 权仔 on 16/6/15.
//  Copyright © 2016年 XZQ. All rights reserved.
//

#import "CustomeDrawingVC.h"

@interface CustomeDrawingVC ()

@property (nonatomic, strong) CALayer *clock;

@property (nonatomic, strong) CALayer *hourHand;

@property (nonatomic, strong) CALayer *minuteHand;

@property (nonatomic, strong) CALayer *secondHand;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, strong) UIView *blueView;

@property (nonatomic, strong) CALayer *layer;

@end

@implementation CustomeDrawingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // start timer
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
//    [self layerLayout];
    
    [self hitTesting];
}

- (void)layerLayout
{
    // 图层几何学
    /**
     *  布局
     视图的frame，bounds和center属性仅仅是存取方法，当操纵视图的frame，实际上是在改变位于视图下方CALayer的frame，不能够独立于图层之外改变视图的frame。
     
     对于视图或者图层来说，frame并不是一个非常清晰的属性，它其实是一个虚拟属性，是根据bounds，position和transform计算而来，所以当其中任何一个值发生改变，frame都会变化。相反，改变frame的值同样会影响到他们当中的值
     
     记住当对图层做变换的时候，比如旋转或者缩放，frame实际上代表了覆盖在图层旋转之后的整个轴对齐的矩形区域，也就是说frame的宽高可能和bounds的宽高不再一致了
     */
    
    /**
     *  anchorPoint
     */
    CGRect rect = [UIScreen mainScreen].bounds;
    
    _clock = [[CALayer alloc] init];
    _clock.position = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    _clock.bounds = CGRectMake(0, 0, rect.size.width, rect.size.width);
    _clock.contents = (__bridge id)[UIImage imageNamed:@"clock"].CGImage;
    _clock.contentsGravity = kCAGravityResize;
    
    [self.view.layer addSublayer:_clock];
    
    _hourHand = [[CALayer alloc] init];
    _hourHand.position = _clock.position;
    _hourHand.bounds = CGRectMake(0, 0, 81, 160);
    _hourHand.contents = (__bridge id)[UIImage imageNamed:@"hour"].CGImage;
    _hourHand.contentsGravity = kCAGravityResize;
    _hourHand.anchorPoint = CGPointMake(0.5, 0.9);
    
    [self.view.layer addSublayer:_hourHand];
    
    _minuteHand = [[CALayer alloc] init];
    _minuteHand.position = _clock.position;
    _minuteHand.bounds = CGRectMake(0, 0, 72, 181);
    _minuteHand.contents = (__bridge id)[UIImage imageNamed:@"min"].CGImage;
    _minuteHand.contentsGravity = kCAGravityResize;
    _minuteHand.anchorPoint = CGPointMake(0.5, 0.9);
    
    [self.view.layer addSublayer:_minuteHand];
    
    _secondHand = [[CALayer alloc] init];
    _secondHand.position = _clock.position;
    _secondHand.bounds = CGRectMake(0, 0, 61, 181);
    _secondHand.contents = (__bridge id)[UIImage imageNamed:@"sec"].CGImage;
    _secondHand.contentsGravity = kCAGravityResize;
    _secondHand.anchorPoint = CGPointMake(0.5, 0.9);
    
    [self.view.layer addSublayer:_secondHand];
    
    /**
     *  坐标系
     *
     和视图一样，图层在图层树当中也是相对于父图层按层级关系放置，一个图层的position依赖于它父图层的bounds，如果父图层发生了移动，它的所有子图层也会跟着移动。
     
     这样对于放置图层会更加方便，因为你可以通过移动根图层来将它的子图层作为一个整体来移动，但是有时候你需要知道一个图层的绝对位置，或者是相对于另一个图层的位置，而不是它当前父图层的位置。
     
     CALayer给不同坐标系之间的图层转换提供了一些工具类方法：
     
     - (CGPoint)convertPoint:(CGPoint)point fromLayer:(CALayer *)layer;    将point点坐标从fromLayer的坐标系转到现在的图层坐标系中
     - (CGPoint)convertPoint:(CGPoint)point toLayer:(CALayer *)layer;      将point点坐标从当前的坐标系转到toLayer的图层坐标系中
     - (CGRect)convertRect:(CGRect)rect fromLayer:(CALayer *)layer;        将rect坐标从fromLayer的坐标系转到现在的图层坐标系中
     - (CGRect)convertRect:(CGRect)rect toLayer:(CALayer *)layer;          将rect坐标从当前的坐标系转到toLayer的图层坐标系中
     这些方法可以把定义在一个图层坐标系下的点或者矩形转换成另一个图层坐标系下的点或者矩形
     *
     */
    
    /**
     *  和UIView严格的二维坐标系不同，CALayer存在于一个三维空间当中。除了我们已经讨论过的position和anchorPoint属性之外，CALayer还有另外两个属性，zPosition和anchorPointZ，二者都是在Z轴上描述图层位置的浮点类型。
     
     注意这里并没有更深的属性来描述由宽和高做成的bounds了，图层是一个完全扁平的对象，你可以把它们想象成类似于一页二维的坚硬的纸片，用胶水粘成一个空洞，就像三维结构的折纸一样。
     
     zPosition属性在大多数情况下其实并不常用。在第五章，我们将会涉及CATransform3D，你会知道如何在三维空间移动和旋转图层，除了做变换之外，zPosition最实用的功能就是改变图层的显示顺序了。
     
     通常，图层是根据它们子图层的sublayers出现的顺序来类绘制的，这就是所谓的画家的算法--就像一个画家在墙上作画--后被绘制上的图层将会遮盖住之前的图层，但是通过增加图层的zPosition，就可以把图层向相机方向前置，于是它就在所有其他图层的前面了（或者至少是小于它的zPosition值的图层的前面）。
     *
     */
}

- (void)hitTesting
{
    _blueView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    _blueView.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:_blueView];
    
    _layer = [[CALayer alloc] init];
    _layer.position = CGPointMake(50, 50);
    _layer.bounds = CGRectMake(0, 0, 50, 50);
    _layer.backgroundColor = [UIColor greenColor].CGColor;
    
    [_blueView.layer addSublayer:_layer];
    
    /**
     *  Hit Testing
     *
     */
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get touch position relative to main view
    CGPoint point = [[touches anyObject] locationInView:self.view];
    //convert point to the white layer's coordinates
    point = [self.blueView.layer convertPoint:point fromLayer:self.view.layer];
    //get layer using containsPoint:
    if ([self.blueView.layer containsPoint:point]) {
        //convert point to blueLayer’s coordinates
        point = [self.layer convertPoint:point fromLayer:self.blueView.layer];
        if ([self.layer containsPoint:point]) {
            [[[UIAlertView alloc] initWithTitle:@"InsideLayer"
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Inside blue View layer"
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }
}

- (void)tick
{
    // convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    CGFloat hoursAngle = (components.hour / 12.0) * M_PI * 2.0;
    //calculate hour hand angle //calculate minute hand angle
    CGFloat minsAngle = (components.minute / 60.0) * M_PI * 2.0;
    //calculate second hand angle
    CGFloat secsAngle = (components.second / 60.0) * M_PI * 2.0;
    //rotate hands
    _hourHand.transform = CATransform3DMakeRotation(hoursAngle, 0, 0, 1);
    _minuteHand.transform = CATransform3DMakeRotation(minsAngle, 0, 0, 1);
    _secondHand.transform = CATransform3DMakeRotation(secsAngle, 0, 0, 1);
}

@end
