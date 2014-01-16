//
//  AnimationViewController.h
//  CALayerFun
//
//  Created by rongfzh on 13-2-21.
//  Copyright (c) 2013年 rongfzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface AnimationViewController : UIViewController
{
    UIBezierPath *pacmanOpenPath;
    UIBezierPath *pacmanClosedPath;
    CAShapeLayer *shapeLayer;
}
- (IBAction)tranAction:(id)sender;
- (IBAction)RightRotateAction:(id)sender;
- (IBAction)Rotate360Action:(id)sender;
@property (strong, nonatomic) UIImageView *imageView;
@end
