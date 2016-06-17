//
//  TransformVC.m
//  AnimationDemo
//
//  Created by 权仔 on 16/6/17.
//  Copyright © 2016年 XZQ. All rights reserved.
//

#import "TransformVC.h"

@interface TransformVC ()

@property (nonatomic, strong) CALayer *layer;

@property (nonatomic, strong) CALayer *otherLayer;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) NSArray *face;

@end

@implementation TransformVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIImage *image = [UIImage imageNamed:@"nimei"];
//    
//    _layer = [[CALayer alloc] init];
//    _layer.frame = CGRectMake(50, 100, 100, 100);
//    _layer.contents = (__bridge id)image.CGImage;
//    _layer.contentsGravity = kCAGravityResize;
//    
//    [self.view.layer addSublayer:_layer];
//    
//    _otherLayer = [[CALayer alloc] init];
//    _otherLayer.frame = CGRectMake(200, 100, 100, 100);
//    _otherLayer.contents = (__bridge id)image.CGImage;
//    _otherLayer.contentsGravity = kCAGravityResize;
//    
//    [self.view.layer addSublayer:_otherLayer];
    
//    [self affineTransformation];
    
//    [self Translate3D];
    
    [self solidBody];
}

- (void)affineTransformation
{
    /**********************************！
     *  以下的变换实质上都是对矩阵的变换操作
     **********************************
     */
    
    /**
     * 仿射变换
     */

    /**
     *  当对图层应用变换矩阵，图层矩形内的每一个点都被相应地做变换，从而形成一个新的四边形的形状。CGAffineTransform中的“仿射”的意思是无论变换矩阵用什么值，图层中平行的两条线在变换之后任然保持平行，CGAffineTransform可以做出任意符合上述标注的变换(也就是除去z轴的视觉效果)
     */
    
    /**
     *  CGAffineTransform
     CG的前缀告诉我们，CGAffineTransform类型属于Core Graphics框架，Core Graphics实际上是一个严格意义上的2D绘图API，并且CGAffineTransform仅仅对2D变换有效。
     
     UIView可以通过设置transform属性做变换，但实际上它只是封装了内部图层的变换。
     
     CALayer同样也有一个transform属性，但它的类型是CATransform3D，而不是CGAffineTransform，本章后续将会详细解释。CALayer对应于UIView的transform属性叫做affineTransform，清单5.1的例子就是使用affineTransform对图层做了45度顺时针旋转。
     */
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
    _layer.affineTransform = transform;
    
    /**
     *  混合变换（多个仿射变换的组合）
     Core Graphics提供了一系列的函数可以在一个变换的基础上做更深层次的变换，如果做一个既要缩放又要旋转的变换，这就会非常有用了。例如下面几个函数：
     
     CGAffineTransformRotate(CGAffineTransform t, CGFloat angle)
     CGAffineTransformScale(CGAffineTransform t, CGFloat sx, CGFloat sy)
     CGAffineTransformTranslate(CGAffineTransform t, CGFloat tx, CGFloat ty)
     当操纵一个变换的时候，初始生成一个什么都不做的变换很重要--也就是创建一个CGAffineTransform类型的空值，矩阵论中称作单位矩阵，Core Graphics同样也提供了一个方便的常量：
     
     CGAffineTransformIdentity
     最后，如果需要混合两个已经存在的变换矩阵，就可以使用如下方法，在两个变换的基础上创建一个新的变换：
     
     CGAffineTransformConcat(CGAffineTransform t1, CGAffineTransform t2);
     */
    
    // create a new transform 创建一个变换（单位矩阵）
    CGAffineTransform contactTransform = CGAffineTransformIdentity;
    
    // scale by 50%
    contactTransform = CGAffineTransformScale(contactTransform, 0.5, 0.5);
    
    // rotate by 30 degress 旋转30度
    contactTransform = CGAffineTransformRotate(contactTransform, M_PI / 180.0 * 30.0);
    
    // translate by 200 point  移动200个像素
    contactTransform = CGAffineTransformTranslate(contactTransform, 200, 0);
    
    _layer.affineTransform = contactTransform;
    
    /**
     *  剪切变换
     Core Graphics为你提供了计算变换矩阵的一些方法，所以很少需要直接设置CGAffineTransform的值。除非需要创建一个斜切的变换，Core Graphics并没有提供直接的函数。
     
     斜切变换是放射变换的第四种类型，较于平移，旋转和缩放并不常用（这也是Core Graphics没有提供相应函数的原因），但有些时候也会很有用。
     */
}

- (void)Translate3D
{
    /**
     *  3D变换
     和CGAffineTransform矩阵类似，Core Animation提供了一系列的方法用来创建和组合CATransform3D类型的矩阵，和Core Graphics的函数类似，但是3D的平移和旋转多处了一个z参数，并且旋转函数除了angle之外多出了x,y,z三个参数，分别决定了每个坐标轴方向上的旋转：
     
     CATransform3DMakeRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z)
     CATransform3DMakeScale(CGFloat sx, CGFloat sy, CGFloat sz)
     CATransform3DMakeTranslation(Gloat tx, CGFloat ty, CGFloat tz)
     *
     */
    CATransform3D transform = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
//    _layer.transform = transform;
    
    
    /**
     *  透视投影
     在真实世界中，当物体远离我们的时候，由于视角的原因看起来会变小，理论上说远离我们的视图的边要比靠近视角的边跟短，但实际上并没有发生，而我们当前的视角是等距离的，也就是在3D变换中任然保持平行，和之前提到的仿射变换类似。
     
     在等距投影中，远处的物体和近处的物体保持同样的缩放比例，这种投影也有它自己的用处（例如建筑绘图，颠倒，和伪3D视频），但当前我们并不需要。
     
     为了做一些修正，我们需要引入投影变换（又称作z变换）来对除了旋转之外的变换矩阵做一些修改，Core Animation并没有给我们提供设置透视变换的函数，因此我们需要手动修改矩阵值，幸运的是，很简单：
     
     CATransform3D的透视效果通过一个矩阵中一个很简单的元素来控制：m34。m34（图5.9）用于按比例缩放X和Y的值来计算到底要离视角多远。
     m34的默认值是0，我们可以通过设置m34为-1.0 / d来应用透视效果，d代表了想象中视角相机和屏幕之间的距离，以像素为单位，那应该如何计算这个距离呢？实际上并不需要，大概估算一个就好了。
     因为视角相机实际上并不存在，所以可以根据屏幕上的显示效果自由决定它的放置的位置。通常500-1000就已经很好了，但对于特定的图层有时候更小或者更大的值会看起来更舒服，减少距离的值会增强透视效果，所以一个非常微小的值会让它看起来更加失真，然而一个非常大的值会让它基本失去透视效果.
     */
//    CATransform3D transform3D = CATransform3DIdentity;
//    transform3D.m34 = -1.0 / 500.0;
//    transform3D = CATransform3DRotate(transform3D, M_PI_4, 0, 1, 0);
//    _layer.transform = transform3D;
    
    
    /**
     *  灭点
     Core Animation定义了这个点位于变换图层的anchorPoint（通常位于图层中心，但也有例外，见第三章）。这就是说，当图层发生变换时，这个点永远位于图层变换之前anchorPoint的位置。（也就是说对图层的变换会保持锚点anchorPoint位置不变）
     
     当改变一个图层的position，你也改变了它的灭点，做3D变换的时候要时刻记住这一点，当你视图通过调整m34来让它更加有3D效果，应该首先把它放置于屏幕中央，然后通过平移来把它移动到指定位置（而不是直接改变它的position），这样所有的3D图层都共享一个灭点。
     */
    /**
     *  sublayerTransform属性（使用同样的距离观察视角）
     */
    
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m34 = -1.0 / 500.0;
    
    self.view.layer.sublayerTransform = transform3D;
    
    transform3D = CATransform3DRotate(transform3D, M_PI_4, 0, 1, 0);
    
    _layer.transform = transform3D;
    
    CATransform3D otherTransform3D = CATransform3DIdentity;
    otherTransform3D = CATransform3DRotate(otherTransform3D, -M_PI_4, 0, 1, 0);
    _otherLayer.transform = otherTransform3D;
    
    /**
     *  背面
     我们既然可以在3D场景下旋转图层，那么也可以从背面去观察它。如果我们在清单5.4中把角度修改为M_PI（180度）而不是当前的M_PI_4（45度），那么将会把图层完全旋转一个半圈，于是完全背对了相机视角。
     
     那么从背部看图层是什么样的呢
     
     如你所见，图层是双面绘制的，反面显示的是正面的一个镜像图片。
     
     但这并不是一个很好的特性，因为如果图层包含文本或者其他控件，那用户看到这些内容的镜像图片当然会感到困惑。另外也有可能造成资源的浪费：想象用这些图层形成一个不透明的固态立方体，既然永远都看不见这些图层的背面，那为什么浪费GPU来绘制它们呢？
     
     CALayer有一个叫做doubleSided的属性来控制图层的背面是否要被绘制。这是一个BOOL类型，默认为YES，如果设置为NO，那么当图层正面从相机视角消失的时候，它将不会被绘制。
     */
    
    /**
     *  扁平化图层 （总结来说图层的显示是父图层把变换后的子图层扁平化以后与父图层的变换组合起来所形成的，也就是说由于扁平化的缘故（伪3D），导致组合变换的视角与真正的3D变换的视角不同）
     但其实这并不是我们所看到的，相反，我们看到的结果如图5.18所示。发什么了什么呢？内部的图层仍然向左侧旋转，并且发生了扭曲，但按道理说它应该保持正面朝上，并且显示正常的方块。
     
     这是由于尽管Core Animation图层存在于3D空间之内，但它们并不都存在同一个3D空间。每个图层的3D场景其实是扁平化的，当你从正面观察一个图层，看到的实际上由子图层创建的想象出来的3D场景，但当你倾斜这个图层，你会发现实际上这个3D场景仅仅是被绘制在图层的表面。
     
     类似的，当你在玩一个3D游戏，实际上仅仅是把屏幕做了一次倾斜，或许在游戏中可以看见有一面墙在你面前，但是倾斜屏幕并不能够看见墙里面的东西。所有场景里面绘制的东西并不会随着你观察它的角度改变而发生变化；图层也是同样的道理。
     
     这使得用Core Animation创建非常复杂的3D场景变得十分困难。你不能够使用图层树去创建一个3D结构的层级关系--在相同场景下的任何3D表面必须和同样的图层保持一致，这是因为每个的父视图都把它的子视图扁平化了。
     
     至少当你用正常的CALayer的时候是这样，CALayer有一个叫做CATransformLayer的子类来解决这个问题。具体在第六章“特殊的图层”中将会具体讨论。
     */
}

- (void)solidBody
{
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    [self.view addSubview:_containerView];
    
    NSArray *colorArray = @[];
    
    for (int i = 0; i < 6; i++) {
        UIView *view = [[UIView alloc] initWithFrame:_containerView.bounds];
        view.layer.backgroundColor = [UIColor blueColor].CGColor;
        
        [_containerView addSubview:view];
    }
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
    self.containerView.layer.sublayerTransform = perspective;
    //add cube face 1
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
    [self addFace:0 withTransform:transform];
    //add cube face 2
    transform = CATransform3DMakeTranslation(100, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    //add cube face 3
    transform = CATransform3DMakeTranslation(0, -100, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    //add cube face 4
    transform = CATransform3DMakeTranslation(0, 100, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    //add cube face 5
    transform = CATransform3DMakeTranslation(-100, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    //add cube face 6
    transform = CATransform3DMakeTranslation(0, 0, -100);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:transform];
}

- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform
{
    // get the face view and it to the container
    UIView *face = _face[index];
    
    [_containerView addSubview:face];
    
    // center the face view within the container
    CGSize containerSize = _containerView.bounds.size;
    face.center = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
    
    // apply the transform
    face.layer.transform = transform;
}

@end
