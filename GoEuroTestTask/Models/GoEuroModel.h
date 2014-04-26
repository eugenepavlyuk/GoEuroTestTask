//
//  GoEuroModel.h
//  GoEuroTestTask
//
//  Created by Eugene Pavluk on 2/26/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "ConnectionManager.h"

typedef void (^completionModelBlock) (NSArray *places);

typedef void (^failureModelBlock) (NSError *error);

@interface GoEuroModel : NSObject

/**
 *  This method sends request to the server with searchTerm
 *
 *  @param searchTerm a string that places contain
 *  @param success    block for successful results
 *  @param failure    block for failure
 */
- (void)findPlacesForSearchTerm:(NSString*)searchTerm
               withSuccessBlock:(completionModelBlock)success
                      onFailure:(failureModelBlock)failure;

@end
