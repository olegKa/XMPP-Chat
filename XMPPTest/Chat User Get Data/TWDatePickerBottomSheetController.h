//
//  TWDatePickerBottomSheetController.h
//  XMPPTest
//
//  Created by OLEG KALININ on 27.05.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "MaterialBottomSheet.h"
#import "TWDatePickerViewController.h"

typedef NS_ENUM(NSInteger, TWDatePickerMode) {
    kDatePickerModeDate,
    kDatePickerModePeriod,
};

typedef NS_ENUM(NSInteger, TWDatePickerStage) {
    kDatePickerStageUnknown,
    kDatePickerStageDateFrom,
    kDatePickerStageDateTo
};

@protocol TWDatePickerSelectorDataSource;

NS_ASSUME_NONNULL_BEGIN

typedef void (^DatePickerSelectorBlock) (BOOL cancel, NSArray <NSDate*> * _Nullable dates);

@interface TWDatePickerBottomSheetController : MDCBottomSheetController

@property (nonatomic, copy) DatePickerSelectorBlock datePickerHandler;
@property (nonatomic, assign) TWDatePickerMode mode;
@property (nonatomic, weak) id <TWDatePickerSelectorDataSource> dataSource;
@property (nonatomic, copy) NSString *dateFormat;

+ (TWDatePickerBottomSheetController *)datePickerController;
- (void)gotoStage:(TWDatePickerStage)stage;

@end

NS_ASSUME_NONNULL_END

@protocol TWDatePickerSelectorDataSource <NSObject>

@optional
- (NSDate *)datePickerController:(TWDatePickerBottomSheetController *)controller dateForStage:(TWDatePickerStage)stage;

@end
