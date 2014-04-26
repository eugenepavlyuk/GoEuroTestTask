//
//  Place.m
//  GoEuroTestTask
//
//  Created by Eugene Pavluk on 4/26/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "Place.h"
#import <RestKit/Network.h>
#import <RestKit/CoreData.h>

static NSString * kTypeKey              =   @"type";
static NSString * kNameKey              =   @"name";
static NSString * kFullnameKey          =   @"fullName";
static NSString * kPlaceIdKey           =   @"place_id";
static NSString * kIdKey                =   @"_id";
static NSString * kPlaceTypeKey         =   @"place_type";
static NSString * k_TypeKey             =   @"_type";
static NSString * kLatitudeKey          =   @"latitude";
static NSString * kLongitudeKey         =   @"longitude";

@implementation Place

@dynamic name;
@dynamic place_id;
@dynamic type;
@dynamic place_type;
@dynamic latitude;
@dynamic longitude;
@dynamic country;
@dynamic fullName;
@dynamic inEurope;
@dynamic countryCode;

+ (RKEntityMapping*)mapping
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(self)
                                                   inManagedObjectStore:manager.managedObjectStore];
        
    [mapping addAttributeMappingsFromDictionary:@{kNameKey                          :   kNameKey,
                                                  kFullnameKey                      :   kFullnameKey,
                                                  k_TypeKey                         :   kPlaceTypeKey,
                                                  kIdKey                            :   kPlaceIdKey,
                                                  kTypeKey                          :   kTypeKey,
                                                  @"geo_position.latitude"          :   kLatitudeKey,
                                                  @"geo_position.longitude"         :   kLongitudeKey
                                                  }];
    
    mapping.identificationAttributes = @[kPlaceIdKey];
    
    return mapping;
}

- (NSString*)autocompleteString
{
    return self.name;
}

@end
