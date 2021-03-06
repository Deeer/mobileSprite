//
//  WeiBoViewController.m
//  LogInPart
//
//  Created by zjsruxxxy3 on 15/2/8.
//  Copyright (c) 2015年 wrcj. All rights reserved.
//

#import "WeiBoViewController.h"
#import "WeiBoOAuth.h"
#import "WeiBoAcountTool.h"

#import "CurrentToken.h"
#import "AccessTokenTool.h"

#import "AFNetworking.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"

#import "SwitchControllerTool.h"


@interface WeiBoViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)NSMutableDictionary *parameters;

@end

@implementation WeiBoViewController

-(NSMutableDictionary *)parameters
{
    if (!_parameters)
    {
        _parameters = [NSMutableDictionary dictionary];
        
        [_parameters setObject:@"1622164672" forKey:@"client_id"];
        
        [_parameters setObject:@"97314fe332e7a7093bc5fbcb7d956cf7"
                       forKey:@"client_secret"];
        
        [_parameters setObject:@"authorization_code" forKey:@"grant_type"];
        
        [_parameters setObject:@"http://www.baidu.com" forKey:@"redirect_uri"];
    }
    
    return _parameters;
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"微博登陆";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backToDismiss)];
        
        self.view.backgroundColor =[UIColor whiteColor];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupWeiBoLogView];
}

- (void)setupWeiBoLogView
{
    UIWebView *logView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    
    logView.delegate = self;
    
    [MBProgressHUD showMessage:@"loading"];

    [logView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=1622164672&redirect_uri=http://www.baidu.com"]]];
    
    [self.view addSubview:logView];
    

}

#pragma webViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    /**
     *  截取url，获取code的值，用于获取access_token。
     */
    
    NSLog(@"shouldStartLoadWithRequest-%@",request.URL);
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlString = request.URL.absoluteString;
    
    NSRange range = [urlString rangeOfString:@"code="];
    
    if (range.location != NSNotFound)
    {
        /**
         *  屏蔽回调页面。
         */
        webView.hidden = YES;
        
        NSString *code = [urlString substringFromIndex:(range.location + range.length)];
        
        [self.parameters setObject:code forKey:@"code"];
        
        [requestManager POST:@"https://api.weibo.com/oauth2/access_token" parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
        {

            [MBProgressHUD showSuccess:@"success"];
            
            WeiBoOAuth *oauth = [WeiBoOAuth objectWithKeyValues:responseObject];
            
            /**
             *  设置登陆状态为yes
             */
            
            oauth.logState = YES;
            
            CurrentToken *currentToken = [CurrentToken new];
            currentToken.current_access_token = oauth.access_token;
            [AccessTokenTool saveToFileWithAccessToken:currentToken];
            
            NSLog(@"%@---%@",oauth.access_token,[AccessTokenTool getCurrentTokenFromFile].current_access_token);
            
            [WeiBoAcountTool acountSaveToFileWithOAuth:oauth];
            
            [SwitchControllerTool chooseRootViewController];
            

        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            [MBProgressHUD showError:@"network error"];
            
            [self backToDismiss];
            
        }];
        
        
    }
    
    
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad-%@",webView.request.URL);
    
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad-%@",webView.request.URL);
    
    [MBProgressHUD hideHUD];
    

}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD showError:@"network error"];

}


-(void)backToDismiss
{
    
    if ([self.delegate respondsToSelector:@selector(dismissController:)])
    {
        [self.delegate dismissController:self];
        
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
