//
//  Device.h
//  SimpleTable
//
//  Created by Radi on 7/2/15.
//
//

#import <Foundation/Foundation.h>

#define deviceModelString(enum) [@[@"iPhone 4S", @"iPhone 5", @"iPhone 5S", @"iPhone 6", @"iPhone 6 +", @"iPad", @"iPad 2", @"iPad Air"] objectAtIndex:enum]
typedef enum : NSUInteger {
    iPhone4S = 0,
    iPhone5,
    iPhone5S,
    iPhone6,
    iPhone6Plus,
    iPad,
    iPad2,
    iPadAir
} DeviceModel;

@interface Device : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) DeviceModel model;
@property (nonatomic, assign) int year;
@property (nonatomic, strong) NSString * manufacturer;

-(instancetype)initWithModel:(DeviceModel) devModel
                        year:(int) devYear
                manufacturer:(NSString *) devManufacturer;

+(id)deviceWithModel:(DeviceModel) devModel
                year:(int) devYear
        manufacturer:(NSString *) devManufacturer;

+ (NSArray *)getInitialDevices;
@end
