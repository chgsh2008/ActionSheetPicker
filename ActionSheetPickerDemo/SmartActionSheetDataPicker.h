//
//  SmartActionSheetDataPicker.h
//  ActionSheetPickerDemo
//
//  Created by Kevin on 16/3/29.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractActionSheetPicker.h"

static NSString *const CodeElement   = @"Code";
static NSString *const NameElement   = @"Name";
static NSString *const ChildElement    = @"Child";

typedef enum _SearchKeyElement{
    OnlyByCodeElement = 0,
    OnlyByNameElement,
    BothCodeAndNameElement
}SearchKeyElement;


@class SmartActionSheetDataPicker;


typedef void(^SmartActionSheetDataDoneBlock)(SmartActionSheetDataPicker *picker, id selectedData, id origin); //
typedef void(^SmartActionSheetDataCancelBlock)(SmartActionSheetDataPicker *picker);


@interface SmartActionSheetDataPicker : AbstractActionSheetPicker<UIPickerViewDelegate, UIPickerViewDataSource>
{
    
}

@property (nonatomic, copy) SmartActionSheetDataDoneBlock onSmartActionSheetDone;
@property (nonatomic, copy) SmartActionSheetDataCancelBlock onSmartActionSheetCancel;

/**
 *  user pass the default seleced value
 */
@property (nonatomic, copy) NSArray *defaultSelected;

/**
 *  user select the value
 */
@property (nonatomic, copy) NSMutableArray *userSelected;

/**
 *  number of components in picker
 */
@property (nonatomic, assign) NSInteger numberOfComponents;

/**
 *  the data source in picker
 */
@property (nonatomic, copy) NSArray *dataSource;

/**
 *  find the element by key type, default is by OnlyByCodeElement
 */
@property (nonatomic, assign) SearchKeyElement searchKeyElement;


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
                             origin:(UIView*)view;


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
                       origin:(UIView*)view;

@end
