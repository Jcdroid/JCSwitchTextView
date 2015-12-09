//
//  JCSwitchTextView.m
//  JCSwitchTextView
//
//  Created by Jcdroid on 15/12/8.
//  Copyright © 2015年 Jcdroid. All rights reserved.
//

#import "JCSwitchTextView.h"

#define kLineColor [UIColor colorWithWhite:0.800 alpha:1.000].CGColor
#define kTextColor [UIColor grayColor].CGColor
#define kTextPointSize [UIFont systemFontOfSize:14.0f].pointSize
#define kViewWidth CGRectGetWidth(self.frame)
#define kViewHeight CGRectGetHeight(self.frame)

static float const kLineWidth = 1.0f;
static float const kPadding = 10.0f;
static float const kRectRoundRadius = 5.0f;
static float const kSearchIconSideLength = 16.0f;
static float const kTextLayerHeight = 18.0f;
static float const kDefaultSpeed = 0.4f;
static double const kDefaulTimeInterval = 4.0;

@interface JCSwitchTextView () {
    CGPoint _currentPoint;// 当前scrolllayer滑动到得point
}

@property (strong, nonatomic, nonnull) CAScrollLayer *scrollLayer;

@property (strong, nonatomic, nonnull) NSArray *textArray;
@property (strong, nonatomic, nonnull) UIImage *iconImage;
@property (assign, nonatomic) NSTimeInterval timeInterval;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation JCSwitchTextView

- (instancetype)initWithFrame:(CGRect)frame iconImage:(UIImage *)image textArray:(NSArray *)textArray timeInterval:(NSTimeInterval)timeInterval
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textArray = textArray;
        self.iconImage = image;
        self.timeInterval = timeInterval;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadding, (kViewHeight - kSearchIconSideLength)/2, kSearchIconSideLength, kSearchIconSideLength)];
    iconView.image = _iconImage;
    [self addSubview:iconView];
    
    
    // shape layer
    CAShapeLayer *borderLayer = [CAShapeLayer new];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.frame cornerRadius:kRectRoundRadius];
    borderLayer.path = path.CGPath;
    borderLayer.lineWidth = kLineWidth;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = kLineColor;
    CGPathRef bounds = CGPathCreateCopyByStrokingPath(path.CGPath, nil, kLineWidth, kCGLineCapRound, kCGLineJoinRound, borderLayer.miterLimit);
    borderLayer.bounds = CGPathGetBoundingBox(bounds);
    CGPathRelease(bounds);
    
    borderLayer.position = CGPointMake(kViewWidth/2, kViewHeight/2);
    [self.layer addSublayer:borderLayer];
    
    
    // scroll layer
    _scrollLayer = ({
        CAScrollLayer *scrollLayer = [CAScrollLayer new];
        scrollLayer.frame = self.bounds;
        scrollLayer.speed = kDefaultSpeed;
        scrollLayer.scrollMode = kCAScrollVertically;
        [self.layer addSublayer:scrollLayer];
        scrollLayer;
    });
    
    
    // text layer
    CGFloat x = kPadding * 3/2 + kSearchIconSideLength;
    CGFloat y = (kViewHeight - kTextLayerHeight)/2;
    
    for (int i = 0; i < 2; i++) {
        CATextLayer *textLayer = [CATextLayer new];
        textLayer.string = _textArray[i];
        textLayer.foregroundColor = kTextColor;
        textLayer.alignmentMode = kCAAlignmentNatural;
        textLayer.wrapped = YES;
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.fontSize = kTextPointSize;
        textLayer.frame = CGRectMake(x, y, kViewWidth - 2 * x, kTextLayerHeight);
        [self.scrollLayer addSublayer:textLayer];
        y += CGRectGetHeight(self.frame);
    }
    
    [self createTimer];
}

- (void)nextText:(id)sender {
    
    CGFloat curY = _currentPoint.y;
    curY += kViewHeight;
    _currentPoint = CGPointMake(0, curY);
    [_scrollLayer scrollToPoint:_currentPoint];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kDefaultSpeed * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CATextLayer *topTextLayer = (CATextLayer *)weakSelf.scrollLayer.sublayers.firstObject;
        CATextLayer *bottomTextLayer = (CATextLayer *)weakSelf.scrollLayer.sublayers.lastObject;
        
        [topTextLayer removeFromSuperlayer];
        topTextLayer.hidden = YES;// 解决再次设置addSublayer时出现的下滑动画
        
        CGFloat x = kPadding * 3/2 + kSearchIconSideLength;
        CGFloat y = bottomTextLayer.frame.origin.y + kViewHeight;
        topTextLayer.frame = CGRectMake(x, y, kViewWidth - 2 * x, kTextLayerHeight);
        NSInteger index = curY / kViewHeight + 1;// 注意此时curY已经自增了
        topTextLayer.string = weakSelf.textArray[index % weakSelf.textArray.count];
        [weakSelf.scrollLayer addSublayer:topTextLayer];
        
        
        __weak typeof(topTextLayer) weakTopTextLayer = topTextLayer;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kDefaultSpeed * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            weakTopTextLayer.hidden = NO;
        });
    });
}

#pragma mark Public & Private M

- (void)createTimer {
    if (!_timer) {
        if (_timeInterval == 0) {
            _timeInterval = kDefaulTimeInterval;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(nextText:) userInfo:nil repeats:YES];
    }
}

- (void)endTimer {
    if (_timer && _timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
