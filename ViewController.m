//
//  ViewController.m
//  动画旋转放大
//
//  Created by Mac on 15/12/29.
//  Copyright © 2015年 Mac－Cx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIImageView *_testImg;
    NSTimer *_timer;
    float rotateCount;
    
    //缩放
    UIImageView *_testImgBg;
    float scaleCount;
    BOOL isBig;

}
- (IBAction)statrAction:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    rotateCount=0.0f;
//    moveX=0;
//    moveX2=0;
    scaleCount=1;
    
    //Command+Shift+K 清除缓存
    //Command+B 编译
    _testImgBg=[[UIImageView alloc] initWithFrame:CGRectMake(120, 100, 100, 100)];
    [_testImgBg setImage:[UIImage imageNamed:@"5.png"]];
    [self.view addSubview:_testImgBg];
    _testImg=[[UIImageView alloc] initWithFrame:CGRectMake(120, 300, 150, 150)];
    [_testImg setImage:[UIImage imageNamed:@"5.png"]];
    [self.view addSubview:_testImg];
   
    [self setupAnimationInLayer:_testImgBg withSize: CGSizeMake(300, 300) tintColor:[UIColor redColor]];
    [self setupAnimationInLayerr:_testImg withSize:CGSizeMake(200, 200) tintColor:[UIColor redColor]];
}
- (void)setupAnimationInLayerr:(UIView *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 2.0f;
    
    //    Scale animation
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
//    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
//                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6f, 0.6f, 1.0f)],
//                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
//    scaleAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    
    // Rotate animation
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotateAnimation.values = @[@0, @M_PI, @(2 * M_PI)];
    rotateAnimation.keyTimes = scaleAnimation.keyTimes;
    
//    // Animation
    CAAnimationGroup *animation = [CAAnimationGroup animation];
//
    animation.animations = @[scaleAnimation, rotateAnimation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = NO;
    
    // Draw ball clip
    CAShapeLayer *circle = [CAShapeLayer layer];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(size.width / 2, size.height / 2) radius:size.width / 2 startAngle:1.5 * M_PI endAngle:M_PI clockwise:true];
    
    circle.path = circlePath.CGPath;
    circle.lineWidth = 2;
    circle.fillColor = nil;
    circle.strokeColor = tintColor.CGColor;
    
    circle.frame = CGRectMake((layer.bounds.size.width - size.width) / 2, (layer.bounds.size.height - size.height) / 2, size.width, size.height);
    [layer.layer addAnimation:animation forKey:@"animation"];
}


- (void)setupAnimationInLayer:(UIView *)viewLayer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    NSTimeInterval beginTime = CACurrentMediaTime();
    
//    CGFloat circleSize = size.width * 0.92f;
//    CGFloat oX = (layer.bounds.size.width - size.width) / 2.0f;
//    CGFloat oY = (layer.bounds.size.height - circleSize) / 2.0f;
    for (int i = 0; i < 1; i++) {
//        CALayer *circle = [CALayer layer];
//        CGFloat offset = circleSize / 2.0f * i;
//        circle.frame = CGRectMake((offset + size.width - circleSize) * i + oX, oY, circleSize, circleSize);
//        circle.cornerRadius = circle.bounds.size.height / 2.0f;
//        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
//        circle.transform = CATransform3DMakeScale(0.0f, 0.0f, 0.0f);
//        circle.backgroundColor = tintColor.CGColor;
        
        CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        transformAnimation.removedOnCompletion = NO;
        transformAnimation.repeatCount = HUGE_VALF;
        transformAnimation.duration = 1.8f;
        transformAnimation.beginTime = beginTime - (transformAnimation.duration / 2.0f * i);
        transformAnimation.keyTimes = @[@(0.0), @(0.5), @(1.0)];
        
        transformAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        transformAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5f, 0.5f, 0.0f)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5f, 0.5f, 0.0f)]];
        
//        [layer.layer addSublayer:circle];
        [viewLayer.layer addAnimation:transformAnimation forKey:@"animation"];
    }
}
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)statrAction:(id)sender {
    _timer=[NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(timerWork) userInfo:nil repeats:YES];

}
-(void)timerWork{
    //旋转
    rotateCount-=0.001;
    _testImg.transform=CGAffineTransformMakeRotation(rotateCount);
    
    //缩放
    if (!isBig) {
        if (scaleCount<=1) {
            scaleCount+=0.001;
            _testImgBg.transform=CGAffineTransformMakeScale(scaleCount, scaleCount);
        }else{
            isBig=YES;
        }
        
    }else{
        if (scaleCount>=1) {
            scaleCount-=0.001;
            _testImgBg.transform=CGAffineTransformMakeScale(scaleCount, scaleCount);
        }else{
            isBig=NO;
        }
    }
    
    
}




@end
