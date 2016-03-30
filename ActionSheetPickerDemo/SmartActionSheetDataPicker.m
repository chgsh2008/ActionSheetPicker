//
//  SmartActionSheetDataPicker.m
//  ActionSheetPickerDemo
//
//  Created by Kevin on 16/3/29.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import "SmartActionSheetDataPicker.h"

@interface SmartActionSheetDataPicker()

@property (nonatomic, copy) NSMutableDictionary *userSelectedComponentRow;
@property (nonatomic, copy) NSMutableDictionary *childShowDictionary;

@end



@implementation SmartActionSheetDataPicker


/**
 *  Show picker
 *
 *  @param title            title
 *  @param initialSelection initial selection data
 *  @param doneBlock        done block
 *  @param cancelBlock      cancle block
 *  @param view             uiview which the picker will show near it. if you can't provide it, please push it nil and use controllerView. (in my case, it is the webview, so I can't provide the uiview, but I can provide self.webView)
 *
 *  @return
 */
+ (instancetype)showPickerWithTitle:(NSString *)title
                   initialSelection:(NSArray *)initialSelection
                          doneBlock:(SmartActionSheetDataDoneBlock)doneBlock
                        cancelBlock:(SmartActionSheetDataCancelBlock)cancelBlock
                             origin:(UIView*)view
{
    SmartActionSheetDataPicker *picker = [[SmartActionSheetDataPicker alloc] initWithTitle:title initialSelection:initialSelection doneBlock:doneBlock cancelBlock:cancelBlock origin:view];
    
    return picker;
}


/**
 *  Show picker
 *
 *  @param title            title
 *  @param initialSelection initial selection data
 *  @param doneBlock        done block
 *  @param cancelBlock      cancle block
 *  @param view             uiview which the picker will show near it. if you can't provide it, please push it nil and use controllerView. (in my case, it is the webview, so I can't provide the uiview, but I can provide self.webView)
 *
 *  @return
 */
- (instancetype)initWithTitle:(NSString *)title
             initialSelection:(NSArray *)initialSelection
                    doneBlock:(SmartActionSheetDataDoneBlock)doneBlock
                  cancelBlock:(SmartActionSheetDataCancelBlock)cancelBlock
                       origin:(UIView*)view
{
    self = [self initWithTitle:title initialSelection:initialSelection target:nil action:nil origin:view cancelAction:nil];
    if (self) {
        self.onSmartActionSheetDone = doneBlock;
        self.onSmartActionSheetCancel = cancelBlock;
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title initialSelection:(NSArray *)initialSelection target:(id)target action:(SEL)action origin:(id)origin cancelAction:(SEL)cancelAction
{
    self = [super initWithTarget:target successAction:action cancelAction:cancelAction origin:origin];
    if (self) {
        self.defaultSelected = initialSelection;
        self.title = title;
        self.searchKeyElement = OnlyByCodeElement;
    }
    return self;
}


#pragma mark - private method


/**
 *  get child data in current dictionary
 *
 *  @param dictioinary current dictionary
 *  @param component   component
 *  @param row         row
 *  @param result      callback block
 */
-(void)getChildData:(NSArray *)dictioinary inComponent:(NSInteger)component inRow:(NSInteger)row result:(void(^)(NSArray *childData, NSInteger numberOfChild, NSDictionary *rowData))result
{
    if ([dictioinary isKindOfClass:[NSDictionary class]]) {
        NSLog(@"this is a dictionary");
    }else if ([dictioinary isKindOfClass:[NSArray class]]){
        if (dictioinary.count > 0 && dictioinary.count > row) {
            NSDictionary *dict = [dictioinary objectAtIndex:row];
            NSArray *childArray = [dict objectForKey:ChildElement];
            if (result!=nil) {
                result(childArray, childArray.count, dict);
            }
        }else if (dictioinary.count == 0){
            if (result!=nil) {
                result(dictioinary, dictioinary.count, nil);
            }
        }else{
            NSLog(@"Error: the count of dictionary is large than selected row");
        }
    }else if ([dictioinary isKindOfClass:[NSString class]] || [dictioinary isKindOfClass:[NSNumber class]]){
        NSLog(@"this is a string");
    }
}

/**
 *  find the child data in parent dictionary
 *
 *  @param parentDict parent dictionary
 *  @param keyDict    the key dictionary which match to find child
 *  @param result     callback block
 */
-(void)findChild:(NSArray *)parentDict keyDict:(NSDictionary *)keyDict result:(void(^)(NSArray *childData, NSInteger rowIndex, NSDictionary *rowData))result
{
    NSString *keyCode = [keyDict objectForKey:CodeElement];
    NSString *keyName = [keyDict objectForKey:NameElement];
    if ([parentDict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"this is a dictionary");
    }else if ([parentDict isKindOfClass:[NSArray class]]){
        if (parentDict.count > 0) {
            for (int i = 0; i < parentDict.count; i++) {
                NSDictionary *tmpDict = [parentDict objectAtIndex:i];
                NSString *tmpCode = [tmpDict objectForKey:CodeElement];
                NSString *tmpName = [tmpDict objectForKey:NameElement];
                BOOL isExist = NO;
                if (_searchKeyElement == OnlyByCodeElement) {
                    if ([keyCode isEqual:tmpCode]) {
                        isExist = YES;
                    }
                }else if (_searchKeyElement == OnlyByNameElement) {
                    if ([keyName isEqual:tmpName]) {
                        isExist = YES;
                    }
                }else if (_searchKeyElement == BothCodeAndNameElement){
                    if ([keyName isEqual:tmpName] && [keyCode isEqual:tmpCode]) {
                        isExist = YES;
                    }
                }
                if (isExist) {
                    if (result != nil) {
                        result([tmpDict objectForKey:ChildElement], i, tmpDict);
                    }
                    break;
                }
            }
        }else if (parentDict.count == 0){
            if (result != nil) {
                result([NSArray array], 0, nil);
            }
        }else{
            NSLog(@"Error: the count of dictionary is large than selected row");
        }
    }
}

/**
 *  init default selected
 *
 *  @param pv
 */
-(void)initDefaultSelected:(UIPickerView *)pv{
    __block NSArray *data = _dataSource;
    __weak typeof(self) weakSelf = self;
    if (_defaultSelected != nil && [_defaultSelected isKindOfClass:[NSArray class]] && _defaultSelected.count > 0) {
        //have default selected
        NSInteger index = 0;
        NSString *empty = @"";
        while (index < _numberOfComponents) {
            NSDictionary *emptyDict = [NSDictionary dictionaryWithObjectsAndKeys:empty, CodeElement, empty, NameElement, nil];
            [_userSelected addObject:emptyDict];
            index++;
        }
        for (int i = 0; i < _numberOfComponents; i++) {
            NSDictionary *defaultDict = nil;
            if (i < _defaultSelected.count) {
                defaultDict = [_defaultSelected objectAtIndex:i];
            }
            [self findChild:data keyDict:defaultDict result:^(NSArray *childData, NSInteger rowIndex, NSDictionary *rowData) {
                data = childData;
                NSDictionary *defaultStr = [NSDictionary dictionaryWithObjectsAndKeys:[rowData objectForKey:CodeElement], CodeElement, [rowData objectForKey:NameElement], NameElement, nil];
                [weakSelf.userSelected replaceObjectAtIndex:i withObject:defaultStr];
                if (i+1<_numberOfComponents) {
                    [weakSelf.childShowDictionary setObject:childData forKey:@(i+1)];
                }
                [pv selectRow:rowIndex inComponent:i animated:YES];
                [pv reloadAllComponents];
            }];
        }
    }else{
        //set default select value
        for (int i = 0; i < _numberOfComponents; i++) {
            [self getChildData:data inComponent:i inRow:0 result:^(NSArray *childData, NSInteger numberOfChild, NSDictionary *rowData) {
                data = childData;
                NSDictionary *defaultStr = [NSDictionary dictionaryWithObjectsAndKeys:[rowData objectForKey:CodeElement], CodeElement, [rowData objectForKey:NameElement], NameElement, nil];
                NSLog(@"defalt component：%d, value：%@",i, [defaultStr objectForKey:NameElement]);
                [weakSelf.userSelected addObject:defaultStr];
                [weakSelf.userSelectedComponentRow setObject:@(0) forKey:@(i)];
                if (i+1<_numberOfComponents) {
                    [weakSelf.childShowDictionary setObject:childData forKey:@(i+1)];
                }
            }];
        }
        
    }
}

-(void)setUserSelectedValue:(NSDictionary *)selectedDict inComponent:(NSInteger)component
{
    NSDictionary *defaultStr = [NSDictionary dictionaryWithObjectsAndKeys:[selectedDict objectForKey:CodeElement], CodeElement, [selectedDict objectForKey:NameElement], NameElement, nil];
    [self.userSelected replaceObjectAtIndex:component withObject:defaultStr];
}

#pragma mark - AbstractActionSheetPicker fulfilment

- (UIView *)configuredPickerView
{
    _userSelectedComponentRow = [NSMutableDictionary dictionary];
    _childShowDictionary = [NSMutableDictionary dictionary];
    _userSelected = [NSMutableArray array];
    
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *pv = [[UIPickerView alloc] initWithFrame:pickerFrame];
    self.pickerView = pv;
// Default to our delegate being the picker's delegate and datasource
//    pv.delegate = _delegate;
//    pv.dataSource = _delegate;
    pv.delegate = self;
    pv.dataSource = self;
    pv.showsSelectionIndicator = YES;
    [self initDefaultSelected:pv];
    
    return pv;
}


/**
 *  callback when touch done.
 *
 *  @param target
 *  @param action
 *  @param origin
 */
- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)action origin:(id)origin
{
    if (self.onSmartActionSheetDone)
    {
        self.onSmartActionSheetDone(self, _userSelected, origin);
        return;
    }
}

/**
 *  callback when touch cancel
 *
 *  @param target
 *  @param action
 *  @param origin
 */
- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin
{
    if (self.onSmartActionSheetCancel)
    {
        self.onSmartActionSheetCancel(self);
        return;
    }
    //    else
    //        if ( target && cancelAction && [target respondsToSelector:cancelAction] )
    //        {
    //#pragma clang diagnostic push
    //#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    //            [target performSelector:cancelAction withObject:origin];
    //#pragma clang diagnostic pop
    //        }
}


#pragma mark - UIPickerViewDelegate and UIPickerViewDataSource fulfilment

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (_numberOfComponents < 0) {
        _numberOfComponents = 0;
    }
    return _numberOfComponents;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger number = 0;
    if (component == 0) {
        number = [_dataSource count];
    }else{
        NSArray *array = [_childShowDictionary objectForKey:@(component)];
        number = array.count;
    }
    return number;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        CGRect frame = CGRectZero;
        CGFloat totalWidth = pickerView.frame.size.width - 20;
        CGFloat otherSize = (totalWidth )/(self.numberOfComponents);
        frame = CGRectMake(0.0, 0.0, otherSize, 32);
        
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        if ([pickerLabel respondsToSelector:@selector(setMinimumScaleFactor:)])
            [pickerLabel setMinimumScaleFactor:0.5];
        [pickerLabel setAdjustsFontSizeToFitWidth:YES];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:20]];
    }
    
    __block NSString *text = @"";
    NSArray *array = [_childShowDictionary objectForKey:@(component)];
    if (_childShowDictionary.count <= 0 || component == 0 || array == nil) {
        [self getChildData:_dataSource inComponent:component inRow:row result:^(NSArray *childData, NSInteger numberOfChild, NSDictionary *rowData) {
            text = [rowData objectForKey:NameElement];
        }];
    }else{
        if (array.count > row) {
            NSDictionary *value = [array objectAtIndex:row];
            if ([value isKindOfClass:[NSString class]]) {
//                text = value;
            }else if ([value isKindOfClass:[NSDictionary class]]){
                text = [value objectForKey:NameElement];
            }
        }else{
            NSLog(@"超出界线, 列：%ld, 行：%ld", component, row);
        }
    }
    
    NSLog(@"component：%ld, row：%ld, content: %@", (long)component, (long)row, text);
    if ([text isKindOfClass:[NSString class]] && text.length > 0) {
        pickerLabel.text = text;
    }
    
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    __block NSArray *array = nil;
    __weak typeof (self) weakSelf = self;
    if (component > 0) {
        NSArray *arrTmp = [_childShowDictionary objectForKey:@(component)];
        if (arrTmp.count > row) {
            NSDictionary *dictTmp = [arrTmp objectAtIndex:row];
            array = [dictTmp objectForKey:ChildElement];
            [_childShowDictionary setObject:array forKey:@(component+1)];
            [self setUserSelectedValue:dictTmp inComponent:component];
        }
    }else{
        [self getChildData:_dataSource inComponent:component inRow:row result:^(NSArray *childData, NSInteger numberOfChild, NSDictionary *rowData) {
            [weakSelf.childShowDictionary setObject:childData forKey:@(component+1)];
            array = childData;
            [weakSelf setUserSelectedValue:rowData inComponent:component];
        }];
    }
    
    NSInteger reloadComponent = component+1;
    if (reloadComponent < _numberOfComponents && array.count > 0) {
        [self setUserSelectedValue:[array objectAtIndex:0] inComponent:reloadComponent];
    }else{
        [self setUserSelectedValue:[NSDictionary dictionary] inComponent:reloadComponent];
    }
    
    //circulate reload child components
    while (reloadComponent < _numberOfComponents) {
        [pickerView reloadComponent:reloadComponent];
        [pickerView selectRow:0 inComponent:reloadComponent animated:YES];
        
        reloadComponent++;
        if (reloadComponent < _numberOfComponents) {
            [self getChildData:array inComponent:reloadComponent inRow:0 result:^(NSArray *childData, NSInteger numberOfChild, NSDictionary *rowData) {
                [weakSelf.childShowDictionary setObject:childData forKey:@(reloadComponent)];
                array = childData;
                if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
                    [weakSelf setUserSelectedValue:[array objectAtIndex:0] inComponent:reloadComponent];
                }else{
                    [weakSelf setUserSelectedValue:[NSDictionary dictionary] inComponent:reloadComponent];
                }
            }];
        }
    }
}



@end
