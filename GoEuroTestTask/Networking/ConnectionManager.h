//
//  ConnectionManager.h
//  GoEuroTestTask
//
//  Created by Eugene Pavluk on 2/12/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/ObjectMapping/RKHTTPUtilities.h>

@class RKObjectRequestOperation;
@class RKMappingResult;

typedef void (^completionBlock) (RKObjectRequestOperation *operation, RKMappingResult *mappingResult);

typedef void (^failureBlock) (RKObjectRequestOperation *operation, NSError *error);

@interface ConnectionManager : NSObject

+ (ConnectionManager*)sharedInstance;

- (void)sendRequestWithPath:(NSString*)path
               onCompletion:(completionBlock)success
                  onFailure:(failureBlock)failure;

@end
