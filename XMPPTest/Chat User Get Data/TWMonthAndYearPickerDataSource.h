//
//  TWMonthAndYearPickerDataSource.h
//  XMPPTest
//
//  Created by OLEG KALININ on 06.06.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWCustomPickerDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface TWMonthAndYearPickerDataSource : TWCustomPickerDataSource

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *maximumDate;
@property (nonatomic, assign) NSInteger minYear;        // 1900 by default


@end

NS_ASSUME_NONNULL_END
