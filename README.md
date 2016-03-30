# ActionSheetPicker
this is a smart actionsheetpicker 
it could auto generate 1-n components.

there are two ways base on different data. in the project, I have write the two demo how to use it.

1. ActionSheetDataPicker

this is a demo to use it:

    ActionSheetDataPicker *picker= [[ActionSheetDataPicker alloc] initWithTitle:@"选择" initialSelection:nil     doneBlock:^(ActionSheetDataPicker *picker, id selectedData, id origin) {
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



2. SmartActionSheetDataPicker

this is a demo to use it:

    SmartActionSheetDataPicker *picker = [SmartActionSheetDataPicker showPickerWithTitle:@"Address Picker" initialSelection:nil doneBlock:^(SmartActionSheetDataPicker *picker, id selectedData, id origin) {
        NSArray *array = (NSArray *)selectedData;
        NSLog(@"User select: ");
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dict = [array objectAtIndex:i];
            NSLog(@"%d %@", i, [dict objectForKey:NameElement]);
        }
    } cancelBlock:^(SmartActionSheetDataPicker *picker) {
        
    } origin:sender];
    
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"5", CodeElement, @"南沙群岛", NameElement, nil];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"4-2", CodeElement, @"株洲市", NameElement, nil];
    NSArray *defaultArr = [NSArray arrayWithObjects:dict1, nil];
    picker.controllerView = self.view;
    picker.defaultSelected = defaultArr;
    picker.dataSource = dictData2;
    picker.tapDismissAction = TapActionCancel;
    picker.numberOfComponents = depth;
    picker.searchKeyElement = OnlyByCodeElement;
    [picker showActionSheetPicker];


welcome to contact me if you have any questions.
