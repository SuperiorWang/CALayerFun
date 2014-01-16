//
//  AnimationViewController.m
//  CALayerFun
//
//  Created by rongfzh on 13-2-21.
//  Copyright (c) 2013年 rongfzh. All rights reserved.
//

#import "AnimationViewController.h"


@interface AnimationViewController ()

@end

@implementation AnimationViewController

#define DEGREES_TO_RADIANS(x) (3.14159265358979323846 * x / 180.0)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"snaguosha.png"]];
    self.imageView.frame = CGRectMake(10, 10, 128, 192);
    [self.view addSubview:self.imageView];
    [self animationInit];
}


- (void)animationInit
{
    self.view.backgroundColor = [UIColor blackColor];
    
    CGFloat radius = 30.0f;
    CGFloat diameter = radius * 2;
    CGPoint arcCenter = CGPointMake(radius, radius);
    // Create a UIBezierPath for Pacman's open state
    pacmanOpenPath = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                    radius:radius
                                                startAngle:DEGREES_TO_RADIANS(35)
                                                  endAngle:DEGREES_TO_RADIANS(315)
                                                 clockwise:YES];
    
    [pacmanOpenPath addLineToPoint:arcCenter];
    [pacmanOpenPath closePath];
    
    // Create a UIBezierPath for Pacman's close state
    pacmanClosedPath = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                      radius:radius
                                                  startAngle:DEGREES_TO_RADIANS(1)
                                                    endAngle:DEGREES_TO_RADIANS(359)
                                                   clockwise:YES];
    [pacmanClosedPath addLineToPoint:arcCenter];
    [pacmanClosedPath closePath];
    
    // Create a CAShapeLayer for Pacman, fill with yellow
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor yellowColor].CGColor;
    shapeLayer.path = pacmanClosedPath.CGPath;
    shapeLayer.strokeColor = [UIColor grayColor].CGColor;
    shapeLayer.lineWidth = 1.0f;
    shapeLayer.bounds = CGRectMake(0, 0, diameter, diameter);
    shapeLayer.position = CGPointMake(-40, -100);
    [self.view.layer addSublayer:shapeLayer];
    
    SEL startSelector = @selector(startAnimation);
    UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:startSelector];
    [self.view addGestureRecognizer:recognizer];
}

- (void)startAnimation {
    // 创建咬牙动画
    CABasicAnimation *chompAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    chompAnimation.duration = 0.25;
    chompAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    chompAnimation.repeatCount = HUGE_VALF;
    chompAnimation.autoreverses = YES;
    // Animate between the two path values
    chompAnimation.fromValue = (id)pacmanClosedPath.CGPath;
    chompAnimation.toValue = (id)pacmanOpenPath.CGPath;
    [shapeLayer addAnimation:chompAnimation forKey:@"chompAnimation"];
    
    // Create digital '2'-shaped path
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 100)];
    [path addLineToPoint:CGPointMake(300, 100)];
    [path addLineToPoint:CGPointMake(300, 200)];
    [path addLineToPoint:CGPointMake(0, 200)];
    [path addLineToPoint:CGPointMake(0, 300)];
    [path addLineToPoint:CGPointMake(300, 300)];
    
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnimation.path = path.CGPath;
    moveAnimation.duration = 8.0f;
    // Setting the rotation mode ensures Pacman's mouth is always forward.  This is a very convenient CA feature.
    moveAnimation.rotationMode = kCAAnimationRotateAuto;
    [shapeLayer addAnimation:moveAnimation forKey:@"moveAnimation"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
     [super viewDidUnload];
}

- (IBAction)tranAction:(id)sender {
    CGPoint fromPoint = self.imageView.center;
    
    //路径曲线
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:fromPoint];
    CGPoint toPoint = CGPointMake(300, 460);
    [movePath addQuadCurveToPoint:toPoint
                     controlPoint:CGPointMake(300,0)];
    //关键帧
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = movePath.CGPath;
    moveAnim.removedOnCompletion = YES;
    
    //旋转变化
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //x，y轴缩小到0.1,Z 轴不变
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
    scaleAnim.removedOnCompletion = YES;
    
    //透明度变化
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.1];
    opacityAnim.removedOnCompletion = YES;
    
    //关键帧，旋转，透明度组合起来执行
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim,opacityAnim, nil];
    animGroup.duration = 1;
    [self.imageView.layer addAnimation:animGroup forKey:nil];
}

- (IBAction)RightRotateAction:(id)sender {
    CGPoint fromPoint = self.imageView.center;
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:fromPoint];
    CGPoint toPoint = CGPointMake(fromPoint.x +100 , fromPoint.y ) ;
    [movePath addLineToPoint:toPoint];
    
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = movePath.CGPath;
    
    CABasicAnimation *TransformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    TransformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //沿Z轴旋转
    TransformAnim.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI,0,0,1)];
    
    //沿Y轴旋转
  //   scaleAnim.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI,0,1.0,0)];
    
    //沿X轴旋转
//     TransformAnim.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI,1.0,0,0)];
    TransformAnim.cumulative = YES;
    TransformAnim.duration =3;
    //旋转2遍，360度
    TransformAnim.repeatCount =2;
    self.imageView.center = toPoint;
    TransformAnim.removedOnCompletion = YES;
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:moveAnim, TransformAnim, nil];
    animGroup.duration = 6;
    
    [self.imageView.layer addAnimation:animGroup forKey:nil];
}

- (IBAction)Rotate360Action:(id)sender {
    //图片旋转360度
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         CATransform3DMakeRotation(M_PI, 0, 0, 1.0) ];
    animation.duration = 3;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 2;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [self.imageView.image drawInRect:CGRectMake(1,1,self.imageView.frame.size.width-2,self.imageView.frame.size.height-2)];
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.imageView.layer addAnimation:animation forKey:nil];
}
@end
