//
//  KCDataPicker.h
//  ActionSheetPickerDemo
//
//  Created by Kevin on 16/3/17.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractActionSheetPicker.h"

@class ActionSheetDataPicker;

typedef void(^ActionDataDoneBlock)(ActionSheetDataPicker *picker, id selectedData, id origin); //
typedef void(^ActionDataCancelBlock)(ActionSheetDataPicker *picker);

@interface ActionSheetDataPicker : AbstractActionSheetPicker<UIPickerViewDelegate, UIPickerViewDataSource>
{
//    NSArray *_firstArray;
}


@property (nonatomic, copy) ActionDataDoneBlock onActionSheetDone;
@property (nonatomic, copy) ActionDataCancelBlock onActionSheetCancel;
@property (nonatomic, assign) NSInteger numberOfComponents;
@property (nonatomic, copy) NSDictionary *dataSource;
@property (nonatomic, copy) NSArray *defaultSelected;
@property (nonatomic, copy) NSMutableArray *userSelected;
@property (nonatomic, copy) NSMutableDictionary *userSelectedComponentRow;
//@property (nonatomic, copy) NSMutableArray *nextShowArray;
@property (nonatomic, copy) NSMutableDictionary *childShowDictionary;


//+ (instancetype)showPickerWithTitle:(NSString *)title initialSelection:(NSDictionary *)initialSelection target:(id)target action:(SEL)action origin:(id)origin;


//+ (instancetype)showPickerWithTitle:(NSString *)title initialSelection:(NSDictionary *)initialSelection target:(id)target action:(SEL)action origin:(id)origin cancelAction:(SEL)cancelAction;


+ (instancetype)showPickerWithTitle:(NSString *)title
                       initialSelection:(NSDictionary *)initialSelection
                          doneBlock:(ActionDataDoneBlock)doneBlock
                        cancelBlock:(ActionDataCancelBlock)cancelBlock
                             origin:(UIView*)view;


- (instancetype)initWithTitle:(NSString *)title
                 initialSelection:(NSArray *)initialSelection
                    doneBlock:(ActionDataDoneBlock)doneBlock
                  cancelBlock:(ActionDataCancelBlock)cancelBlock
                       origin:(UIView*)view;


//- (instancetype)initWithTitle:(NSString *)title initialSelection:(NSDictionary *)initialSelection target:(id)target action:(SEL)action origin:(id)origin cancelAction:(SEL)cancelAction;


@end
