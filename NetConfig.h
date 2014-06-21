//
//  NetConfig.h
//  
//
//  Created by libin on 14-3-8.
//  Copyright (c) 2014年 libin. All rights reserved.
//

#import <Foundation/Foundation.h>


//----网络UI弹框配置

#define     CookieDomain @"www.test.com"
#define     HttpTimeOutSeconds 10


#define ShowNetErrorAlertView UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"请求失败" message:@"网络连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]; [av show];

#define ShowErrorAlertView  if([[dic valueForKey:@"error"] isEqualToString:@"session_error"]){ \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message: @"身份验证失败，请退出重新登录" delegate:nil  cancelButtonTitle:@"确定" otherButtonTitles:nil];\
[alert show];\
}else{\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic valueForKey:@"error"] delegate:nil  cancelButtonTitle:@"确定" otherButtonTitles:nil];\
[alert show];\
}
#define ShowJiFenErrorAlertView UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"系统维护中..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]; [av show];

//url 根地址
#if defined (MODEL_DEBUG)
  
 #define BaseUrl @"http://127.0.0.1:8080/Test/api/v1/" 
#elif defined (MODEL_RELEASE)

 #define BaseUrl @"http://127.0.0.1:8080/Test/api/v1/" 
#endif 





//网络工具

//创建网络请求
 
#define new_http_caller  HttpUtil * caller =  [[HttpUtil alloc ] init];\
                            caller.delegate = (id<HttpUtilDelegate>)self;
//caller.pageId = NSStringFromClass([self class]);
//执行网络请求
#define execute_http_caller    [HttpUtil  executeTransaction:caller];

//添加网络ui监听
#define add_transaction [[NSNotificationCenter defaultCenter] addObserver:self \
selector:@selector(pageHttpCallbackCaller:)\
name:NSStringFromClass([self class])\
object:nil];
//删除网络ui监听
#define remove_transaction   [[NSNotificationCenter defaultCenter] removeObserver:self name:NSStringFromClass([self class])      object:nil];
//定义asi 取消请求
#define	CloseAsiHttp 	    @"CloseAsiHttpNotification"
  
//定义session时间记录
#define   session_last_date @"session_last_date"


//session_id
#define    session_id @"session_id"
 
#define isMarket @"false"
 
#pragma mark - 配置服务接口
/************************************************************************
 *
 *配置服务接口
 *
 ***********************************************************************/
#define visitorLogin              @"users/ios/visitorLogin"  //用户一键注册 

/***********************************************************************/


@interface NetConfig : NSObject

@end
