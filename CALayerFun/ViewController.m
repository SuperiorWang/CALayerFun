//
//  ViewController.m
//  CALayerFun
//
//  Created by rongfzh on 13-2-20.
//  Copyright (c) 2013年 rongfzh. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    self.view.layer.backgroundColor = [UIColor orangeColor].CGColor;
    self.view.layer.cornerRadius = 20.0;
    self.view.layer.frame = CGRectInset(self.view.layer.frame,20, 20);
    

    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor purpleColor].CGColor;
    sublayer.shadowOffset = CGSizeMake(0, 3);
    sublayer.shadowRadius = 5.0;
    sublayer.shadowColor = [UIColor blackColor].CGColor;
    sublayer.shadowOpacity = 0.8;
    sublayer.frame = CGRectMake(30, 30, 128, 192);
    sublayer.borderColor = [UIColor blackColor].CGColor;
    sublayer.borderWidth = 2.0;
    sublayer.cornerRadius = 10.0;
    [self.view.layer addSublayer:sublayer];
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = sublayer.bounds;
    imageLayer.cornerRadius = 10.0;
    imageLayer.contents = (id)[UIImage imageNamed:@"snaguosha.png"].CGImage;
    imageLayer.masksToBounds = YES;
    [sublayer addSublayer:imageLayer];

    CALayer *customDrawn = [CALayer layer];
    customDrawn.delegate = self;
    customDrawn.backgroundColor = [UIColor greenColor].CGColor;
    customDrawn.frame = CGRectMake(30, 250, 280, 200);
    customDrawn.shadowOffset = CGSizeMake(0, 3);
    customDrawn.shadowRadius = 5.0;
    customDrawn.shadowColor = [UIColor blackColor].CGColor;
    customDrawn.shadowOpacity = 0.8;
    customDrawn.cornerRadius = 10.0;
    customDrawn.borderColor = [UIColor blackColor].CGColor;
    customDrawn.borderWidth = 2.0;
    customDrawn.masksToBounds = YES;
    [self.view.layer addSublayer:customDrawn];
    [customDrawn setNeedsDisplay];
    [super viewDidLoad];

}


static inline double radians (double degrees) { return degrees * M_PI/180; }

void MyDrawColoredPattern (void *info, CGContextRef context) {
    
    CGColorRef dotColor = [UIColor colorWithHue:0 saturation:0 brightness:0.07 alpha:1.0].CGColor;
    CGColorRef shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1].CGColor;
    
    CGContextSetFillColorWithColor(context, dotColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1, shadowColor);
    
    CGContextAddArc(context, 3, 3, 4, 0, radians(360), 0);
    CGContextFillPath(context);
    
    CGContextAddArc(context, 16, 16, 4, 0, radians(360), 0);
    CGContextFillPath(context);
    
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
    
    CGColorRef bgColor = [UIColor colorWithHue:0 saturation:0 brightness:0.15 alpha:1.0].CGColor;
    CGContextSetFillColorWithColor(context, bgColor);
    CGContextFillRect(context, layer.bounds);
    
    static const CGPatternCallbacks callbacks = { 0, &MyDrawColoredPattern, NULL };
    
    CGContextSaveGState(context);
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    
    CGPatternRef pattern = CGPatternCreate(NULL,
                                           layer.bounds,
                                           CGAffineTransformIdentity,
                                           24,
                                           24,
                                           kCGPatternTilingConstantSpacing,
                                           true,
                                           &callbacks);
    CGFloat alpha = 1.0;
    CGContextSetFillPattern(context, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(context, layer.bounds);
    CGContextRestoreGState(context);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
