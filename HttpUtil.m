//
//  HttpUtil.m
//  TestMVC
//
//  Created by libin on 14-2-16.
//  Copyright (c) 2014年 libin. All rights reserved.
//

#import "HttpUtil.h"

#import "ASIHTTPRequest.h"
#import "AlertUtil.h"
#import "ASIFormDataRequest.h"
#import "DataUtil.h"
@implementation HttpUtil
//(ASIBasicBlock)aCompletionBlock
static HttpUtil * _sharedInstance;
static  BOOL isQueue =YES;


static  NSOperationQueue * queue;

static int maxConcurrentOperationCount =2 ;


@synthesize  pageId;                   //调用页面id
@synthesize   transactionId;            //调用交易id  url
@synthesize transactionArgument;  //调用交易参数
@synthesize activityIndicatorText;    //活动指示器文字
@synthesize isShowActivityIndicator;       //是否显示活动指示器
@synthesize  isCanCancel;                   //是否支持交易取消
@synthesize isGetMethod;                   //GET还是POST方式
@synthesize isLoginCookie;                 //GET还是POST方式
@synthesize isQueue;
 @synthesize delegate;
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

+(void)executeTransaction:(HttpUtil*)http
{
    
    
    if(http.isQueue){
        [HttpUtil setMaxConcurrentOperationCount:1];
    }else{
        [HttpUtil setMaxConcurrentOperationCount:3];
    }
    if(!http.isLoginCookie){
        if(!http.isGetMethod){
            [http  httPost_cookie: http.transactionId parmeter:http.transactionArgument  ];
            
        } else {
            [http httGet_cookie: http.transactionId parmeter:http.transactionArgument  ];
        }
    }else{
        if(!http.isGetMethod){
            //HttpUtil *http= [[HttpUtil  alloc]init] ;
            
             //http.delegate=delegate;
            NSLog(@"post");
            [http  httPost_no_cookie: http.transactionId parmeter:http.transactionArgument
             ];
            
        } else {
            
            [http  httGet_no_cookie: http.transactionId parmeter:http.transactionArgument  ];
        }
    }
}

+(void) setMaxConcurrentOperationCount:(int) count
{
    if(isQueue){
        if(!queue )
        {
            queue = [[NSOperationQueue alloc ] init];
        }
        [ queue  setMaxConcurrentOperationCount:count];
    }

}
//- (id)init
//{
//    self = [super init];
//    if (self) {
//        isQueue = YES;
//        maxConcurrentOperationCount = 2;
//        
//        //self.activityIndicatorCount = 0;
//    }
//    return self;
//}
+ (HttpUtil *)sharedInstance;
{
    @synchronized(self)
    {
        if (!_sharedInstance){
            _sharedInstance = [[HttpUtil alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(closeHttp2:)
                                                 name:CloseAsiHttp
                                                object:nil];
        }
        return _sharedInstance;
    }
}
+ (void) closeHttp2: (NSNotification*)notification;
{
    
  //  NSString *str = [notification object];
  //  NSLog(@"关闭");
    [queue cancelAllOperations];
    
     //request cancel];
}
+ (void) closeHttp
{
    
    //  NSString *str = [notification object];
    //  NSLog(@"关闭");
    [queue cancelAllOperations];
    
    //request cancel];
}
//为了获取cookie
-(void)  httPost_no_cookie: (NSString *) url2 parmeter: (NSMutableDictionary *) parmeter
{
    
    
    
 [ASIHTTPRequest setSessionCookies:nil];
  //  NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    int   date = [[NSDate date] timeIntervalSince1970];
    [DataUtil wrtiteInteger:date forKey:session_last_date];

    
    
  //  dispatch_async(dispatch_get_main_queue(), ^{
  //      //更新UI操作
        if(self.isShowActivityIndicator){
              [[AlertUtil  sharedInstance ] show:isCanCancel labelText:self.activityIndicatorText ];
        }
   /// });

    NSURL *url =[NSURL URLWithString:[BaseUrl  stringByAppendingString:url2]];
 
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
 

    for(id akey in [parmeter allKeys] )
    {
        [request setPostValue:[parmeter objectForKey:akey] forKey:akey];
    }
    
    [request setTimeOutSeconds:HttpTimeOutSeconds];
    [request setCompletionBlock: ^{
       // dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            [[AlertUtil  sharedInstance ] close ];
       // });
        
        NSString *data2  = [request responseString];
        if([data2 isEqualToString:@""] || data2 ==nil){
            ShowNetErrorAlertView
            return ;
        }
 
      //  cookie保存到本地 
        NSString * cookie = [[request responseHeaders] objectForKey:@"Set-cookie"];
       

        NSString *jsession=@"JSESSIONID";
        if(cookie){ 
         //   NSLog(cookie);
            NSMutableDictionary * kk = [NSMutableDictionary dictionaryWithCapacity:5];
            NSArray *aArray = [cookie componentsSeparatedByString:@";"];
            
            for(int i=0;i<aArray.count;i++){
                NSString * t = aArray[i];//key=v&d=2
                NSArray *aArray2 = [t componentsSeparatedByString:@"="];
                if(aArray2.count<2){
                    continue;
                }
                NSString *key =aArray2[0];
                if([key isEqualToString:jsession]){
                    NSString *cookieStr = [NSString stringWithFormat:@"%@=%@",jsession,aArray2[1]];
                 
                    NSDictionary *cookieDic = [NSDictionary dictionaryWithObjectsAndKeys:cookieStr,@"cookieStr", nil];
                    
//                    [[[[SBJsonWriter alloc] init] dataWithObject:cookieDic] writeToFile:DOCUMENT_FOLDER(kCookie) atomically:YES];
                     [DataUtil wrtiteString:aArray2[1] forKey:session_id];
                }
                key =[ key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if([key isEqualToString:@"Path" ]){
                    [DataUtil wrtiteString:aArray2[1] forKey:@"cookiePath"];
                    continue;
                }
                [kk setValue:aArray2[1] forKey:key];
            }
            
            
        }
       // NSLog(data2);
        //NSDictionary 是固定的
        //NSMutableDictionary  是可变的
        HttpResult * httpResult = [[HttpResult alloc] init];
        httpResult.resultStr =data2;
        httpResult.resultType =url2;
        [delegate httpOk:httpResult];
       // [[NSNotificationCenter defaultCenter] postNotificationName:pageId object:httpResult];
        
    }];
    
    [request setFailedBlock: ^{
      [[AlertUtil  sharedInstance ] close];
        NSError  * error =  [request  error];
        
       // dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            [[AlertUtil  sharedInstance ] close];
        
        //});
        if(error.code ==3){
            NSString * userInfo = [error .userInfo  objectForKey:@"NSLocalizedDescription"];
            if([userInfo isEqualToString:@"Authentication needed" ]){
                NSLog(@"session 过期 http 401");
            }
        }
        else if(error.code ==4){
            NSString * userInfo = [error .userInfo  objectForKey:@"NSLocalizedDescription"];
            if([userInfo isEqualToString:@"The request was cancelled"]){
                NSLog(@"The request was cancelled");
            }
            
        }
        else{
           // dispatch_async(dispatch_get_main_queue(), ^{
                //更新UI操作
            
                // [[AlertUtil  sharedInstance ] showWithLabelText:@"error"];
                
                UIAlertView *alertView  =  [[UIAlertView alloc] initWithTitle:@"请求失败" message:@"网络连接失败"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                
                
           // });
        }
        [request clearDelegatesAndCancel];
        
    }]; 
   // [request startAsynchronous];
    if(isQueue){
       if(!queue )
       {
         queue = [[NSOperationQueue alloc ] init];
        [ queue  setMaxConcurrentOperationCount:maxConcurrentOperationCount];
       }
       [ queue  addOperation:request];
    }else{
        [request startAsynchronous];
    }
}
//为了获取cookie
-(void)  httPost_cookie: (NSString *) url2 parmeter: (NSMutableDictionary *) parmeter
{
    
    int   date = [[NSDate date] timeIntervalSince1970];
    [DataUtil wrtiteInteger:date forKey:session_last_date];
  

    
    
   // dispatch_async(dispatch_get_main_queue(), ^{
        //更新UI操作
        if(isShowActivityIndicator){
             //[[AlertUtil  sharedInstance ] showWithCanCancel:YES];
           // - (void)show:(BOOL)canCancel labelText:(NSString*)labelText
            //[[AlertUtil  sharedInstance ] showWithCanCancel:YES];
            [[AlertUtil  sharedInstance ] show:isCanCancel labelText:activityIndicatorText ];
        }
   // });
    
    // ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    // NSURL *url = [NSURL URLWithString:[BASE_URL2 URLEncodedString]];]
    NSURL *url =[NSURL URLWithString:[BaseUrl  stringByAppendingString:url2]];
 
   __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    //cookie设置
    NSString * cookiePath =[DataUtil readString: @"cookiePath"];
    NSMutableDictionary *cookieObj = (NSMutableDictionary*)  [DataUtil readObject:@"cookieObj"];
    NSDictionary *properties = [[NSMutableDictionary alloc] init];
    
    //设置cookie value
    for(id akey in [cookieObj allKeys] )
    {
        [properties setValue:[cookieObj  objectForKey:akey]  forKey:NSHTTPCookieValue];
        [properties setValue:akey forKey:NSHTTPCookieName];
    }
    
    [properties setValue:CookieDomain forKey:NSHTTPCookieDomain];
    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
    [properties setValue:cookiePath forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie = [[ NSHTTPCookie alloc] initWithProperties:properties ];
    if(cookie){
        [request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
    }
    
    for(id akey in [parmeter allKeys] )
    {
        [request setPostValue:[parmeter objectForKey:akey] forKey:akey];
    }
    
    
    [request setCompletionBlock: ^{
       // dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
          [[AlertUtil  sharedInstance ] close ];
        //});
        
        
        
        NSString *data2  = [request responseString];
       
     //   UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"请求失败" message:data2 delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]; [av show];

        if( [data2 isEqualToString:@""] ){
            ShowNetErrorAlertView
        }else{
           
            HttpResult * httpResult = [[HttpResult alloc] init];
            httpResult.resultStr =data2;
            httpResult.resultType =url2;
            [delegate httpOk:httpResult];
        }
        
    }];
    [request setTimeOutSeconds:HttpTimeOutSeconds];
    [request setFailedBlock: ^{
        //Error Domain=ASIHTTPRequestErrorDomain Code=2 "The request timed out" UserInfo=0x9d55c60 {NSLocalizedDescription=The request timed out}
        [[AlertUtil  sharedInstance ] close];
        
        NSError  * error =  [request  error];
        if(error.code ==3){
            NSString * userInfo = [error .userInfo  objectForKey:@"NSLocalizedDescription"];
            if([userInfo isEqualToString:@"Authentication needed" ]){
                NSLog(@"session 过期 http 401");
                
                HttpResult * httpResult = [[HttpResult alloc] init];
                httpResult.resultStr =@"{\"error\":\"session_error\"}";
                httpResult.resultType =url2;
                [delegate httpOk:httpResult];
            }
        }
        else if(error.code ==4){
            NSString * userInfo = [error .userInfo  objectForKey:@"NSLocalizedDescription"];
            if([userInfo isEqualToString:@"The request was cancelled"]){
                NSLog(@"The request was cancelled");
            }
            
        }
        else{
            //dispatch_async(dispatch_get_main_queue(), ^{
                //更新UI操作
           /* if([url2 isEqualToString:finish_user_task_1001]){
                HttpResult * httpResult = [[HttpResult alloc] init];
                httpResult.resultStr =@"{\"error\":\"session_error\"}";
                httpResult.resultType =url2;
                [delegate httpOk:httpResult];
            }*/
            ShowNetErrorAlertView
//                UIAlertView *alertView  =  [[UIAlertView alloc] initWithTitle:@"请求失败" message:@"网络连接失败"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alertView show];
//                
            
           // });
        }
        [request clearDelegatesAndCancel];
        
    }];
    // [request startAsynchronous];
    if(isQueue){
        if(!queue )
        {
            queue = [[NSOperationQueue alloc ] init];
            [ queue  setMaxConcurrentOperationCount:maxConcurrentOperationCount];
        }
        [ queue  addOperation:request];
    }else{
        [request startAsynchronous];
    }
}

//带cookie get
-(void)  httGet_cookie: (NSString *) url2 parmeter: (NSMutableDictionary *) parmeter
{
    int   date = [[NSDate date] timeIntervalSince1970];
    [DataUtil wrtiteInteger:date forKey:session_last_date];
    
    //dispatch_async(dispatch_get_main_queue(), ^{
        //更新UI操作
        if(isShowActivityIndicator){
         [[AlertUtil  sharedInstance ] show:isCanCancel labelText:activityIndicatorText ];
        }
    //});
    
   
    NSString * url3 = url2;
    
     url3 = [url3 stringByAppendingString:@"?"];
  
    for(id akey in [parmeter allKeys] )
    {
        
         url3 =  [url3 stringByAppendingString:akey];
          url3 = [url3 stringByAppendingString:@"="];
         url3 = [url3 stringByAppendingString:[parmeter objectForKey:akey]];
         url3 = [url3 stringByAppendingString: @"&"];
        
     
    }
    
   url3=[[BaseUrl  stringByAppendingString:url3]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url =[NSURL URLWithString:url3];
    
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    
    
    NSString * cookiePath =[DataUtil readString: @"cookiePath"];
    NSMutableDictionary *cookieObj =(NSMutableDictionary*)  [DataUtil readObject:@"cookieObj"];
    NSDictionary *properties = [[NSMutableDictionary alloc] init];
    
    //设置cookie value
    for(id akey in [cookieObj allKeys] )
    {
        [properties setValue:[cookieObj  objectForKey:akey]  forKey:NSHTTPCookieValue];
        [properties setValue:akey forKey:NSHTTPCookieName];
    }
    
    [properties setValue:CookieDomain forKey:NSHTTPCookieDomain];
    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
    [properties setValue:cookiePath forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie = [[ NSHTTPCookie alloc] initWithProperties:properties ];
    if(cookie){
        [request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
    }
    [request setTimeOutSeconds:HttpTimeOutSeconds];
    [request setCompletionBlock: ^{
       // dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            [[AlertUtil  sharedInstance ] close ];
      // });
       
        NSString *data2  = [request responseString];
       // NSLog(data2);
        if([data2 isEqualToString:@""]){
            
            
      //      return ;
        }
       // NSData *data  = [request responseData];
   
        HttpResult * httpResult = [[HttpResult alloc] init];
       // NSLog(data2);
        httpResult.resultStr =data2;
        httpResult.resultType =url2;
        [self.delegate httpOk:httpResult];
       // [[NSNotificationCenter defaultCenter] postNotificationName:pageId object:httpResult];
        
    }];
    
    [request setFailedBlock: ^{
        
        [[AlertUtil  sharedInstance ] close];
        
        NSError  * error =  [request  error];
        if(error.code ==3){
            NSString * userInfo = [error .userInfo  objectForKey:@"NSLocalizedDescription"];
            if([userInfo isEqualToString:@"Authentication needed" ]){
                NSLog(@"session 过期 http 401");
            }
        }
        else if(error.code ==4){
            NSString * userInfo = [error .userInfo  objectForKey:@"NSLocalizedDescription"];
            if([userInfo isEqualToString:@"The request was cancelled"]){
                NSLog(@"The request was cancelled");
            }

        }
        else{
           // dispatch_async(dispatch_get_main_queue(), ^{
              //更新UI操作
            
            
            // [[AlertUtil  sharedInstance ] showWithLabelText:@"error"];
            
            UIAlertView *alertView  =  [[UIAlertView alloc] initWithTitle:@"请求失败" message:@"网络连接失败"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
           
          
        //});
        }
        
    }];
    
    if(isQueue){
        if(!queue )
        {
            queue = [[NSOperationQueue alloc ] init];
            [ queue  setMaxConcurrentOperationCount:maxConcurrentOperationCount];
        }
        [ queue  addOperation:request];
    }else{
        [request startAsynchronous];
    }

}

//检测是否session_error
+(bool) checkSessionTimeout
{
    int   c = [[NSDate date] timeIntervalSince1970];
    
    int last =[DataUtil readInteger: session_last_date];
    //1个小时
    if((c-last)>60*40){
        return YES;
    }
    return NO;
    
}
//不需要cookie get
-(void)  httGet_no_cookie: (NSString *) url2 parmeter: (NSMutableDictionary *) parmeter
{
   [ASIHTTPRequest setSessionCookies:nil];
    int   date = [[NSDate date] timeIntervalSince1970]; 
    [DataUtil wrtiteInteger:date forKey:session_last_date];
   
    
   // dispatch_async(dispatch_get_main_queue(), ^{
        //更新UI操作
        if(isShowActivityIndicator){
            [[AlertUtil  sharedInstance ] show:isCanCancel labelText:activityIndicatorText ];
        }
   // });
 
    
    NSString * url3 = url2;
    url3 = [url3 stringByAppendingString:@"?"];
    
    for(id akey in [parmeter allKeys] )
    {
        
        url3 =  [url3 stringByAppendingString:akey];
        url3 = [url3 stringByAppendingString:@"="];
        url3 = [url3 stringByAppendingString:[parmeter objectForKey:akey]];
        
       
        url3 = [url3 stringByAppendingString:@"&"];
        
      
    }
 
    url3=[[BaseUrl  stringByAppendingString:url3]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *url =[NSURL URLWithString:url3];
    
   __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    [request setTimeOutSeconds:HttpTimeOutSeconds];
    [request setCompletionBlock: ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            [[AlertUtil  sharedInstance ] close ];
        });
        
        NSString *data2  = [request responseString];
        if([data2 isEqualToString:@""] || data2 ==nil){
            ShowNetErrorAlertView
            return ;
        }
        
        // NSData *data  = [request responseData];
       
        NSString * cookie = [[request responseHeaders] objectForKey:@"Set-cookie"];
        NSString *jsession=@"JSESSIONID";
        if(cookie){
            //  [DataUtil wrtiteString:cookie forKey:kCookie];
            //   NSLog(cookie);
            NSMutableDictionary * kk = [NSMutableDictionary dictionaryWithCapacity:5];
            NSArray *aArray = [cookie componentsSeparatedByString:@";"];
            
            for(int i=0;i<aArray.count;i++){
                NSString * t = aArray[i];//key=v&d=2
                NSArray *aArray2 = [t componentsSeparatedByString:@"="];
                if(aArray2.count<2){
                    continue;
                }
                NSString *key =aArray2[0];
                if([key isEqualToString:jsession]){
                    //保存session
                    NSString *cookieStr = [NSString stringWithFormat:@"%@=%@",jsession,aArray2[1]];
                    NSDictionary *cookieDic = [NSDictionary dictionaryWithObjectsAndKeys:cookieStr,@"cookieStr", nil];
//                    [[[[SBJsonWriter alloc] init] dataWithObject:cookieDic] writeToFile:DOCUMENT_FOLDER(kCookie) atomically:YES];
                    [DataUtil wrtiteString:aArray2[1] forKey:session_id];
                    
                }
                key =   [ key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                if([key isEqualToString:@"Path" ]){
                    [DataUtil wrtiteString:aArray2[1] forKey:@"cookiePath"];
                    continue;
                }
                
                [kk setValue:aArray2[1] forKey:key];
            }
            
            
        }
      
        HttpResult * httpResult = [[HttpResult alloc] init];
     
        httpResult.resultStr =data2;
        httpResult.resultType =url2;
          [delegate httpOk:httpResult];
       
        
    }];
    [request setFailedBlock: ^{
        
        [[AlertUtil  sharedInstance ] close];
        
        NSError  * error =  [request  error];
        if(error.code ==3){
            NSString * userInfo = [error .userInfo  objectForKey:@"NSLocalizedDescription"];
            if([userInfo isEqualToString:@"Authentication needed" ]){
                NSLog(@"session 过期 http 401");
            }
        }
        else if(error.code ==4){
            NSString * userInfo = [error .userInfo  objectForKey:@"NSLocalizedDescription"];
            if([userInfo isEqualToString:@"The request was cancelled"]){
                NSLog(@"The request was cancelled");
            } 
        }
        else{
          //  dispatch_async(dispatch_get_main_queue(), ^{
                //更新UI操作
            
                // [[AlertUtil  sharedInstance ] showWithLabelText:@"error"];
                
                UIAlertView *alertView  =  [[UIAlertView alloc] initWithTitle:@"请求失败" message:@"网络连接失败"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                
           //
            //});
        }

                
        
    }];
    
    if(isQueue){
        if(!queue )
        {
            queue = [[NSOperationQueue alloc ] init];
            [ queue  setMaxConcurrentOperationCount:maxConcurrentOperationCount];
        }
        [ queue  addOperation:request];
    }else{
        [request startAsynchronous];
    }
}


@end
