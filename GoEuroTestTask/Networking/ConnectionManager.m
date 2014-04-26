//
//  ConnectionManager.m
//  GoEuroTestTask
//
//  Created by Eugene Pavluk on 2/12/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "ConnectionManager.h"
#import "ConnectionManager+CoreData.h"

#import "RKErrorMessage+MappingDescriptor.h"
#import <RestKit/Network.h>
#import <RestKit/ObjectMapping.h>
#import <RestKit/Support.h>
#import <ReactiveCocoa.h>

//@"https://api.goeuro.com/api/v2/position/suggest/de/Berlin";

static NSString *const kEndPointPath       =   @"https://api.goeuro.com/api/v2/position/suggest/de/";

static NSString *const kGenderKey                   =   @"gender";
static NSString *const kWomen                       =   @"women";
static NSString *const kInitializeBoardsKey         =   @"initializeBoards";
static NSString *const kTrue                        =   @"true";
static NSString *const kInitializeRowsKey           =   @"initializeRows";
static NSString *const kNumberRows                  =   @"1024000";
static NSString *const kPageItemsKey                =   @"pageItems";
static NSString *const kPageKey                     =   @"page";
static NSString *const kFetchLimit                  =   @"10";

static ConnectionManager *connectionManager = nil;

@interface ConnectionManager()


@end


@implementation ConnectionManager
{
    RKObjectManager *objectManager;
}

+ (ConnectionManager*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        connectionManager = [[ConnectionManager alloc] init];
    });
    
    return connectionManager;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
#ifdef DEBUG
        
        RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
#else
        
        RKLogConfigureByName("RestKit/Network", RKLogLevelOff);
        
#endif
        
        [self setupObjectManager];
        [self setupCoreData];
        [self setupMappings];
        
        [RACObserve(objectManager.operationQueue, operationCount) subscribeNext:^(NSNumber *newValue) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:[newValue boolValue]];
        }];
    }
    
    return self;
}

- (void)setupMappings
{
    [RKErrorMessage setupMapping];
}

- (void)setupObjectManager
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kEndPointPath]];
    
    RKObjectManager *manager = [[RKObjectManager alloc] initWithHTTPClient:httpClient];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    [manager.HTTPClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [manager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    [RKObjectManager setSharedManager:manager];
    
    objectManager = manager;
}

- (void)sendRequestWithPath:(NSString*)path
               onCompletion:(completionBlock)success
                  onFailure:(failureBlock)failure
{    
    RKObjectRequestOperation *operation = [objectManager appropriateObjectRequestOperationWithObject:nil
                                                                                              method:RKRequestMethodGET
                                                                                                path:path
                                                                                          parameters:nil];
    
    [operation setCompletionBlockWithSuccess:success failure:failure];
    
    [objectManager enqueueObjectRequestOperation:operation];
}

@end
