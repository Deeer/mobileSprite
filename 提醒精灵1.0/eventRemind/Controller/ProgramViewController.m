//
//  ProgramViewController.m
//  提醒精灵1.0
//
//  Created by zjsruxxxy3 on 14-9-24.
//  Copyright (c) 2014年 wrcj. All rights reserved.
//

#import "ProgramViewController.h"
#import "Define.h"
#import "remainModel.h"
#import "MusicModel.h"
#import "remainCell.h"
#import "altView.h"
#import "MyAudioTool.h"
#import "TimesModle.h"
#import "Menu.h"

#import "EventDataTool.h"
#import "AccessTokenTool.h"

typedef enum timeInterval{
    onceTime = 1,
    everyday,
    everyweek
    
}TimeInterval;

@interface ProgramViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIAlertViewDelegate,
remainCellDelegate,alterViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIGestureRecognizerDelegate
>

{

    
    BOOL timeClick,dingClick,groupClick;
    
    BOOL isSlide;
    
    BOOL canDelete;
    
    BOOL canAdd;
    
    BOOL clickModel;
    
    BOOL groupSeg;
    NSDictionary *inputDic;
    NSMutableArray *inputArray;
    
    NSMutableArray *dicArray;
    
    NSString *idenity;
    NSString *oldIdenity;
    
    NSString * s;
    
    
    NSDate *clickDate;
    
    NSString *clickMusic;
    NSString *musicNum;
    
    int musicTime;
    int breakTime;
    
    NSString *clickText;
    NSString *oldText;
    
    BOOL clickOnce;
    BOOL clickNew;
    
    int Interval;
    
    NSArray *sortDescriptors; // 数组排序
    NSArray *sorterArray;
    
    NSString *groupInfo;
    NSString *filePath;
    
    remainModel * NewremainModle;
    
    NSDictionary *dicOldNote;
    
    NSMutableArray * mymusicArray;
    
    NSMutableArray *groupArray;
    
    NSMutableArray *groupTitleArray;
    int theRow;
    int theSection;
    CGRect headViewRec;
    
    
}



@property(nonatomic,weak)IBOutlet UITextField *textField;

@property(nonatomic,weak)IBOutlet UIDatePicker *datePicker;

@property(nonatomic,weak)IBOutlet UIPickerView *musicPicker;

@property (weak, nonatomic) IBOutlet UIPickerView *groupPicker;

@property(nonatomic,weak)IBOutlet UIButton *time;

@property(nonatomic,weak)IBOutlet UIButton *ding;

@property (weak, nonatomic) IBOutlet UIButton *group;

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *bgView;

@property(nonatomic,weak)altView *alterView;




- (IBAction)clickTime;

- (IBAction)clickDing;

-(IBAction)clickGroup;

-(IBAction)clickReload:(UIButton *)sender;

-(IBAction)removeNote:(id)sender;

-(void)groupWithArray:(NSMutableArray*)remainArray;




@end

@implementation ProgramViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
//    [self addFilePath];
    
//    [self loadLocalFile];
    
    [self viewDidLoadState];
    
   
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}




-(void)viewDidLoadState
{
    
    
    mymusicArray = [NSMutableArray array];
    
    groupArray =[NSMutableArray array];
    //self.bgView.backgroundColor =
    self.time.superview.backgroundColor =
    [UIColor colorWithRed:70.0/255.0 green:180.0/255.0 blue:240.0/255.0 alpha:.6];
    for (int j = 0; j<12; j++)
    {
        NSString *string = [NSString stringWithFormat:@"%02d.caf",j+1];
        
        [mymusicArray addObject:string];
    }

    
    NSMutableAttributedString * placeHold2 = [[NSMutableAttributedString alloc]initWithString:@"    点击添加提醒"];
   
    
//    [UIFont boldSystemFontOfSize:10]
    [placeHold2 addAttribute:NSFontAttributeName value: [UIFont fontWithName:@"Helvetica-BoldOblique" size:10] range:NSMakeRange(0, placeHold2.length)];
    
    [placeHold2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:.9] range:NSMakeRange(0, placeHold2.length)];
    
    self.textField.attributedPlaceholder = placeHold2;
//
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.textField.delegate = self;
    self.musicPicker.delegate = self;
    self.musicPicker.dataSource = self;
    self.groupPicker.delegate=self;
    self.groupPicker.dataSource=self;
    headViewRec= self.HeadView.frame;

    /**
     *  table穿透效果
     *
     *  @param 0   x
     *  @param -40 y
     *
     *  @return
     */
    
    self.tabelView.contentOffset =  CGPointMake(0, 0);
    self.tabelView.contentInset = UIEdgeInsetsMake(-5, 0, 0, 0);
    
//    self.group.enabled=NO;
    self.musicPicker.backgroundColor = [UIColor colorWithRed:.26 green:.58 blue:.83 alpha:.93];

    self.groupPicker.backgroundColor = [UIColor colorWithRed:.26 green:.58 blue:.83 alpha:.93];

    
    self.datePicker.backgroundColor = [UIColor colorWithRed:.27 green:.58 blue:.84 alpha:.89];

    self.datePicker.date = [NSDate dateWithTimeIntervalSinceNow:60*2];
    
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60*1];
    
//    UIView *input = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
//    self.mus.inputView = input;
    
    [self.musicPicker selectRow:self.musicModelArray.count/2 inComponent:1 animated:NO];
    [self remaindArrays];
    [self.tabelView reloadData];
    /**
     * 待改进
     */
    groupTitleArray =[NSMutableArray arrayWithObjects:@"A",@"B",@"C",nil];
    
    [self.groupPicker selectRow:0 inComponent:0 animated:NO];
    
    canDelete = YES;
    
    Interval = 1;
    
    MusicModel *model = self.musicModelArray[self.musicModelArray.count/2];
    
    clickMusic = model.music;
    musicTime = model.time;
    
    inputDic = [NSDictionary dictionary];
    inputArray = [NSMutableArray array];
    dicOldNote = [NSDictionary dictionary];
    
    
    // 字典排序专用
    sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:theDate ascending:YES]];
    
    // 数组排序专用
    NSSortDescriptor *sorterD = [NSSortDescriptor sortDescriptorWithKey:theDate ascending:YES];
    sorterArray = [[NSArray alloc]initWithObjects:&sorterD count:1];
    
    
    

}

-(void)loadInit
{
    self.time.enabled = YES;
    self.ding.enabled = NO;
    self.group.enabled =NO;
    self.tabelView.allowsSelection = YES;
    self.datePicker.date = [NSDate dateWithTimeIntervalSinceNow:120];
    groupInfo =nil;
    ///
    [self.musicPicker selectRow:self.musicModelArray.count/2 inComponent:1 animated:NO];
    [self.musicPicker selectRow:0 inComponent:0 animated:NO];
    [self.groupPicker selectRow:0 inComponent:0 animated:NO];
    
    self.textField.enabled = YES;

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
    
    if (!canDelete)
    {
        [self performSelector:@selector(makeSwipeR:) withObject:nil];
    }
    
    /*
    CGRect tempt = self.datePicker.frame;
    
    CGRect tempt2 = self.musicPicker.frame;
    
    if (tempt.origin.y == 357)
    {
        tempt.origin.y = 568;
        
        [UIView animateWithDuration:AnimateTimePicker animations:^{
            
//            self.musicPicker.frame = tempt2;
            self.datePicker.frame = tempt;
            
        } completion:^(BOOL finished)
        {
            
        }];
    }
    if (tempt2.origin.y == 357)
    {
        tempt2.origin.y = 568;
        [UIView animateWithDuration:AnimateTimePicker animations:^{
            
            self.musicPicker.frame = tempt2;
//            self.datePicker.frame = tempt;
            
        } completion:^(BOOL finished)
         {
             
         }];

    }
    
    [self loadInit];
    canDelete = YES;
    */
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
}




- (void)clickTime
{
    CGRect tempt = self.datePicker.frame;
    
    CGRect tempt2 = self.musicPicker.frame;
    
    tempt2.origin.y = 357;

    
    if (!timeClick)
    {
        tempt.origin.y = 357;
        timeClick = YES;
        
        
        
    }else
    {
        tempt.origin.y = 568;
        timeClick = NO;
        
        self.time.enabled = NO;
        self.ding.enabled = YES;
        
        
        clickDate = self.datePicker.date;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        
        dateFormatter.dateFormat = @"MMddHHmm";
        
        idenity = [dateFormatter stringFromDate:clickDate];
        
        
    [UIView animateWithDuration:AnimateTimePicker animations:^{
        
        self.musicPicker.frame = tempt2;
        dingClick = YES;
        canAdd = YES;
        
        }];

    }
    [UIView animateWithDuration:AnimateTimePicker animations:^{
        
        self.datePicker.frame = tempt;
        
    } completion:^(BOOL finished) {
        

    }];
    
    

}

-(void)makeAdds
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"确定添加么" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
//    temp3.origin.y = 568;
    
    [actionSheet showInView:self.view];
    
    canDelete = YES;
}



- (void)clickDing
{
    CGRect tempt = self.musicPicker.frame;
    CGRect tempt2 = self.groupPicker.frame;
    
    
    self.group.enabled=YES;

    tempt2.origin.y = 406;

    
    if (!dingClick)
    {
        tempt.origin.y = 357;
        dingClick = YES;
    }else
    {
        tempt.origin.y = 568;
        dingClick = NO;
        
        self.ding.enabled = NO;
        
    }
    
    [UIView animateWithDuration:AnimateTimePicker animations:^{
        
        self.musicPicker.frame = tempt;
        
    }];
    [UIView animateWithDuration:AnimateTimePicker animations:^{
        groupSeg =YES;
        groupClick=YES;
        [self.groupPicker reloadAllComponents];
        
        self.groupPicker.frame = tempt2;
        
    }];

    
    [MyAudioTool removeSound:clickMusic];

}


-(void)clickGroup
{
    
    
    
    CGRect temp3 =self.datePicker.frame;
    
    if (!groupClick)
    {
        temp3.origin.y = 406;
        
        groupClick = YES;
    }else
    {
        temp3.origin.y = 568;
        groupClick = NO;
        canAdd = YES;
        
        
       
        
    }
    
    [UIView animateWithDuration:AnimateTimePicker animations:^{
        
        self.groupPicker.frame = temp3;
        self.group.enabled=NO;
    }completion:^(BOOL finished) {
            if (canAdd) {
                
                [self makeAdds];
                canAdd=NO;
            }
        
        
    }];
    
    
    
    
}




//-(IBAction)clickReload:(UIButton *)sender
//{
//    
//    [self.tabelView reloadData];
//    
//    NSLog(@"%@",[UIApplication sharedApplication].scheduledLocalNotifications);
//    
//    NSLog(@"%lu",(unsigned long)[UIApplication sharedApplication].scheduledLocalNotifications.count);
//    
//}

#pragma mark - add&remove note

-(void)removeNote:(id)sender
{
    [[UIApplication sharedApplication]cancelAllLocalNotifications];

}

-(void)addNoteWith:(remainModel *)model
{
    
    for (no = 1; no<theNoteNum; no++)
    {
        
        UILocalNotification *localNote = [[UILocalNotification alloc]init];
        
        localNote.timeZone = [NSTimeZone defaultTimeZone];
        
        localNote.soundName = model.music;
        

        if (no <2)
        {
            localNote.alertAction = @"slideGo";
            localNote.alertBody = model.text;
            localNote.applicationIconBadgeNumber = 1;

        }else
        {
            localNote.alertAction = nil;
            localNote.alertBody = nil;
        }
        
        
        localNote.fireDate = [NSDate dateWithTimeInterval:(musicTime+.5)*(no-1)+.5 sinceDate:model.date];
        
        
        if (model.timesNum == everyday)
        {
            localNote.repeatInterval = NSCalendarUnitDay;
        }else if (model.timesNum == everyweek)
        {
            localNote.repeatInterval = NSCalendarUnitWeekday;
        }
        
        
        NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:inputDic];
        
        [userDic setObject:[NSNumber numberWithInt:musicTime] forKey:theMusicTime];
        
        [userDic setObject:[NSNumber numberWithInt:no] forKey:theNum];
        
        [userDic setObject:@"message" forKey:RemaindIdenity];
        
        localNote.userInfo = userDic;
        
        [[UIApplication sharedApplication]scheduleLocalNotification:localNote];
        
    }

}

-(void)removeOldNote:(NSString *)offNote
{
    for (UILocalNotification *oldNote in [UIApplication sharedApplication].scheduledLocalNotifications)
    {
        
        
        dicOldNote = nil;
        dicOldNote = oldNote.userInfo;
        
        if ([dicOldNote[theIdenity] isEqualToString:offNote])
        {
            [[UIApplication sharedApplication]cancelLocalNotification:oldNote];
            
        }else
        {
            
        }
        
    }
}

#pragma mark-RemainCellDelegate

-(void)changedSwithInRemainCell:(remainCell *)cell
{

    theRow = (int)[self.tabelView indexPathForCell:cell].row;
    theSection =(int)[self.tabelView indexPathForCell:cell ].section;
    
    NSMutableArray *arr =groupArray[theSection];
    remainModel *remain = arr[theRow];
    
    
    if ([cell.models.date compare:[NSDate date]]<0 && remain.timesNum == onceTime)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"事件已过时，请修改时间或者删除。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
        return;

    }
    
//    NSLog(@"%@---%@",remain,cell.models);
    //&& cell.models.timesNum != onceTime
    if (cell.models.isHandleOff == NO && cell.rectSwitch.on == NO)
    {
        
        cell.models.handOff = YES;
        
    }else
    {
        cell.models.handOff = NO;
    }
    
    cell.models.New = cell.rectSwitch.on;

    inputDic = @{theDate: cell.models.date,theIdenity: cell.models.idenity,theMusic: cell.models.music,theNew: [NSNumber numberWithBool:cell.models.New],theText:cell.models.text,theTimesNum:[NSNumber numberWithInt:cell.models.timesNum],theHandOff:[NSNumber numberWithBool:cell.models.handOff],theInfo:cell.models.groupInfo};
    
    remainModel * newModel = [remainModel remainModelWithDic:inputDic];
    
//    NSMutableArray *arr =groupArray[theSection];
    [arr replaceObjectAtIndex:[self.tabelView indexPathForCell:cell].row withObject:newModel];
    [groupArray replaceObjectAtIndex:theSection withObject:arr];
//    [self.remaindArrays replaceObjectAtIndex:[self.tabelView indexPathForCell:cell].row
//                                  withObject:newModel];

    if (newModel.isNew)
    {
        [self addNoteWith:cell.models];
        
    }else
    {
        [self removeOldNote:cell.models.idenity];

    }
    
#warning modify data -1
    
//    [dicArray replaceObjectAtIndex:theRow withObject:inputDic];
    NSLog(@"%@---%@",remain,cell.models);

//    [dicArray writeToFile:filePath atomically:YES];
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:theRow inSection:theSection];
    NSArray *array = @[indexpath];

//    [self.tabelView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationMiddle];
    NSLog(@"===%@",groupArray);
    [self.tabelView reloadData];
    [EventDataTool modifyDBModel:cell.models];
    
    
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:theRow inSection:theSection];

    
    remainCell *cell = (remainCell *)[self.tabelView cellForRowAtIndexPath:indexpath];
    
//    if (cell.models.timesNum != onceTime)
//    {
//        cell.rectSwitch.on = YES;
//    }else
//    {
//        
//    }
    
    cell.rectSwitch.on = NO;
    
    NSLog(@"dismissSwitch");
    
}


#pragma mark-actionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
        
    {
        if (groupInfo==nil) {
            groupInfo =groupTitleArray[0];
        }
        
        groupSeg=NO;
        clickNew = 1;
        
        
        
        NSNumber *news = [NSNumber numberWithBool:clickNew];
        
        inputDic = @{theDate: clickDate,theIdenity: idenity,theMusic: clickMusic,theNew: news,theText:clickText,theTimesNum:[NSNumber numberWithInt:Interval],theHandOff:[NSNumber numberWithBool:NO],theInfo:groupInfo};
        
        /**
         *  添加新模型数据
         */
        
        NewremainModle = nil;
        
        NewremainModle = [remainModel remainModelWithDic:inputDic];
        
//        for (remainModel * oldmodel in self.remaindArrays)
//        {
//            if ([NewremainModle.idenity isEqualToString:oldmodel.idenity])
//            {
//                UIAlertView * sameAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"提醒事件的时间重复" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                
//                [sameAlert show];
//                
//                return;
//            }
//        }
        
        /**
         *  添加入表
         */
        [EventDataTool addDBModel:NewremainModle];
        
        
        
        [_remaindArrays addObject:NewremainModle];
        
        
        [_remaindArrays sortUsingDescriptors:sorterArray];
    
      //  [dicArray addObject:inputDic];
        
        [self addNoteWith:NewremainModle];

        /*
        [dicArray sortUsingDescriptors:sortDescriptors];
        
        [dicArray writeToFile:filePath atomically:YES];
         */
        [self groupWithArray:_remaindArrays];
        [self.tabelView reloadData];
    }
    
    [self loadInit];
    
    [MyAudioTool removeSound:clickMusic];
    
    self.textField.text = nil;
    
//    self.HeadView.frame = CGRectMake(0, 64, 450, 58);
    self.HeadView.frame =headViewRec;
}

#pragma mark- textFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{

    UIButton *cover = [[UIButton alloc]init];
    
    cover.frame = CGRectMake(0, 122, 320, 446);
    
    cover.backgroundColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:.33];
    
    cover.alpha = 1;
    cover.tag = 103;
    
    [self.view addSubview:cover];
    
    [cover addTarget:self action:@selector(removeCover:) forControlEvents:UIControlEventTouchUpInside];
   
    self.group.enabled=NO;
    self.ding.enabled=NO;
    
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    
    clickText = textField.text;
    
    [self addSwipeLeft];
    [self addSwipeRight];
    [self loadInit];
    
    UIView *cover = [self.view viewWithTag:103];
    
    [cover removeFromSuperview];
    
    return YES;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.textField resignFirstResponder];
    
    CGRect tempFrame = self.HeadView.frame;
    
    tempFrame.origin.x = -90;
    
    [UIView animateWithDuration:AnimateTimeGesture animations:^{
        
        self.HeadView.frame = tempFrame;
    }];
    
    canDelete = NO;
    
    [self clickTime];
    
    self.tabelView.allowsSelection = NO;
    
    self.textField.enabled = NO;
    
    
    
    return YES;
    
}

#pragma mark-textView

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    CGRect tempt = self.datePicker.frame;
    CGRect tempt2 = self.musicPicker.frame;
    
    if (tempt.origin.y == 357 || tempt2.origin.y == 357)
    {
        tempt.origin.y = 568;
        tempt2.origin.y = 568;
        
        [UIView animateWithDuration:AnimateTimePicker animations:^{
            self.datePicker.frame = tempt;
            self.musicPicker.frame = tempt2;
            
        } completion:^(BOOL finished) {
            
            [MyAudioTool removeSound:clickMusic];
        }];
    }
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    clickText = self.alterView.textView.text;
    
    self.alterView.models.text = clickText;
    
    textView.editable = NO;
    
}

#pragma mark-pickerViewDelegate
/*
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return 60;
    }else
    {
        return 30;
        
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return 30;
    }else
    {
        return 60;
    }
}
*/



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
        if (groupSeg ==YES) {
        return 1;
    
    }else
    {
    return 2;
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (groupSeg ==YES) {
        return groupTitleArray.count;
    }else{
    if (component == 1)
    {
        return self.musicModelArray.count;
    }
    
//    return self.countsArray.count;
    
    return self.timesArray.count;
    }
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (groupSeg ==YES) {
        return  groupTitleArray[row];
    }else
    {
    if (component == 1)
    {
        MusicModel * model = self.musicModelArray[row];
        
        NSString *music = model.music;
        
        return music;
    }
    
    
//    TimesModle *timesModel = self.timesArray[row];
    
    switch (row)
    {
        case 0:
             s = @"never";
            break;
        case 1:
            s = @"dayly";
            break;
        default:
            s = @"weekly";
            break;
    }
    
//    NSString * stirng = [timesModel.times stringByAppendingString:s];
    
    return s;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (groupSeg==YES) {
        
        
        switch (row) {
            case 0:
                groupInfo=groupTitleArray[row];
                break;
            case 1:
                groupInfo=groupTitleArray[row];
                break;
            case 2:
                groupInfo=groupTitleArray[row];
                break;
        }
        
        NSLog(@"+=+%@",groupInfo);
        
    }else{
    
    
    
    
    if (component == 0)
    {
        if (row == 0)
        {
            Interval = onceTime;
        }else if (row == 1)
        {
            Interval = everyday;
        }else
        {
            Interval = everyweek;
            
        }
        
//        NSLog(@"%d",Interval);


        
    }
    
    if (component == 1)
    {
        MusicModel * model = self.musicModelArray[row];
        
        NSMutableArray * musciArray = [NSMutableArray arrayWithArray:self.musicModelArray];
        
        [musciArray removeObject:model];
        
        
        for (MusicModel * musicMo in musciArray)
        {
            [MyAudioTool removeSound:musicMo.music];

        }
        
        clickMusic = model.music;
        
        musicTime = model.time;
        
        musicNum = model.no;
        
        
        [MyAudioTool playSound:clickMusic];
        
//        NSLog(@"%@",clickMusic);
        
    }
    
    self.tabelView.contentOffset =  CGPointMake(0, -58);
    }
}

#pragma mark-tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"group.count::%d",groupArray.count);
    return groupArray.count;

}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSLog(@"section;%d",section);
    NSMutableArray *arr =groupArray[section];
    if (arr.count!=0) {
    remainModel *model =arr[0];
        return model.groupInfo;
    }else
    {
        return nil;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arr =groupArray[section];
    
    return arr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    remainCell *cell = [remainCell remainCellToTableView:tableView];
    
    cell.delegate = self;
    NSMutableArray *arr =groupArray[indexPath.section];
    remainModel *remain = arr[indexPath.row];
    
    cell.models = remain;
    
    NSDateFormatter *dateF = [[NSDateFormatter alloc]init];
    dateF.dateFormat = DateFormatter;
    
    NSString *transDate = [dateF stringFromDate:remain.date];
    
    cell.textView.text = remain.text;
    
    cell.dateLabel.text = transDate;
    
    cell.musicLabel.text = [NSString stringWithFormat:@"%@",remain.music];
    
    MusicModel * musciM = self.musicModelArray[[musicNum intValue]];
    
    cell.musicNo = musicNum;
    
    cell.musicModels = musciM;
    
    if (remain.timesNum == onceTime)
    {

        [cell.repeatButton setImage:[UIImage imageNamed:@"never_icon"] forState:UIControlStateNormal];
        
        
    }else if (remain.timesNum == everyday)
    {

        [cell.repeatButton setImage:[UIImage imageNamed:@"day2_icon"] forState:UIControlStateNormal];


    }else
    {
        [cell.repeatButton setImage:[UIImage imageNamed:@"week_icon"] forState:UIControlStateNormal];

    }
    

    cell.rectSwitch.on = remain.New;
    
    if (self.canReload)
    {

        
        if ([cell.models.date compare:[NSDate date]]<0)
        {
            cell.rectSwitch.on  = NO;
            
//            NSLog(@"%D",cell.models.handOff);

            if (remain.timesNum != onceTime && cell.models.isHandleOff == NO)
            {
                cell.rectSwitch.on = YES;
//                NSLog(@"%D",cell.models.isHandleOff);

//                return cell;
            }else
            {
                cell.rectSwitch.on = NO;
            }
            

            
            remain.New = cell.rectSwitch.on;
            
            inputDic = @{theDate: remain.date,theIdenity: remain.idenity,theMusic: remain.music,theNew: [NSNumber numberWithBool:remain.New],theText:remain.text,theTimesNum:[NSNumber numberWithInt:remain.timesNum],theHandOff:[NSNumber numberWithBool:remain.handOff],theInfo:remain.groupInfo};
            
            remainModel * newModel = [remainModel remainModelWithDic:inputDic];
            
            NSMutableArray *tempGArr=groupArray[indexPath.section];
            
            [tempGArr replaceObjectAtIndex:indexPath.row withObject:newModel];
            [groupArray replaceObjectAtIndex:indexPath.section withObject:tempGArr];
            
            
//            [self.remaindArrays replaceObjectAtIndex:indexPath.row withObject:newModel];
            
            
#warning modify date  if nessery?
            [EventDataTool modifyDBModel:newModel];
//            [dicArray replaceObjectAtIndex:indexPath.row withObject:inputDic];
            
//            [dicArray writeToFile:filePath atomically:YES];
//            NSLog(@"%@---%@",remain,cell.models);

        }

    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([dicArray count]-1 == indexPath.row)
    {
        self.canReload = NO;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    [self.view endEditing:YES];
    
    if (canDelete)
    {
        UIButton *cover = [[UIButton alloc]init];
        cover.frame = self.view.bounds;
        cover.backgroundColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:.33];
        cover.alpha = 0;
        cover.tag = 101;
        
        [cover addTarget:self action:@selector(removeCover:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view insertSubview:cover aboveSubview:self.HeadView];
        
        altView *alterView = [altView loadAlterView];
        
        self.alterView = alterView;
        
        alterView.delegate = self;
        
        alterView.theRow =(int)indexPath.row;
        
        remainCell *cell = (remainCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        alterView.models = cell.models;
        
        alterView.noRead = cell.models.New;
        
        oldIdenity = [NSString stringWithString:alterView.models.idenity];

        alterView.frame=CGRectMake(0, 188, 320,160);
        
        alterView.layer.cornerRadius=8;
        
        alterView.alpha = 0;
        
        oldText = cell.textView.text;
        
        alterView.textView.text = oldText;
        
        alterView.textView.delegate = self;
        
        [self.view insertSubview:alterView aboveSubview:cover];

        
        [UIView animateWithDuration:.318 animations:^{
            
            cover.alpha = 0.33;
            alterView.alpha = 1;
            
        } completion:^(BOOL finished) {
            
        }];
        
        self.datePicker.date = alterView.models.date;
        
        [self.musicPicker selectRow:[mymusicArray indexOfObject:alterView.models.music] inComponent:1 animated:NO];
        
         int b;
        if (alterView.models.timesNum == onceTime)
        {
            b = 0;
        }else if (alterView.models.timesNum == everyday)
        {
            b = 1;
        }else
        {
            b = 2;
        }
        
        [self.musicPicker selectRow: b inComponent:0 animated:NO];
        
    }
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (canDelete == NO)
    {
        return UITableViewCellEditingStyleNone;

    }
    
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_remaindArrays>0)
    {
        
        NSMutableArray *arr =groupArray[indexPath.section];
        
        
        remainModel *deleteModel = arr[indexPath.row];
        
        [arr removeObjectAtIndex:indexPath.row];
        
        [groupArray replaceObjectAtIndex:indexPath.section withObject:arr];
        [_remaindArrays removeObject:deleteModel];
//        [self.remaindArrays removeObjectAtIndex:indexPath.row];
        
//        [dicArray removeObjectAtIndex:indexPath.row];
        
        /**
         *  delete  datebase RECORD
         */
        [EventDataTool removeDBModel:deleteModel];
        
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        NSArray *indexs = @[index];
        
//        [tableView deleteRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationLeft];
        [self.tabelView reloadData];
        
        for (UILocalNotification *oldNote in [UIApplication sharedApplication].scheduledLocalNotifications)
        {
            
            dicOldNote = nil;
            dicOldNote = oldNote.userInfo;
            
            if ([dicOldNote[theIdenity] isEqualToString:deleteModel.idenity])
            {
                [[UIApplication sharedApplication]cancelLocalNotification:oldNote];
            }
            
        }
        
        
//        [dicArray writeToFile:filePath atomically:YES];
        

    }
//    NSLog(@"_remaindArrays%@",_remaindArrays);
//    NSLog(@"groupArray%@",groupArray);
}



#pragma mark - alterDelegate

-(void)alterViewDidRepeatIntheAlterView:(altView *)alterView
{
    
}

-(void)alterViewDidDateIntheAlterView:(altView *)alterView
{
    [self.view endEditing:YES];
    CGRect tempt = self.datePicker.frame;
    
    CGRect tempt2 = self.musicPicker.frame;
    
    if (tempt2.origin.y == 357)
    {
        tempt2.origin.y = 568;
        
    }
    if (tempt.origin.y == 568)
    {
        tempt.origin.y = 357;
        
    }else
    {
        tempt.origin.y = 568;
    }
    
    [UIView animateWithDuration:AnimateTimePicker animations:^{
        
        self.musicPicker.frame = tempt2;
        self.datePicker.frame = tempt;
        
    } completion:^(BOOL finished) {
        
    }];
    
    clickDate = self.datePicker.date;
    


    

    alterView.dateChange = YES;
    [MyAudioTool removeSound:clickMusic];
    
    
}

-(void)alterViewDidMusicIntheAlterView:(altView *)alterView
{
    [self.view endEditing:YES];
    
    CGRect tempt = self.musicPicker.frame;
    
    CGRect tempt2 = self.datePicker.frame;
    
    if (tempt2.origin.y == 357)
    {
        tempt2.origin.y = 568;
        
    }
    if (tempt.origin.y == 568)
    {
        tempt.origin.y = 357;
        
    }else
    {
        tempt.origin.y = 568;
    }
    
    [UIView animateWithDuration:AnimateTimePicker animations:^{
        
        self.datePicker.frame = tempt2;
        self.musicPicker.frame = tempt;
        
    } completion:^(BOOL finished) {
        
    }];
    
    alterView.musicChange = YES;
    
    [MyAudioTool removeSound:clickMusic];
    
    
}

-(void)alterViewDidEditIntheAlterView:(altView *)alterView
{
    alterView.textView.editable = YES;
    
    if ([alterView.textView canBecomeFirstResponder])
    {
        [alterView.textView becomeFirstResponder];
    }
    
    
}

-(void)alterViewDidMailIntheAlterView:(altView *)alterView
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat = @"MM.dd HH:mm ";
    
    NSString *mydate = [dateFormatter stringFromDate:alterView.models.date];
    NSString *myText = alterView.models.text;
    
    NSString *endText = @" 别忘咯:)";
    
    NSMutableString * body = [NSMutableString stringWithString:mydate];
    
    [body appendString:myText];
    [body appendString:endText];

    
    
    if ([MFMailComposeViewController canSendMail])
        // The device can send email.
    {
        [self displayMailComposerSheet:body];
        
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"设备不支持邮件功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];

    }
    
}


-(void)alterViewDidSmsIntheAlterView:(altView *)alterView
{
    NSLog(@"%s",__func__);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat = @"MM.dd HH:mm ";
    
    NSString *mydate = [dateFormatter stringFromDate:alterView.models.date];
    NSString *myText = alterView.models.text;
    
    NSString *endText = @" 别忘咯:)";
    
    NSMutableString * body = [NSMutableString stringWithString:mydate];
    
    [body appendString:myText];
    [body appendString:endText];
    
    if ([MFMessageComposeViewController canSendText])
        // The device can send email.
    {
        [self displaySMSComposerSheet:body];
        
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"设备不支持短信功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        
    }

}


-(void)alterViewDidFinishIntheAlterView2:(altView *)alterView
{
    
    
    [self.view endEditing:YES];
    
    CGRect tempt = self.musicPicker.frame;
    CGRect tempt2 = self.datePicker.frame;
    
    tempt.origin.y = 568;
    tempt2.origin.y = 568;
    
    
    UIButton * cover = (UIButton *)[self.view viewWithTag:101];
    
    [UIView animateWithDuration:.318 animations:^{
        alterView.alpha = 0;
        cover.alpha = 0;
        self.datePicker.frame = tempt2;
        self.musicPicker.frame = tempt;
        
    } completion:^(BOOL finished) {
        
        [alterView removeFromSuperview];
        
        [cover removeFromSuperview];
        
    }];
    
    //    NSLog(@"%@",alterView.models);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MMddHHmm";
    
    
    if (alterView.noRead)
    {
        [self removeOldNote:alterView.models.idenity];
    }
    
    if (alterView.dateChange)
    {
        alterView.models.date = self.datePicker.date;
        
        //        NSLog(@"%@----%@",self.datePicker.date,alterView.models.date);
        
        alterView.models.idenity = [dateFormatter stringFromDate:alterView.models.date];
        
    }
    
    
    
    
    if (alterView.musicChange)
    {
        alterView.models.music = clickMusic;
        
        if (Interval == onceTime && [alterView.models.date compare:[NSDate date]] <0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"事件已过时，请修改时间或者删除。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            
            [alert show];
            
            
            [MyAudioTool removeSound:clickMusic];
            
            return;
            
        }else
        {
            alterView.models.timesNum = Interval;
            
        }
        
        
    }
    
    
    alterView.musicChange = NO;
    alterView.dateChange = NO;
    
    
    NSNumber *news = [NSNumber numberWithBool:alterView.noRead];
    
    NSNumber  *timesNums = [NSNumber numberWithInt:alterView.models.timesNum];
    
    
    inputDic = @{theDate: alterView.models.date,theIdenity: alterView.models.idenity,theMusic: alterView.models.music,theNew: news,theText:alterView.models.text,theTimesNum:timesNums,theHandOff:[NSNumber numberWithBool:alterView.models.handOff],theInfo:alterView.models.groupInfo};
    
    remainModel * modeled = [remainModel remainModelWithDic:inputDic];
    
    
    if (alterView.noRead)
    {
        [self addNoteWith:modeled];
    }
    
    /**
     *  reloadRow
     */
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:alterView.theRow inSection:alterView.theRow];
    NSArray *array = @[indexpath];
    
    [self.tabelView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    
    [self.remaindArrays replaceObjectAtIndex:alterView.theRow withObject:modeled];
    
    [self.remaindArrays sortUsingDescriptors:sorterArray];
    
#warning modify date -3
    
    //    [dicArray replaceObjectAtIndex:alterView.theRow withObject:inputDic];
    
    //    [dicArray writeToFile:filePath atomically:YES];
    
    //    [dicArray sortUsingDescriptors:sortDescriptors];
    
    NSLog(@"%@---",alterView.models);
  
    [EventDataTool modifyDBModel:alterView.models];
    
    /**
     *  cell select
     */
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.alterView.theRow inSection:self.alterView.theSection];
    
    remainCell * cell = (remainCell *)[self.tabelView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%@---%@",alterView.models,cell.models);

    [cell setSelected:NO animated:NO];
    
    [MyAudioTool removeSound:cell.models.music];
    
    [self.tabelView reloadData];

}



#pragma mark mail&sms func
- (void)displayMailComposerSheet:(NSString *)text
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"来自小伙伴的app提醒"];
	
	// Set up recipients
    
//	NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
    
//	NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    
//	NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
	
//	[picker setToRecipients:toRecipients];
//	[picker setCcRecipients:ccRecipients];
//	[picker setBccRecipients:bccRecipients];
	
    
	// Attach an image to the email
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
//	NSData *myData = [NSData dataWithContentsOfFile:path];
//	[picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy"];
	
    
	// Fill out the email body text
//	NSString *emailBody = @"It is raining in sunny alifornia!";
    
    NSString *emailBody = text;
    
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentViewController:picker animated:YES completion:NULL];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //	self.feedbackMsg.hidden = NO;
	// Notifies users about errors associated with the interface
    
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)displaySMSComposerSheet:(NSString *)text
{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    
	picker.messageComposeDelegate = self;
	
    // You can specify one or more preconfigured recipients.  The user has
    // the option to remove or add recipients from the message composer view
    // controller.
    /* picker.recipients = @[@"Phone number here"]; */
    
    // You can specify the initial message text that will appear in the message
    // composer view controller.
    
    picker.body = text;
    
	[self presentViewController:picker animated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)removeCover:(UIButton *)sender
{
    
    [self.view endEditing:YES];
    
    CGRect tempt = self.musicPicker.frame;
    CGRect tempt2 = self.datePicker.frame;
    
    tempt.origin.y = 568;
    tempt2.origin.y = 568;
    
    
    [UIView animateWithDuration:.318 animations:^{
        
        sender.alpha = 0;
        self.datePicker.frame = tempt2;
        self.musicPicker.frame = tempt;
        

        if (sender.tag == 101)
        {
            self.alterView.alpha = 0;
        }else if(sender.tag == 102)
        {
            
        }
        
    } completion:^(BOOL finished) {
        
        if (sender.tag == 101)
        {
            [self.alterView removeFromSuperview];
            self.alterView.textView.text = oldText;

        }else if(sender.tag == 102)
        {
        }
        
        
        [sender removeFromSuperview];

        
        
    }];
    
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.alterView.theRow inSection:self.alterView.theSection];
    
    remainCell * cell = (remainCell *)[self.tabelView cellForRowAtIndexPath:indexPath];
    
    [cell setSelected:NO animated:NO];
    
    
    [MyAudioTool removeSound:clickMusic];

    
}


#pragma mark-filePath

-(void)loadLocalFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath])
    {
        NSLog(@"creatNew");
        
        NSString *aimPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"myRemaind.plist"];
        
        NSString *datePath = [[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"myRemaind.plist"];
        
        NSError *error;
        
        if ([fileManager copyItemAtPath:datePath toPath:aimPath error:&error])
        {
            NSLog(@"copy success");
        }
        else
        {
            NSLog(@"%@",error);
        }
        
    }else
    {
        NSLog(@"already exit");
    }

}

-(void)addFilePath
{
    NSString *home = NSHomeDirectory();
    
    NSString * docPath = [home stringByAppendingPathComponent:@"Documents"];
    
    filePath = [docPath stringByAppendingPathComponent:@"myRemaind.plist"];
    
}

#pragma mark - Model加载

-(NSMutableArray *)remaindArrays
{
    if (_remaindArrays == nil)
    {
        
//        dicArray = [NSMutableArray arrayWithContentsOfFile:filePath];
        
        dicArray = [NSMutableArray arrayWithArray:[EventDataTool allremainModel]];
        
        /*
        NSMutableArray *tempArray = [NSMutableArray array];
        
        for (NSDictionary *dic in dicArray)
        {
            remainModel *remainmodel = [remainModel remainModelWithDic:dic];
            
            
            [tempArray addObject:remainmodel];
            
        }
         */
        
        [dicArray sortUsingDescriptors:sortDescriptors];
        
        _remaindArrays = dicArray;
       
        
        
    }
     [self groupWithArray:_remaindArrays];
    
    return _remaindArrays;
    
}



-(void)groupWithArray:(NSMutableArray*)remainArray
{
//    NSMutableArray *temp =[NSMutableArray array];
    NSMutableArray *saveArr=[NSMutableArray array];

    if (groupArray.count!=0) {
        [groupArray removeAllObjects];

    }
    
    
    for (int i=0 ; i<groupTitleArray.count; i++)
    { NSMutableArray *temp =[NSMutableArray array];
        
        
        #warning possible!
        for (remainModel *model in _remaindArrays )
     {
        
        if ([model.groupInfo isEqualToString:[NSString stringWithFormat:@"%@", groupTitleArray[i]]])
        {
            NSLog(@"%@",groupTitleArray[i]);
            
            [temp addObject:model];
        }
        
     }
       
        if (temp.count!=0) {
            [groupArray addObject:temp];
        }
        
        
    }
    
}


-(NSArray *)musicModelArray
{
    if (_musicModelArray == nil)
    {
        NSString *musicPath = [[NSBundle mainBundle]pathForResource:@"musicModel" ofType:@"plist"];
        
        NSArray *musicDicArray = [NSArray arrayWithContentsOfFile:musicPath];
        
        NSMutableArray *tempArray = [NSMutableArray array];

        
        for (NSDictionary * dic in musicDicArray)
        {
            MusicModel * musicModel = [MusicModel musicModelWithDic:dic];
            
            [tempArray addObject:musicModel];
        }
        
        _musicModelArray = tempArray;
    }
    
    return _musicModelArray;
}

-(NSArray *)timesArray
{
    if (_timesArray == nil)
    {
        NSString *timesPath = [[NSBundle mainBundle]pathForResource:@"remainTimes" ofType:@"plist"];
        NSArray *timesDic = [NSArray arrayWithContentsOfFile:timesPath];
        NSMutableArray * tempArray = [NSMutableArray array];
        
        for (NSDictionary *dic in timesDic)
        {
            TimesModle * timesModel = [TimesModle timesModelWithDic:dic];
            [tempArray addObject:timesModel];
        }
        
        _timesArray = tempArray;
    }
    return _timesArray;
}

-(NSArray *)countsArray
{
    
    if (_countsArray == nil)
    {
        NSString *countPath = [[NSBundle mainBundle]pathForResource:@"CountsList" ofType:@"plist"];
        _countsArray = [NSArray arrayWithContentsOfFile:countPath];
    }
    
    return _countsArray;
    
}

#pragma mark - HeadViewGesture

-(void)addSwipeLeft
{
    
    UISwipeGestureRecognizer *swipeGestureL= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(makeSwipeL:)];
    
    swipeGestureL.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.HeadView addGestureRecognizer:swipeGestureL];
}

-(void)addSwipeRight
{
    UISwipeGestureRecognizer *swipeGestureR= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(makeSwipeR:)];
    
    swipeGestureR.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.HeadView addGestureRecognizer:swipeGestureR];
}

-(void)makeSwipeL:(UIGestureRecognizer *)sender
{
    if (self.textField.text == nil || self.textField.text.length == 0 || canDelete == NO)
    {
        return;
    }
    
    
    CGRect tempFrame = self.HeadView.frame;

    tempFrame.origin.x = -90;
    
    [UIView animateWithDuration:AnimateTimeGesture animations:^{

            self.HeadView.frame = tempFrame;
    }];
   
    canDelete = NO;
    
    
    [self clickTime];
    
    self.tabelView.allowsSelection = NO;
    
    self.textField.enabled = NO;
    
    UIButton *swipeCover = [[UIButton alloc]init];
    
    swipeCover.frame = CGRectMake(0, 123, 320, 284);
    
    swipeCover.backgroundColor = [UIColor clearColor];
    
//    swipeCover.alpha = .1;
//    swipeCover.tag = 101;
    
    [swipeCover addTarget:self action:@selector(removeCover2:) forControlEvents:UIControlEventTouchUpInside];
    
        [self.view addSubview:swipeCover];
    
    
}

-(void)removeCover2:(UIButton *) sender
{
    
    NSLog(@"button");
    if (!canDelete)
    {
        [self performSelector:@selector(makeSwipeR:) withObject:nil];
        NSLog(@"swipe");
    }
    
    [sender removeFromSuperview];
    
    
}

-(void)makeSwipeR:(UIGestureRecognizer *)sender
{
    
    CGRect tempFrame = self.HeadView.frame;
    tempFrame.origin.x = 0;
    
    [UIView animateWithDuration:AnimateTimeGesture animations:^{
        
        self.HeadView.frame = tempFrame;
    }];
    
    canAdd = NO;
    
    if (dingClick)
    {
        [self clickDing];

    }
    
    if (timeClick)
    {
        CGRect tempt = self.datePicker.frame;
        
        tempt.origin.y = 568;
        
        timeClick = NO;
        
        self.time.enabled = NO;
        self.ding.enabled = YES;
        
        clickDate = self.datePicker.date;

        self.time.enabled = YES;
        
        [UIView animateWithDuration:AnimateTimePicker animations:^{
            
            self.datePicker.frame = tempt;
        } completion:^(BOOL finished)
        {
            
        }];
        
    }
    
    [self loadInit];
    
    canDelete = YES;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
