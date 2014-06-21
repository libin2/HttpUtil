//
//  HttpCaller.m
//  TestMVC
//
//  Created by libin on 14-3-6.
//  Copyright (c) 2014年 libin. All rights reserved.
//

#import "HttpCaller.h"

@implementation HttpCaller



@synthesize  pageId;                   //调用页面id
@synthesize   transactionId;            //调用交易id  url
@synthesize transactionArgument;  //调用交易参数
@synthesize activityIndicatorText;    //活动指示器文字
@synthesize isShowActivityIndicator;       //是否显示活动指示器
@synthesize  isCanCancel;                   //是否支持交易取消
@synthesize isGetMethod;                   //GET还是POST方式
@synthesize isLoginCookie;                 //GET还是POST方式
@synthesize isQueue;
- (id)init
{
    self = [super init];
    if (self) {
        self.pageId = @"";
        self.transactionId = @"";
        //self.transactionArgument = [[NSMutableDictionary alloc]init];
        self.activityIndicatorText = @"请稍后";
        self.isShowActivityIndicator = YES;
        self.isGetMethod = NO;
        self.isCanCancel = NO;
        self.isLoginCookie = NO;
        self.isQueue = NO;
    }
    return self;
}

+(void)executeTransaction:(HttpCaller*)caller
{
    
    
    if(caller.isQueue){
        [HttpUtil setMaxConcurrentOperationCount:1];
    }else{
         [HttpUtil setMaxConcurrentOperationCount:3];
    }
   /* if(!caller.isLoginCookie){
        if(!caller.isGetMethod){
            [[HttpUtil  sharedInstance]  httPost_cookie: caller.transactionId parmeter:caller.transactionArgument pageId:caller.  pageId isShowActivityIndicator:caller.isShowActivityIndicator activityIndicatorStr:caller.activityIndicatorText isCanCancel:caller.isCanCancel ];
            
        } else {
            [[HttpUtil  sharedInstance]  httGet_cookie: caller.transactionId parmeter:caller.transactionArgument pageId:caller.pageId isShowActivityIndicator:caller.isShowActivityIndicator activityIndicatorStr:caller.activityIndicatorText isCanCancel:caller.isCanCancel ];
        }
    }else{
        if(!caller.isGetMethod){
            HttpUtil *http= [[HttpUtil  alloc]init] ;
            
            //http.delegate=delegate;
            
            [http  httPost_no_cookie: caller.transactionId parmeter:caller.transactionArgument pageId:caller.  pageId isShowActivityIndicator:caller.isShowActivityIndicator
                activityIndicatorStr:caller.activityIndicatorText isCanCancel:caller.isCanCancel
             ];

        } else {
            [[HttpUtil  sharedInstance]  httGet_no_cookie: caller.transactionId parmeter:caller.transactionArgument pageId:caller.pageId isShowActivityIndicator:caller.isShowActivityIndicator activityIndicatorStr:caller.activityIndicatorText isCanCancel:caller.isCanCancel ];
        }
    }*/
}
@end
