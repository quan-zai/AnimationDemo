//
//  LayerLabel.m
//  AnimationDemo
//
//  Created by 权仔 on 16/7/27.
//  Copyright © 2016年 XZQ. All rights reserved.
//

#import "LayerLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation LayerLabel

+ (Class)layerClass
{
    // this makes our label create a CATextLayer // instead of a regulaer CALayer for its backing layer
    return [CATextLayer class];
}

- (CATextLayer *)textLayer
{
    return (CATextLayer *)self.layer;
}

- (void)setUp
{
    // set defaults from UILabel settings
    self.text = self.text;
    self.textColor = self.textColor;
    self.font = self.font;
    
    // we should really derive these from  the UILabel setting too
    // but that's comp;icated, so for now we'll just hard-code them
    
    [self textLayer].alignmentMode = kCAAlignmentJustified;
    
    [self textLayer].wrapped = YES;
    [self.layer display];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    // called when creating label programmatically
    if (self = [super initWithFrame: frame]) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    // called when creating label using Interface Builder
    [self setUp];
}

- (void)setText:(NSString *)text
{
    super.text = text;
    // set layer text
    [self textLayer].string = text;
}

-(void)setTextColor:(UIColor *)textColor
{
    super.textColor = textColor;
    // set layer color
    [self textLayer].foregroundColor = textColor.CGColor;
}

- (void)setFont:(UIFont *)font
{
    super.font = font;
    // set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    [self textLayer].font = fontRef;
    [self textLayer].fontSize = font.pointSize;
}

@end
