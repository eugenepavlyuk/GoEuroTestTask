//
//  GoEuroModel.m
//  GoEuroTestTask
//
//  Created by Eugene Pavluk on 2/26/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "GoEuroModel.h"
#import "Place.h"
#import <RestKit/Network.h>
#import <RestKit/CoreData.h>
#import <RestKit/ObjectMapping.h>
#import <MagicalRecord/NSManagedObjectContext+MagicalSaves.h>
#import "PersistentData.h"
#import <NSManagedObject+MagicalFinders.h>
#import <CoreLocation/CoreLocation.h>
#import <ZFHaversine.h>

@interface GoEuroModel()

@property (nonatomic, strong) PersistentData *persistentData;

@end

@implementation GoEuroModel
{
    NSString *previousSearchTerm;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self setupMapping];
    }
    
    return self;
}


/**
 *  This method sends request to the server with searchTerm
 *
 *  @param searchTerm a string that places contain
 *  @param success    block for successful results
 *  @param failure    block for failure
 */
- (void)findPlacesForSearchTerm:(NSString*)searchTerm
               withSuccessBlock:(completionModelBlock)success
                      onFailure:(failureModelBlock)failure
{
    if (previousSearchTerm)
    {
        // we must cancel all previous requests, because it's time to send new request
        RKObjectManager *manager = [RKObjectManager sharedManager];
        
        NSString *encodedSearchTerm = [previousSearchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager cancelAllObjectRequestOperationsWithMethod:RKRequestMethodGET
                                        matchingPathPattern:encodedSearchTerm];
    }
    
    previousSearchTerm = searchTerm;
    
    if (![searchTerm length])
    {
        success(@[]);
        
        return ;
    }
    
    NSString *encodedSearchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendRequestWithPath:encodedSearchTerm
                                               onCompletion:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                   
                                                   NSMutableArray *places = [mappingResult.array mutableCopy];
                                                   
                                                   // sort all places by direction to user
                                                   
                                                   [places sortUsingComparator:^NSComparisonResult(Place *place1, Place *place2) {
                                                       
                                                       ZFHaversine *distanceToPlace1 = [[ZFHaversine alloc] initWithLatitude1:[place1.latitude floatValue]
                                                                                                                     longitude1:[place1.longitude floatValue]
                                                                                                                      latitude2:[self.persistentData.latitude floatValue]
                                                                                                                     longitude2:[self.persistentData.longitude floatValue]];
                                                       [distanceToPlace1 setFormulaMode:sphericalFormula];
                                                       
                                                       CGFloat distance1 = [distanceToPlace1 kilos];
                                                       
                                                       ZFHaversine *distanceToPlace2 = [[ZFHaversine alloc] initWithLatitude1:[place2.latitude floatValue]
                                                                                                                   longitude1:[place2.longitude floatValue]
                                                                                                                    latitude2:[self.persistentData.latitude floatValue]
                                                                                                                   longitude2:[self.persistentData.longitude floatValue]];
                                                       
                                                       [distanceToPlace2 setFormulaMode:sphericalFormula];
                                                       CGFloat distance2 = [distanceToPlace2 kilos];
                                                       
                                                       return (distance1 < distance2) ? NSOrderedAscending : NSOrderedDescending;
                                                   }];
                                                   
                                                   success(places);
                                                   
                                               } onFailure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                   
                                                   failure(error);
                                                   
                                               }];
}

// lazy loading of persistentData
- (PersistentData*)persistentData
{
    if (!_persistentData)
    {
        _persistentData = [PersistentData MR_findFirst];
        
        if (!_persistentData)
        {
            _persistentData = [PersistentData persistentData];
        }
    }
    
    return _persistentData;
}

/**
 *  Setting up the mapping for Place entities
 */
- (void)setupMapping
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKEntityMapping *placeMapping = [Place mapping];
    
    NSMutableIndexSet *statusCodes = [[NSMutableIndexSet alloc] init];
    [statusCodes addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:placeMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:statusCodes];
    [manager addResponseDescriptor:responseDescriptor];
}

@end
