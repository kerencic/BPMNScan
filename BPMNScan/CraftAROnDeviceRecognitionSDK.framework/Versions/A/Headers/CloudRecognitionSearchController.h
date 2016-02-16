//
//  CloudRecognitionSearchController.h
//  CraftARCloudRecognition
//
//  Created by Luis Martinell Andreu on 12/11/15.
//  Copyright © 2015 Luis Martinell Andreu. All rights reserved.
//

#import "BaseSearchController.h"

@class CraftARCloudRecognition;

@interface CloudRecognitionSearchController : BaseSearchController

- (id) initWithCloudIR: (CraftARCloudRecognition*) cloudIR;

/**
 * Set the maximum number of search requests per second to be sent in Finder Mode.
 * @param searchesPerSecond should be a value greater than 0 and not higher than 2.0
 * The default value is 2.0
 */
- (void) setMaxSearchesPerSecond: (float) searchesPerSecond;

/**
 * In Finder Mode, whether to allow searcg requests to be accumulated in a queue
 * or wait for the request in progress to finish before sending a new one.
 * False by default.
 */
@property (nonatomic, readwrite) BOOL mAccumulateSearches;

@end
