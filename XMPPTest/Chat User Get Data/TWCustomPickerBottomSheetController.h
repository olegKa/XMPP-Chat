//
//  TWCustomPickerBottomSheetController.h
//  XMPPTest
//
//  Created by OLEG KALININ on 05.06.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "MaterialBottomSheet.h"
#import "TWCustomPickerDataSource.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^CustomPickerSelectorBlock) (BOOL cancel, id _Nullable data);

@interface TWCustomPickerBottomSheetController : MDCBottomSheetController

@property (nonatomic, copy) CustomPickerSelectorBlock customPickerHandler;

+ (instancetype)customPickerControllerWithDataSource:(TWCustomPickerDataSource *)dataSource;

@end

NS_ASSUME_NONNULL_END
