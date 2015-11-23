//
//  ViewController.m
//  SelectedMore
//
//  Created by lunarboat on 15/8/19.
//  Copyright (c) 2015年 lunarboat. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSMutableArray *_dataArr;
    NSMutableArray *_saveArr;
    BOOL isSelected[7];
}
@property (weak, nonatomic) IBOutlet UITableView *_tableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _dataArr = [[NSMutableArray alloc]initWithObjects:@"哈里波特",@"阿兹卡班的囚徒",@"魔法石",@"死亡圣器",@"凤凰社",@"圣杯",@"盗墓笔记", nil];
    _saveArr = [[NSMutableArray alloc]init];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(saveData) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [center addObserver:self selector:@selector(putData) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    NSLog(@"%@",_saveArr);
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = [_dataArr objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",_dataArr[indexPath.row]);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!isSelected[indexPath.row]) {
        cell.imageView.image = [UIImage imageNamed:@"star2"];
    }else{
       cell.imageView.image = [UIImage imageNamed:@"star"];
    }
    isSelected[indexPath.row] = !isSelected[indexPath.row];
}

-(void)saveData{
    [_saveArr removeAllObjects];
    for (int i=0; i<_dataArr.count; i++) {
        if (isSelected[i]) {
            [_saveArr addObject:[NSNumber numberWithInt:i]];
        }
    }
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [NSString stringWithFormat:@"%@/data.plist",[documentsPaths objectAtIndex:0]];
    NSLog(@"%@",path);
    [_saveArr writeToFile:path atomically:YES];
    
    
}

-(void)putData{
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *doucumentsPath = [documentsPaths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/data.plist",[documentsPaths objectAtIndex:0]];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    if (arr != nil) {
         _saveArr = [[NSMutableArray alloc]initWithArray:arr];
        [self setCellImage];
    }
    
    //xNSLog(@"%@",_saveArr);
    
    
    
}

-(void)setCellImage{
    for (int i=0; i<_saveArr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[_saveArr objectAtIndex:i]integerValue] inSection:0];
        UITableViewCell *cell = [self._tableView cellForRowAtIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"star2"];
        isSelected[indexPath.row] = YES;
        //NSLog(@"%@",_saveArr);
    }
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
