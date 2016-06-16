//
//  VisualEffectsVC.m
//  AnimationDemo
//
//  Created by 权仔 on 16/6/16.
//  Copyright © 2016年 XZQ. All rights reserved.
//

#import "VisualEffectsVC.h"

@interface VisualEffectsVC ()

@property (nonatomic, strong) UIView *layerView1;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation VisualEffectsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self layerVisualEffects];
    
//    [self StretchFiltration];
    
    [self groupOpacity];
}

- (void)layerVisualEffects
{
    /**
     *  视觉效果
     */
    
    /**
     *  圆角
     conrnerRadius  只能控制图层背景颜色的曲率
     masksToBounds  图层里面的所有东西都会被截取
     */
    
    /**
     *  图层边框
     borderWidth
     borderColor
     */
    
    /**
     *  图层阴影
     shadowOpacity  阴影透明度
     shadowColor    阴影颜色
     shadowOffset   阴影偏移量
     shadowRadius   阴影模糊度，当值越来越大的时候，边界线看上去就会越来越模糊的自然。
     */
    
    /**
     *  阴影裁剪
     masksToBounds 与shadow合用时会裁剪掉外部阴影。解决方法是需要设置一个外层layer来实现阴影，对内层layer进行裁剪
     */
    
    /**
     *  shadowPath属性
     ****************************************************
     相较于shadow有性能优势：如果对这个添加阴影的View（如果它是一个UITableViewCell的一部分）做一些动画，您可能会注意到在动画不是很流畅，有卡顿。这是因为计算阴影需要Core Animation做一个离屏渲染，以View准确的形状确定清楚如何呈现其阴影。（需要占用内存，需要使用CPU渲染）
     
     tip：离屏渲染：
     GPU渲染机制：
     
     CPU 计算好显示内容提交到 GPU，GPU 渲染完成后将渲染结果放入帧缓冲区，随后视频控制器会按照 VSync 信号逐行读取帧缓冲区的数据，经过可能的数模转换传递给显示器显示。
     
     GPU屏幕渲染有以下两种方式：
     
     On-Screen Rendering
     意为当前屏幕渲染，指的是GPU的渲染操作是在当前用于显示的屏幕缓冲区中进行。
     
     Off-Screen Rendering
     意为离屏渲染，指的是GPU在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作。
     
     特殊的离屏渲染：
     如果将不在GPU的当前屏幕缓冲区中进行的渲染都称为离屏渲染，那么就还有另一种特殊的“离屏渲染”方式： CPU渲染。
     如果我们重写了drawRect方法，并且使用任何Core Graphics的技术进行了绘制操作，就涉及到了CPU渲染。整个渲染过程由CPU在App内 同步地
     完成，渲染得到的bitmap最后再交由GPU用于显示。
     备注：CoreGraphic通常是线程安全的，所以可以进行异步绘制，显示的时候再放回主线程，一个简单的异步绘制过程大致如下
     - (void)display {
     dispatch_async(backgroundQueue, ^{
     CGContextRef ctx = CGBitmapContextCreate(...);
     // draw in context...
     CGImageRef img = CGBitmapContextCreateImage(ctx);
     CFRelease(ctx);
     dispatch_async(mainQueue, ^{
     layer.contents = img;
     });
     });
     }
     离屏渲染的触发方式
     
     设置了以下属性时，都会触发离屏绘制：
     
     shouldRasterize（光栅化）
     masks（遮罩）
     shadows（阴影）
     edge antialiasing（抗锯齿）
     group opacity（不透明）
     复杂形状设置圆角等
     渐变
     其中shouldRasterize（光栅化）是比较特别的一种：
     光栅化概念：将图转化为一个个栅格组成的图象。
     光栅化特点：每个元素对应帧缓冲区中的一像素。
     
     shouldRasterize = YES在其他属性触发离屏渲染的同时，会将光栅化后的内容缓存起来，如果对应的layer及其sublayers没有发生改变，在下一帧的时候可以直接复用。shouldRasterize = YES，这将隐式的创建一个位图，各种阴影遮罩等效果也会保存到位图中并缓存起来，从而减少渲染的频度（不是矢量图）。
     
     相当于光栅化是把GPU的操作转到CPU上了，生成位图缓存，直接读取复用。
     
     当你使用光栅化时，你可以开启“Color Hits Green and Misses Red”来检查该场景下光栅化操作是否是一个好的选择。绿色表示缓存被复用，红色表示缓存在被重复创建。
     
     如果光栅化的层变红得太频繁那么光栅化对优化可能没有多少用处。位图缓存从内存中删除又重新创建得太过频繁，红色表明缓存重建得太迟。可以针对性的选择某个较小而较深的层结构进行光栅化，来尝试减少渲染时间。
     
     注意：
     对于经常变动的内容,这个时候不要开启,否则会造成性能的浪费
     
     例如我们日程经常打交道的TableViewCell,因为TableViewCell的重绘是很频繁的（因为Cell的复用）,如果Cell的内容不断变化,则Cell需要不断重绘,如果此时设置了cell.layer可光栅化。则会造成大量的离屏渲染,降低图形性能。
     为什么会使用离屏渲染
     
     当使用圆角，阴影，遮罩的时候，图层属性的混合体被指定为在未预合成之前不能直接在屏幕中绘制，所以就需要屏幕外渲染被唤起。
     
     屏幕外渲染并不意味着软件绘制，但是它意味着图层必须在被显示之前在一个屏幕外上下文中被渲染（不论CPU还是GPU）。
     
     所以当使用离屏渲染的时候会很容易造成性能消耗，因为在OPENGL里离屏渲染会单独在内存中创建一个屏幕外缓冲区并进行渲染，而屏幕外缓冲区跟当前屏幕缓冲区上下文切换是很耗性能的。
     
     Instruments监测离屏渲染
     
     Instruments的Core Animation工具中有几个和离屏渲染相关的检查选项：
     
     Color Offscreen-Rendered Yellow
     开启后会把那些需要离屏渲染的图层高亮成黄色，这就意味着黄色图层可能存在性能问题。
     
     Color Hits Green and Misses Red
     如果shouldRasterize被设置成YES，对应的渲染结果会被缓存，如果图层是绿色，就表示这些缓存被复用；如果是红色就表示缓存会被重复创建，这就表示该处存在性能问题了。
     
     iOS版本上的优化
     
     iOS 9.0 之前UIimageView跟UIButton设置圆角都会触发离屏渲染
     
     iOS 9.0 之后UIButton设置圆角会触发离屏渲染，而UIImageView里png图片设置圆角不会触发离屏渲染了，如果设置其他阴影效果之类的还是会触发离屏渲染的。
     
     这可能是苹果也意识到离屏渲染会产生性能问题，所以能不产生离屏渲染的地方苹果也就不用离屏渲染了。
     ****************************************************
     我们已经知道图层阴影并不总是方的，而是从图层内容的形状继承而来。这看上去不错，但是实时计算阴影也是一个非常消耗资源的，尤其是图层有多个子图层，每个图层还有一个有透明效果的寄宿图的时候。
     
     如果你事先知道你的阴影形状会是什么样子的，你可以通过指定一个shadowPath来提高性能。shadowPath是一个CGPathRef类型（一个指向CGPath的指针）。CGPath是一个Core Graphics对象，用来指定任意的一个矢量图形。我们可以通过这个属性单独于图层形状之外指定阴影的形状。
     如果是一个矩形或者是圆，用CGPath会相当简单明了。但是如果是更加复杂一点的图形，UIBezierPath类会更合适，它是一个由UIKit提供的在CGPath基础上的Objective-C包装类。
    */
    
//    UIImage *image = [UIImage imageNamed:@"nimei"];
//    
//    _layerView1 = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
//    _layerView1.layer.contents = (__bridge id)image.CGImage;
//    [self.view addSubview:_layerView1];
//    
//    // enable layer shadows
//    _layerView1.layer.shadowOpacity = 0.5f;
//  
//    // create a square shadow
//    CGMutablePathRef squarePath = CGPathCreateMutable();
//    CGPathAddRect(squarePath, NULL, _layerView1.bounds);
//    _layerView1.layer.shadowPath = squarePath;
//    CGPathRelease(squarePath);
    
    /**
     *  图层蒙版
     通过masksToBounds属性，我们可以沿边界裁剪图形；通过cornerRadius属性，我们还可以设定一个圆角。但是有时候你希望展现的内容不是在一个矩形或圆角矩形。比如，你想展示一个有星形框架的图片，又或者想让一些古卷文字慢慢渐变成背景色，而不是一个突兀的边界。
     
     使用一个32位有alpha通道的png图片通常是创建一个无矩形视图最方便的方法，你可以给它指定一个透明蒙板来实现。但是这个方法不能让你以编码的方式动态地生成蒙板，也不能让子图层或子视图裁剪成同样的形状。
     
     CALayer有一个属性叫做mask可以解决这个问题。这个属性本身就是个CALayer类型，有和其他图层一样的绘制和布局属性。它类似于一个子图层，相对于父图层（即拥有该属性的图层）布局，但是它却不是一个普通的子图层。不同于那些绘制在父图层中的子图层，mask图层定义了父图层的部分可见区域。
     
     mask图层的Color属性是无关紧要的，真正重要的是图层的轮廓。mask属性就像是一个饼干切割机，mask图层实心的部分会被保留下来，其他的则会被抛弃。（如图4.12）
     
     如果mask图层比父图层要小，只有在mask图层里面的内容才是它关心的，除此以外的一切都会被隐藏起来。
     */
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nimei"]];
    _imageView.frame = CGRectMake(100, 100, 200, 200);
    
    [self.view addSubview:_imageView];
    
    CALayer *maskLayer = [[CALayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, 100, 100);
    UIImage *maskImage = [UIImage imageNamed:@"hour"];
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    maskLayer.contentsGravity = kCAGravityResizeAspect;
    
    _imageView.layer.mask = maskLayer;

}

- (void)StretchFiltration
{
    /**
     拉伸过滤
     最后我们再来谈谈minificationFilter和magnificationFilter属性。总得来讲，当我们视图显示一个图片的时候，都应该正确地显示这个图片（意即：以正确的比例和正确的1：1像素显示在屏幕上）。原因如下：
     
     能够显示最好的画质，像素既没有被压缩也没有被拉伸。
     能更好的使用内存，因为这就是所有你要存储的东西。
     最好的性能表现，CPU不需要为此额外的计算。
     不过有时候，显示一个非真实大小的图片确实是我们需要的效果。比如说一个头像或是图片的缩略图，再比如说一个可以被拖拽和伸缩的大图。这些情况下，为同一图片的不同大小存储不同的图片显得又不切实际。
     
     当图片需要显示不同的大小的时候，有一种叫做拉伸过滤的算法就起到作用了。它作用于原图的像素上并根据需要生成新的像素显示在屏幕上。
     
     事实上，重绘图片大小也没有一个统一的通用算法。这取决于需要拉伸的内容，放大或是缩小的需求等这些因素。CALayer为此提供了三种拉伸过滤方法，他们是：
     
     kCAFilterLinear
     kCAFilterNearest
     kCAFilterTrilinear
     minification（缩小图片）和magnification（放大图片）默认的过滤器都是kCAFilterLinear，这个过滤器采用双线性滤波算法，它在大多数情况下都表现良好。双线性滤波算法通过对多个像素取样最终生成新的值，得到一个平滑的表现不错的拉伸。但是当放大倍数比较大的时候图片就模糊不清了。
     
     kCAFilterTrilinear和kCAFilterLinear非常相似，大部分情况下二者都看不出来有什么差别。但是，较双线性滤波算法而言，三线性滤波算法存储了多个大小情况下的图片（也叫多重贴图），并三维取样，同时结合大图和小图的存储进而�得到最后的结果。
     
     这个方法的好处在于算法能够从一系列已经接近于最终大小的图片中得到想要的结果，也就是说不要对很多像素同步取样。这不仅提高了性能，也避免了小概率因舍入错误引起的取样失灵的问题
     *
     */
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_0053.jpg"]];
    _imageView.frame = [UIScreen mainScreen].bounds;
    
    [self.view addSubview:_imageView];
    
    _imageView.layer.contentsRect = CGRectMake(0.5, 0.5, 0.1, 0.1);
    _imageView.layer.contentsGravity = kCAGravityResizeAspect;
    _imageView.layer.magnificationFilter = kCAFilterNearest;
}

- (void)groupOpacity
{
    /**
     *  组透明
     这是由透明度的混合叠加造成的，当你显示一个50%透明度的图层时，图层的每个像素都会一般显示自己的颜色，另一半显示图层下面的颜色。这是正常的透明度的表现。但是如果图层包含一个同样显示50%透明的子图层时，你所看到的视图，50%来自子视图，25%来了图层本身的颜色，另外的25%则来自背景色。
     
     在我们的示例中，按钮和表情都是白色背景。虽然他们都是50%的可见度，但是合起来的可见度是75%，所以标签所在的区域看上去就没有周围的部分那么透明。所以看上去子视图就高亮了，使得这个显示效果都糟透了。
     
     理想状况下，当你设置了一个图层的透明度，你希望它包含的整个图层树像一个整体一样的透明效果。你可以通过设置Info.plist文件中的UIViewGroupOpacity为YES来达到这个效果，但是这个设置会影响到这个应用，整个app可能会受到不良影响。如果UIViewGroupOpacity并未设置，iOS 6和以前的版本会默认为NO（也许以后的版本会有一些改变）。
     
     另一个方法就是，你可以设置CALayer的一个叫做shouldRasterize属性（见清单4.7）来实现组透明的效果，如果它被设置为YES，在应用透明度之前，图层及其子图层都会被整合成一个整体的图片，这样就没有透明度混合的问题了（如图4.21）。
     
     为了启用shouldRasterize属性，我们设置了图层的rasterizationScale属性。默认情况下，所有图层拉伸都是1.0， 所以如果你使用了shouldRasterize属性，你就要确保你设置了rasterizationScale属性去匹配屏幕，以防止出现Retina屏幕像素化的问题。
     
     当shouldRasterize和UIViewGroupOpacity一起的时候，性能问题就出现了（我们在第12章『速度』和第15章『图层性能』将做出介绍），但是性能碰撞都本地化了（译者注：这句话需要再翻译）。
     */
    self.view.backgroundColor = [UIColor lightGrayColor];
    //create opaque button
    UIButton *button1 = [self customButton];
    button1.center = CGPointMake(50, 150);
    [self.view addSubview:button1];
    
    //create translucent button
    UIButton *button2 = [self customButton];
    
    button2.center = CGPointMake(250, 150);
    button2.alpha = 0.5;
    [self.view addSubview:button2];
    
    //enable rasterization for the translucent button
    button2.layer.shouldRasterize = YES;
    button2.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (UIButton *)customButton
{
    //create button
    CGRect frame = CGRectMake(0, 0, 150, 50);
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 10;
    
    //add label
    frame = CGRectMake(20, 10, 110, 30);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = @"Hello World";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    [button addSubview:label];
    return button;
}

@end
