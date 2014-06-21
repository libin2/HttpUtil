//
//  AlertUtil.m
//  TestAsi2
//
//  Created by user on 14-2-12.
//  Copyright (c) 2014年 user. All rights reserved.
//

#import "AlertUtil.h"

static AlertUtil *_sharedInstance;
 //static NSString * kLabelText=@"请稍后";
@implementation AlertUtil
@synthesize activityIndicatorCount,cancelButton,activityIndicator;

- (void)addToShowView:(UIView*)showView;
{
    //    self.activityIndicator = [[MBProgressHUD alloc] initWithView:showView];
    //  //  self.activityIndicator.delegate = (id<MBProgressHUDDelegate>)self;
    //    [showView addSubview:self.activityIndicator];
    //    self.activityIndicator.mode = MBProgressHUDModeIndeterminate;
    //    self.activityIndicator.labelText = @"请稍后";
    //    self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(self.activityIndicator.center.x+30, self.activityIndicator.center.y-60, 30, 30)];
    //    [self.cancelButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cancel.png" ofType:nil]] forState:UIControlStateNormal];
    //   // self.cancelButton.hidden = YES;
    //      [self.cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.activityIndicator addSubview:self.cancelButton];
    //
    //   [self.activityIndicator show:YES];
    
    self.activityIndicator = [[MBProgressHUD alloc] initWithView:showView];
    self.activityIndicator.delegate = (id<MBProgressHUDDelegate>)self;
    [showView addSubview:self.activityIndicator];
    self.activityIndicator.mode = MBProgressHUDModeIndeterminate;
    self.activityIndicator.labelText = kLabelText;
    self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(self.activityIndicator.center.x+30, self.activityIndicator.center.y-60, 30, 30)];
    [self.cancelButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cancel.png" ofType:nil]] forState:UIControlStateNormal];
    self.cancelButton.hidden = YES;
    [self.cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.activityIndicator addSubview:self.cancelButton];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.activityIndicatorCount = 0;
    }
    return self;
}
+ (AlertUtil *)sharedInstance;
{
    @synchronized(self)
    {
        if (!_sharedInstance)
            _sharedInstance = [[AlertUtil alloc] init];
        return _sharedInstance;
    }
}
- (void)show;
{
    self.cancelButton.hidden = YES;
    self.activityIndicator.labelText = @"请稍后";
    self.activityIndicatorCount++;
    [self.activityIndicator show:YES];
}

- (void)showWithLabelText:(NSString*)labelText
{
    self.cancelButton.hidden = YES;
    if (labelText!=nil && ![labelText isEqualToString:@""]) {
        self.activityIndicator.labelText = labelText;
    }else{
        self.activityIndicator.labelText = kLabelText;
    }
    self.activityIndicatorCount++;
    [self.activityIndicator show:YES];
    
}
- (void)showWithCanCancel:(BOOL)canCancel
{
    
    if (canCancel) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            self.cancelButton.hidden = NO;
        }
    }else{
        self.cancelButton.hidden = YES;
    }
    self.activityIndicator.labelText = kLabelText;
    self.activityIndicatorCount++;
    [self.activityIndicator show:YES];
    // [[NSNotificationCenter defaultCenter] postNotificationName: CloseAsiHttp object:nil];
}
- (void)show:(BOOL)canCancel labelText:(NSString*)labelText
{
    if (canCancel) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            self.cancelButton.hidden = NO;
        }
    }else{
        self.cancelButton.hidden = YES;
    }
    if (labelText!=nil && ![labelText isEqualToString:@""]) {
        self.activityIndicator.labelText = labelText;
    }else{
        self.activityIndicator.labelText = kLabelText;
    }
    self.activityIndicatorCount++;
    [self.activityIndicator show:YES];
    
}
- (void)hidden
{
    self.activityIndicatorCount--;
    if (self.activityIndicatorCount < 0) {
        self.activityIndicatorCount = 0;
    }
    if (self.activityIndicatorCount==0) {
        [self.activityIndicator hide:YES];
    }
    
}
- (void)close
{
    self.activityIndicatorCount = 0;
    if (self.activityIndicatorCount==0) {
        [self.activityIndicator hide:YES];
    }
}

-(void)cancelButtonAction:(UIButton*)sender;
{
    
     
    [self close];
    [ HttpUtil closeHttp];
    //  NSLog(@"DD");
    //[[NSNotificationCenter defaultCenter] postNotificationName: CloseAsiHttp object:@"dsx"];
}
@end
