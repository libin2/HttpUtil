//
//  AlertUtil.h
//  TestAsi2
//
//  Created by user on 14-2-12.
//  Copyright (c) 2014年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "HttpUtil.h"
#define kLabelText @"请稍后"
@interface AlertUtil : NSObject
{
    MBProgressHUD *activityIndicator;
    int activityIndicatorCount;
    UIButton *cancelButton;
 
    
}
@property (assign, nonatomic) int activityIndicatorCount;
@property (nonatomic, strong) MBProgressHUD *activityIndicator;
@property (nonatomic, strong) UIButton *cancelButton;
+ (AlertUtil *)sharedInstance;
- (void)addToShowView:(UIView*)showView;
- (void)show;
- (void)showWithLabelText:(NSString*)labelText;
- (void)showWithCanCancel:(BOOL)canCancel;
- (void)show:(BOOL)canCancel labelText:(NSString*)labelText;
- (void)hidden;
- (void)close;
@end
