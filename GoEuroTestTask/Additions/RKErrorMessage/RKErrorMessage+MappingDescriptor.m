//
//  RKErrorMessage+MappingDescriptor.m
//  GoEuroTestTask
//
//  Created by Eugene Pavluk on 2/17/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "RKErrorMessage+MappingDescriptor.h"
#import <RestKit/Network.h>
#import <RestKit/ObjectMapping.h>

@implementation RKErrorMessage (MappingDescriptor)

+ (void)setupMapping
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    
    NSMutableIndexSet *statusCodes = [[NSMutableIndexSet alloc] init];
    [statusCodes addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    [statusCodes addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassServerError)];
    
    RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                                                         method:RKRequestMethodAny
                                                                                    pathPattern:nil
                                                                                        keyPath:nil
                                                                                    statusCodes:statusCodes];
    
    [manager addResponseDescriptor:errorDescriptor];
}

@end
