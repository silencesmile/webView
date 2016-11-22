//
//  ViewController.m
//  WebviewDemo
//
//  Created by admin on 15/5/27.
//  Copyright (c) 2016年 admin. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

#define URLSTRING @"https://www.baidu.com/index.php?tn=kwmusic_adr"

@interface ViewController ()
{
    NSURLConnection *theConnection;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *myWebview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:myWebview];
    
    
  
    
    
   
    NSURL *url = [NSURL URLWithString:URLSTRING];
    NSURLRequest *request =[NSURLRequest requestWithURL:url
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:10.0]; // 将时间改为0.002即可测试加载超时
    [myWebview loadRequest:request];

    
    if (theConnection)
    {
        [theConnection cancel];
//        SAFE_RELEASE(theConnection);
        NSLog(@"safe release connection");
    }
    theConnection= [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (theConnection) {
//        SAFE_RELEASE(theConnection);
        NSLog(@"safe release connection");
    }
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]]){
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if ((([httpResponse statusCode]/100) == 2)){
            NSLog(@"connection ok");
        }
        else{
            NSError *error = [NSError errorWithDomain:@"HTTP" code:[httpResponse statusCode] userInfo:nil];
            if ([error code] == 404){
                NSLog(@"404");
//                [self openNextLink];
            }
           else if ([error code] == 403){
                NSLog(@"403");
                //                [self openNextLink];
            }
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    if (theConnection) {
//        SAFE_RELEASE(theConnection);
        NSLog(@"safe release connection");
         [self webViewFail];
    }
//    if (loadNotFinishCode == NSURLErrorCancelled)  {
//        return;
//    }
    if (error.code == 22) //The operation couldn’t be completed. Invalid argument
    {
        NSLog(@"22");
     [self webViewFail];
    }
    else if (error.code == -1001) //The request timed out.  webview code -999的时候会收到－1001
    {
        NSLog(@"-1001");
     [self webViewFail];
    }
    else if (error.code == -1005) //The network connection was lost.
    {
        NSLog(@"-1005");
     [self webViewFail];
    }
    else if (error.code == -1009) //The Internet connection appears to be offline
    {
        NSLog(@"-1009");
         [self webViewFail];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"加载失败");
     [self webViewFail];
}


- (void)webViewFail
{
    
//    UILabel *content = [[UILabel alloc]initWithFrame:(CGRectMake(20, 100, 300, 100))];
//    NSString *originStr = @"Hello,中秋节！";
//    NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString: originStr];
//    [attributedStr01 addAttribute: NSForegroundColorAttributeName value: [UIColor blueColor] range: NSMakeRange(0, 4)];
//    //分段控制，第5个字符开始的3个字符，即第5、6、7字符设置为红色
//    [attributedStr01 addAttribute: NSForegroundColorAttributeName value: [UIColor redColor] range: NSMakeRange(4, 3)];
//    
//    //赋值给显示控件label01的 attributedText
//    content.attributedText = attributedStr01;
//    [self.view addSubview:content];
    
    
    /*静态页面显示加载失败*/
                UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
                NSString *path = [[NSBundle mainBundle] bundlePath];
                NSURL *baseURL = [NSURL fileURLWithPath:path];
                NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"webError"
                                                                      ofType:@"html"];
                NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                                encoding:NSUTF8StringEncoding
                                                                   error:nil];
                [webView loadHTMLString:htmlCont baseURL:baseURL];
                [self.view addSubview: webView];
    
//     JS 调用 OC
//     1、首先导入库 JavaScriptCore.framework
    
                JSContext *context = [webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
                context[@"btnSubmit"] = ^() {
                
                    NSLog(@"返回上一页");
    
                };
}

@end
