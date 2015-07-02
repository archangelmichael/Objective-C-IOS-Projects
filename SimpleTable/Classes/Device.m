//
//  Device.m
//  SimpleTable
//
//  Created by Radi on 7/2/15.
//
//

#import "Device.h"

@implementation Device

-(instancetype)initWithModel:(DeviceModel)devModel
                        year:(int)devYear
                manufacturer:(NSString *)devManufacturer {
    self = [super init];
    if (self) {
        self.title = deviceModelString(devModel);
        self.model = devModel;
        self.year = devYear;
        self.manufacturer = devManufacturer;
    }
    
    return self;
}

+(id)deviceWithModel:(DeviceModel)devModel
                year:(int)devYear
        manufacturer:(NSString *)devManufacturer {
    return [[Device alloc] initWithModel:devModel year:devYear manufacturer:devManufacturer];
}

+(NSArray *)getInitialDevices {
    NSArray * devicesArr = @[
                             [self deviceWithModel:0 year:2013 manufacturer:@"Apple"],
                             [self deviceWithModel:1 year:2014 manufacturer:@"Apple"],
                             [self deviceWithModel:2 year:2014 manufacturer:@"Apple"],
                             [self deviceWithModel:3 year:2014 manufacturer:@"Apple"],
                             [self deviceWithModel:4 year:2014 manufacturer:@"Apple"],
                             ];
    return devicesArr;
}
@end
