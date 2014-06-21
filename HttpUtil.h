//
//  HttpUtil.h
//  TestMVC
//
//  Created by libin on 14-2-16.
//  Copyright (c) 2014年 libin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HttpResult.h"
#import "DataUtil.h"
#import "NetConfig.h"

@protocol HttpUtilDelegate <NSObject>

-(void) httpOk:(HttpResult *) result;


@end

@interface HttpUtil : NSObject
{
    #if __has_feature(objc_arc_weak)
       __weak id <HttpUtilDelegate>delegate;
    #else
	  __unsafe_unretained id <HttpUtilDelegate>delegate;
    #endif
    
    NSString *pageId;                   //调用页面id
    NSString *transactionId;            //调用交易id  url
    NSMutableDictionary *transactionArgument;  //调用交易参数
    NSString *activityIndicatorText;    //活动指示器文字
    BOOL isShowActivityIndicator;       //是否显示活动指示器
    BOOL isCanCancel;                   //是否支持交易取消
    BOOL isGetMethod;                   //GET还是POST方式
    BOOL isLoginCookie;                   //是否是登录 获取cookie
    BOOL isQueue;
    
}
#if __has_feature(objc_arc_weak)
@property (nonatomic, weak) id <HttpUtilDelegate>delegate;
#else
@property (nonatomic, unsafe_unretained) id <HttpUtilDelegate>delegate;
#endif

 


@property (nonatomic ,retain)  NSString *pageId;                   //调用页面id
@property (nonatomic ,retain) NSString *transactionId;            //调用交易id  url
@property (nonatomic ,retain) NSMutableDictionary *transactionArgument;  //调用交易参数
@property (nonatomic ,retain) NSString *activityIndicatorText;    //活动指示器文字
@property (nonatomic ,assign) BOOL isShowActivityIndicator;       //是否显示活动指示器
@property (nonatomic ,assign) BOOL isCanCancel;                   //是否支持交易取消
@property (nonatomic ,assign) BOOL isGetMethod;                   //GET还是POST方式
@property (nonatomic ,assign) BOOL isLoginCookie;                   //是否是登录 获取cookie
@property (nonatomic ,assign) BOOL isQueue;                   //是否是登录 获取cookie

+(void)executeTransaction:(HttpUtil*)caller;



+ (HttpUtil *)sharedInstance;
//-(void)  httPost: (NSString *) url parmeter: (NSString *) parmeter pageId:(NSString *) pageId;
 //-(void)  httGet: (NSString *) url2 parmeter: (NSString *) parmeter pageId:(NSString *) pageId;

//是否队列
+(void) setMaxConcurrentOperationCount:(int) count;


//需要cookie
-(void)  httGet_cookie: (NSString *) url2 parmeter: (NSMutableDictionary *) parmeter ;

-(void)  httGet_no_cookie: (NSString *) url2 parmeter: (NSMutableDictionary *) parmeter  ;

-(void)  httPost_no_cookie: (NSString *) url2 parmeter: (NSMutableDictionary *) parmeter  ;
-(void)  httPost_cookie: (NSString *) url2 parmeter: (NSMutableDictionary *) parmeter;
+(bool) checkSessionTimeout;
+ (void) closeHttp;

@end
