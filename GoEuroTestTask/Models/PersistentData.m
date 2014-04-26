//
//  PersistentData.m
//  GoEuroTestTask
//
//  Created by Eugene Pavluk on 4/26/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "PersistentData.h"
#import <NSManagedObject+MagicalRecord.h>

@implementation PersistentData

@dynamic latitude;
@dynamic longitude;
@dynamic lastDate;

+ (PersistentData*)persistentData
{
    PersistentData *persistentData = [PersistentData MR_createEntity];
    
    persistentData.lastDate = [NSDate date];
    persistentData.latitude = @(52.519974);
    persistentData.longitude = @(13.405028);
    
    return persistentData;
}

@end
