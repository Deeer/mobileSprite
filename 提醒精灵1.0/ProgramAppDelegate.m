//
//  ProgramAppDelegate.m
//  提醒精灵1.0
//
//  Created by zjsruxxxy3 on 14-9-24.
//  Copyright (c) 2014年 wrcj. All rights reserved.
//

#import "ProgramAppDelegate.h"
#import "ProgramViewController.h"
#import "xViewController.h"
#import "Define.h"
#import "MyAudioTool.h"
#import "MusicModel.h"

#import "SwitchControllerTool.h"

static BOOL delay;

@interface ProgramAppDelegate ()
{
    NSDate *date1;
    NSDate *date2;
}



@end

@implementation ProgramAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    [self.window makeKeyAndVisible];
//    self.window.rootViewController = logViewController;
    
    [SwitchControllerTool chooseRootViewController];
    
    /*

#pragma mark countTime
    UITabBarController *tabViewC = (UITabBarController *)self.window.rootViewController;

    
    self.noteNumber = 1;
    
    delay = NO;
    
    

    if (launchOptions !=nil)
    {
        Appnote =  launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        
        NSDictionary *noteDic = Appnote.userInfo;
        
//        musicName = [NSString stringWithString:noteDic[theMusic]];
        musicName = Appnote.soundName;
        
        self.noteNumber = theNoteNum +1;

        NSMutableString *string = [NSMutableString stringWithFormat:@"%@-%@",noteDic,noteDic[theText]];
        
            for (UILocalNotification * oldNote in [UIApplication sharedApplication].scheduledLocalNotifications)
            {
                
                NSDictionary * oldDic = oldNote.userInfo;
                
                if ([noteDic[theIdenity]isEqualToString:oldDic[theIdenity]])
                {
                    if ([oldDic[theTimesNum]intValue] == 0)
                    {
    
                        [[UIApplication sharedApplication] cancelLocalNotification:oldNote];
                        
                    }
                }
            }


        UIAlertView *alertNote =[[UIAlertView alloc]initWithTitle:@"提醒" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alertNote show];
        
    }else
    {
        
        UINavigationController *navigationC = (UINavigationController *) tabViewC.viewControllers[0];
        
        ProgramViewController *rootVc =(ProgramViewController *)navigationC.topViewController;
        
        rootVc.canReload = YES;
        [rootVc.tabelView reloadData];
    }
    
#pragma mark countTime
 
    
    
     */

    return YES;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UITabBarController *tabViewC = (UITabBarController *)self.window.rootViewController;

 
//    tabViewC.tabBarItem.title=@"ssss";
    NSDictionary *noteDic = notification.userInfo;
    
    
    musicName = [NSString stringWithFormat:@"%@",notification.soundName];
    
    [MyAudioTool removeSound:musicName];
    
#warning messageNote---------
    
    
    
    
    if ([noteDic[RemaindIdenity] isEqualToString:@"message"])
    {
        
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        /*
         if ([noteDic[theNum]intValue] != 1 || [noteDic isEqual:Appnote])
         {
         return;
         }
         */
        
        //musicName = [NSString stringWithString:noteDic[theMusic]];

        
        NSString *string = [NSString stringWithFormat:@"%d---%@",self.noteNumber,noteDic[theText]];
        
        UIAlertView *alertNote = [[UIAlertView alloc]initWithTitle:@"提醒" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        alertNote.tag = 1001;
        
        
        [alertNote show];
        
        [MyAudioTool playSound:musicName];
        
        
        
        //    [NSTimer scheduledTimerWithTimeInterval:22 target:self selector:@selector(makeDelay:) userInfo:noteDic repeats:NO];
        
        
        for (UILocalNotification * oldNote in [UIApplication sharedApplication].scheduledLocalNotifications)
        {
            NSDictionary * oldDic = oldNote.userInfo;
            
            if ([noteDic[theIdenity]isEqualToString:oldDic[theIdenity]])
            {
                if ([oldDic[theTimesNum]intValue] == 0)
                {
                    [[UIApplication sharedApplication] cancelLocalNotification:oldNote];
                }
                
            }
        }

    }
    
#warning dateCount-----------
    
    if ([noteDic[RemaindIdenity] isEqualToString:@"dateCount"])
    {
        // selecte DateCountController
        
        [tabViewC setSelectedIndex:1];
        
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        NSString *string = [NSString stringWithFormat:@"%@",noteDic[@"dateText"]];
        
        UIAlertView *alertNote = [[UIAlertView alloc]initWithTitle:@"提醒" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alertNote show];
        
        [MyAudioTool playSound:musicName];
        
    }
    
#warning timeCount------------
    
    if ([noteDic[RemaindIdenity] isEqualToString:@"timeCount"])
    {
        // selecte DateCountController
        
        [tabViewC setSelectedIndex:2];
        
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        
        [MyAudioTool playSound:musicName];
        
    }
    
   
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
#pragma mark countTime
    /*
    
    self.noteNumber = 1;
    
    delay = NO;
     
     */

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
/*
#pragma mark countTime
    
    UITabBarController *tabViewC = (UITabBarController *)self.window.rootViewController;
    
    UINavigationController *navigationC = (UINavigationController *) tabViewC.viewControllers[2];
    
    xViewController *xVController =(xViewController *)navigationC.topViewController;
    
//    NSLog(@"%@",rootVc.notification.fireDate);
    
    //不关闭进入后台
    
    if (xVController.timer!=nil)
    {
        [xVController.timer invalidate];
        xVController.timer=nil;
        
        date1 =[NSDate date];
        
    }
     
    */

    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.


    
    /*

    UITabBarController *tabViewC = (UITabBarController *)self.window.rootViewController;
    
#pragma mark countTime
    
    UINavigationController *navigationC2 = (UINavigationController *) tabViewC.viewControllers[2];
    
    xViewController *xVController =(xViewController *)navigationC2.topViewController;

    
    if (date1 !=nil) {
        
        
        NSTimeInterval  interval =[[NSDate date] timeIntervalSinceDate:date1];
        NSLog(@"%f间隔",interval);
        
        
        xVController.totlaTime =xVController.totlaTime - interval;
        xVController.timerLable.tag  =xVController.totlaTime;
        
        [xVController  reStart];
        
        date1=nil;
        
        if (xVController.arcBgView.layer.sublayers.count>=2) {
            
            [[xVController.arcBgView.layer.sublayers lastObject]removeFromSuperlayer];
            
        }
        
        [xVController drawRound];
        
        xVController.arcBgView.alpha =1;
    }
    
    UINavigationController *navigationC = (UINavigationController *) tabViewC.viewControllers[0];
    
    ProgramViewController *rootVc =(ProgramViewController *)navigationC.topViewController;
    
    rootVc.canReload = YES;
    [rootVc.tabelView reloadData];
     
   

     */
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.


    //[xController cancleNote];
    

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
 
    
    
    [MyAudioTool removeSound:musicName];

    
    if (alertView.tag == 1001)
    {
        //可能window的rootViewController错误
        UITabBarController *tabViewC = (UITabBarController *)self.window.rootViewController;
        NSLog(@"%@",tabViewC.viewControllers);
        
        UINavigationController *navigationC = (UINavigationController *) tabViewC.viewControllers[0];
        
        ProgramViewController *rootVc =(ProgramViewController *)navigationC.topViewController;
        
        rootVc.canReload = YES;
        
        [rootVc.tabelView reloadData];
        
    }
    
    if (alertView.tag == 1002)
    {
        
#warning ----dateCount update----------
        

    }
    
    if (alertView.tag == 1003)
    {
        
    }
    

     


    
}

#pragma mark - countTime

/*
-(void)makeDelay:(NSTimer *)timer
{
//    UILocalNotification * notification = (UILocalNotification *)timer.userInfo;
    
//    NSDictionary * noteDic = notification.userInfo;
    
    self.noteNumber = 1;
    
    delay = NO;

}
 
 */


@end
