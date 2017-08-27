//
//  ViewController.m
//  ActionSheetPickerDemo
//
//  Created by Kevin on 16/3/16.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import "ViewController.h"



static NSString *const CityPickerCodeElement   = @"Code";
static NSString *const CityPickerNameElement   = @"Name";
static NSString *const CityPickerChildElement    = @"Child";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _textField.text = @"4";
    
}
- (IBAction)buttton_touch:(id)sender {
    NSInteger depth = 1;
    NSDictionary *dictData = nil;
    NSString *resource=@"";
    depth = [_textField.text integerValue];
    
    if (depth == 1) {
        resource = @"data1.json";
    }else if (depth == 2){
        resource = @"data2.json";
    }else if (depth == 3){
        resource = @"data3.json";
    }else if (depth == 4){
        resource = @"data4.json";
    }else if (depth == 5){
        resource = @"data5.json";
    }
    
    NSString *file = [[NSBundle mainBundle] pathForResource:resource ofType:nil];
    dictData = [self getContentWithPath:file];
    NSDictionary *dictData2 = [dictData objectForKey:@"dataSource"];
    if (dictData2 == nil) {
        NSLog(@"读取文件转换出错");
        return;
    }
//    ActionSheetDataPicker *picker=[ActionSheetDataPicker showPickerWithTitle:@"测试" initialSelection:nil doneBlock:^(ActionSheetDataPicker *picker, id selectedData, id origin) {
//        NSLog(@"Done ...");
//        NSLog(@"User select: %@", selectedData);
//    } cancelBlock:^(ActionSheetDataPicker *picker) {
//        NSLog(@"Cancel ...");
//    } origin:self.view];
    ActionSheetDataPicker *picker= [[ActionSheetDataPicker alloc] initWithTitle:@"选择" initialSelection:nil doneBlock:^(ActionSheetDataPicker *picker, id selectedData, id origin) {
        NSLog(@"User select: ");
        NSArray *array = (NSArray *)selectedData;
        for (int i = 0; i < array.count; i++) {
            NSLog(@"%d %@",i, [array objectAtIndex:i]);
        }
    } cancelBlock:^(ActionSheetDataPicker *picker) {
        NSLog(@"Cancel ...");
    } origin:nil];
    
    picker.controllerView = self.view;
    picker.defaultSelected = @[@"北京市",@"海淀区"];
    picker.dataSource = dictData2;
    picker.tapDismissAction = TapActionCancel;
    picker.numberOfComponents = depth;
    [picker showActionSheetPicker];
}


- (IBAction)smartJsonBtn_Touch:(id)sender {
    NSInteger depth = 1;
    NSDictionary *dictData = nil;
    NSString *resource=@"";
    depth = [_textField.text integerValue];
    
    if (depth == 1) {
        resource = @"smartJson1.json";
    }else if (depth == 2){
        resource = @"smartJson2.json";
    }else if (depth == 3){
        resource = @"smartJson3.json";
    }else if (depth == 4){
        resource = @"smartJson4.json";
    }else if (depth == 5){
        resource = @"smartJson5.json";
    }
    
    NSString *file = [[NSBundle mainBundle] pathForResource:resource ofType:nil];
    dictData = [self getContentWithPath:file];
    NSDictionary *dictData2 = [dictData objectForKey:@"dataSource"];
    if (dictData2 == nil) {
        NSLog(@"读取文件转换出错");
        return;
    }
    
    SmartActionSheetDataPicker *picker = [SmartActionSheetDataPicker smartPickerWithTitle:@"城市选择器" codeElement:CityPickerCodeElement nameElement:CityPickerNameElement childElement:CityPickerChildElement initialSelection:nil doneBlock:^(SmartActionSheetDataPicker *picker, id selectedData, id origin) {
        NSArray *array = (NSArray *)selectedData;
        NSLog(@"User select: ");
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dict = [array objectAtIndex:i];
            NSLog(@"%d %@ %@", i, [dict objectForKey:CityPickerCodeElement], [dict objectForKey:CityPickerNameElement]);
        }
    } cancelBlock:^(SmartActionSheetDataPicker *picker) {
        
    } origin:sender];
    
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"5", CityPickerCodeElement, @"南沙群岛", CityPickerNameElement, nil];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"4-2", CityPickerCodeElement, @"株洲市", CityPickerNameElement, nil];
    NSArray *defaultArr = [NSArray arrayWithObjects:dict1, nil];
    picker.controllerView = self.view;
    picker.defaultSelected = defaultArr;
    picker.dataSource = dictData2;
    picker.tapDismissAction = TapActionCancel;
    picker.numberOfComponents = depth;
    picker.searchKeyElement = OnlyByCodeElement;
    [picker showActionSheetPicker];
    
}

-(NSDictionary *)getContentWithPath:(NSString *)file{
    NSDictionary *dictData = nil;
//    NSError *error;
//    NSString *file = [[NSBundle mainBundle] pathForResource:@"data1.json" ofType:nil];
//    NSString * content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:file];
    NSError *error;
    dictData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//    NSLog(@"json:%@",dictData);
    
    return dictData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
