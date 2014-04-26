//
//  PersistentData.h
//  GoEuroTestTask
//
//  Created by Eugene Pavluk on 4/26/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PersistentData : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * lastDate;

+ (PersistentData*)persistentData;

@end
