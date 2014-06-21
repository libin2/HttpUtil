HttpUtil
========
This is a ASIHttpRequest package, return to the main HTTP server processing strings and cookie
Usage is as follows:

1 modifications of the NetConfig CookieDomain, BaseUrl, request.

2 example code

  NSMutableDictionary * args = [NSMutableDictionary dictionaryWithCapacity:5];
  [args setValue: [[UIDevice currentDevice] model] forKey:@ "users[phoneModel]"];
  New_http_caller
  Caller.isGetMethod=NO;
  Caller.transactionId=myLogin;
  Caller.isShowActivityIndicator=NO;
  Caller.transactionArgument = kk;
  Caller.isLoginCookie = YES;
  Caller.isQueue = YES;
  Execute_http_caller
  When the string returned by the server will receive the callback of the class
  - (void) httpOk: (HttpResult *) result
  {
    if ([result.resultType isEqualToString:myLogin]) {
    }
  }
