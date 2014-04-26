//
//  Place.h
//  GoEuroTestTask
//
//  Created by Eugene Pavluk on 4/26/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MLPAutoCompletionObject.h>

@class RKEntityMapping;

@interface Place : NSManagedObject <MLPAutoCompletionObject>

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * place_id;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * place_type;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * inEurope;
@property (nonatomic, retain) NSString * countryCode;

+ (RKEntityMapping*)mapping;

@end
