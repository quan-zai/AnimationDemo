//
//  specialLayerVC.m
//  AnimationDemo
//
//  Created by 权仔 on 16/6/20.
//  Copyright © 2016年 XZQ. All rights reserved.
//

#import "SpecialLayerVC.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface SpecialLayerVC ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIView *labelView;

@end

@implementation SpecialLayerVC

- (void)viewDidLoad {
    
    _labelView = [[UIView alloc] initWithFrame:CGRectMake(50, 200, 300, 300)];
    
    [self.view addSubview:_labelView];
    
    _containerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.view addSubview:_containerView];
    
    [super viewDidLoad];
    [self caShapeLayer];
}

- (void)caShapeLayer
{
    /**
     *  CAShapeLayer是一个通过矢量图形而不是bitmap来绘制的图层子类。你指定诸如颜色和线宽等属性，用CGPath来定义想要绘制的图形，最后CAShapeLayer就自动渲染出来了。当然，你也可以用Core Graphics直接向原始的CALyer的内容中绘制一个路径，相比直下，使用CAShapeLayer有以下一些优点：
     
     渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形会比用Core Graphics快很多。
     高效使用内存。一个CAShapeLayer不需要像普通CALayer一样创建一个寄宿图形，所以无论有多大，都不会占用太多的内存。
     不会被图层边界剪裁掉。一个CAShapeLayer可以在边界之外绘制。你的图层路径不会像在使用Core Graphics的普通CALayer一样被剪裁掉（如我们在第二章所见）。
     不会出现像素化。当你给CAShapeLayer做3D变换时，它不像一个有寄宿图的普通图层一样变得像素化。
     */
//
//    UIBezierPath *path = [[UIBezierPath alloc] init];
//    [path moveToPoint:CGPointMake(175, 100)];
//    
//    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2 * M_PI clockwise:YES];
//    
//    [path moveToPoint:CGPointMake(150, 125)];
//    [path addLineToPoint:CGPointMake(150, 175)];
//    [path addLineToPoint:CGPointMake(125, 225)];
//    [path moveToPoint:CGPointMake(150, 175)];
//    [path addLineToPoint:CGPointMake(175, 225)];
//    [path moveToPoint:CGPointMake(100, 150)];
//    [path addLineToPoint:CGPointMake(200, 150)];
    
//    CGRect rect = CGRectMake(50, 50, 100, 100);
//    CGSize radii = CGSizeMake(20, 20);
//    
//    // 设置上右，左下，右下圆角
//    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
//    
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
//    
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.strokeColor = [UIColor redColor].CGColor;
//    shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    shapeLayer.lineWidth = 5;
//    
//    // 线条交汇方式
//    shapeLayer.lineJoin= kCALineCapRound;
//    
//    // 线条收尾方式
//    shapeLayer.lineCap = kCALineCapRound;
//    shapeLayer.path = path.CGPath;
//    
//    [self.view.layer addSublayer:shapeLayer];
//    
//    // CATextLayer
//    CATextLayer *textLayer = [CATextLayer layer];
//    textLayer.frame = _labelView.bounds;
//    
//    [_labelView.layer addSublayer:textLayer];
//    
//    // set text attributes
//    textLayer.foregroundColor = [UIColor blackColor].CGColor;
//    textLayer.alignmentMode = kCAAlignmentJustified;
//    textLayer.wrapped = YES;
//    
//    // choose a font
//    UIFont *font = [UIFont systemFontOfSize:15];
//    
//    // set layer font
//    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
//    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
//    textLayer.font = fontRef;
//    textLayer.fontSize = font.pointSize;
//    CGFontRelease(fontRef);
//    
//    // choose some text
//    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing \ elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar \ leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc elementum, libero ut porttitor dictum, diam odio congue lacus, vel \ fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet \ lobortis";
//    
//    // set layer text
//    textLayer.string = text;
//    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
//    // 富文本
//    
//    // create a text layer
//    CATextLayer *textLayer = [CATextLayer layer];
//    textLayer.frame = _labelView.bounds;
//    textLayer.contentsScale = [UIScreen mainScreen].scale;
//    [_labelView.layer addSublayer:textLayer];
//    
//    // set text attributes
//    textLayer.alignmentMode = kCAAlignmentJustified;
//    textLayer.wrapped = YES;
//    
//    // choose a font
//    UIFont *font = [UIFont systemFontOfSize:15];
//    
//    // choose some text
//    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing \ elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar \ leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc \ elementum, libero ut porttitor dictum, diam odio congue lacus, vel \ fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet \ lobortis";
//    
//    // create attributed string
//    NSMutableAttributedString *string = nil;
//    string = [[NSMutableAttributedString alloc] initWithString:text];
//    
//    // convert UIFont to a CTFont
//    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
//    CGFloat fontSize = font.pointSize;
//    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
//    
//    // set text attributes
//    NSDictionary *attribs = @{(__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor, (__bridge id)kCTFontAttributeName: (__bridge id)fontRef};
//    [string setAttributes:attribs range:NSMakeRange(0,[text length])];
//    attribs = @{
//                (__bridge id)kCTForegroundColorAttributeName: (__bridge id)[UIColor redColor].CGColor,
//                (__bridge id)kCTUnderlineStyleAttributeName: @(kCTUnderlineStyleSingle),
//                (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
//                };
//    [string setAttributes:attribs range:NSMakeRange(6, 5)];
//    
//    // release the CTFont we created earlier
//    CFRelease(fontRef);
//    
//    // set layer text
//    textLayer.string = string;
    
    // CATransformLayer

    // set up the perspective transform
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0 / 500.0;
    self.containerView.layer.sublayerTransform = pt;
    
    // set up the transform for cube 1 and add it
    CATransform3D c1t = CATransform3DIdentity;
    c1t = CATransform3DTranslate(c1t, -100, 0, 0);
    CALayer *cube1 = [self cubeWithTransform:c1t];
    [self.containerView.layer addSublayer:cube1];
    
    // set up the transform for cube 2 and add it
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 100, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
    CALayer *cube2 = [self cubeWithTransform:c2t];
    [self.containerView.layer addSublayer:cube2];
    
}

- (CALayer *)faceWithTransform:(CATransform3D)transform
{
    // create cube face layer
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(-50, -50, 100, 100);
    
    // apply a random color
    CGFloat red = (rand() / (double)INT_MAX);
    CGFloat green = (rand() / (double)INT_MAX);
    CGFloat blue = (rand() / (double)INT_MAX);
    face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
    // apply the transform and return
    face.transform = transform;
    
    return face;
}

- (CALayer *)cubeWithTransform:(CATransform3D)transform
{
    // create cube layer
    CATransformLayer *cube = [CATransformLayer layer];
    
    // add cube face 1
    CATransform3D ct = CATransform3DMakeTranslation(0, 0, 50);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    // add cube face 2
    ct = CATransform3DMakeTranslation(50, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    // add cube face 3
    ct = CATransform3DMakeTranslation(0, -50, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    // add cube face 4
    ct = CATransform3DMakeTranslation(0, 50, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    // add cube face 5
    ct = CATransform3DMakeTranslation(-50, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    // add cube face 6
    ct = CATransform3DMakeTranslation(0, 0, -50);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    // center the cube layer within the container
    CGSize containerSize = self.containerView.bounds.size;
    cube.position = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
    
    
    // apply the tansform and return
    cube.transform = transform;
    
    return cube;
}



@end
