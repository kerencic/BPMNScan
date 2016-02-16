// This file is free software. You may use it under the MIT license, which is copied
// below and available at http://opensource.org/licenses/MIT
//
// Copyright (c) 2015 Catchoom Technologies S.L.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
// Software, and to permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

#import "CraftAROnDeviceCollection.h"
#import "ImageRecognition.h"
#import "CraftARProtocols.h"
#import "BaseSearchController.h"


/**
 * The CraftAROnDeviceIR class allows to perform visual search queries
 * on collections loaded in the device.
 */
@interface CraftAROnDeviceIR : ImageRecognition

/**
 * Get the singleton instance of the OnDeviceRecognition
 */
+ (id) sharedCraftAROnDeviceIR;

/**
 * Sets an active collection for OnDevice Image Recognition
 * @param collectionToken Token from the collection to be set as active.
 * @param onProgress Executed upon progresss in the collection load into the On Device Image Recognition.
 * @param onSuccess Executed when the whole collection has been loaded and is ready for Recognition.
 * @param onError Executed in case of error.
 */
- (void) setCollectionWithToken: (NSString*)collectionToken withOnProgress: (void (^)(float progress)) onProgressBlock onSuccess: (void(^)(void)) onSuccessBlock andOnError: (void(^)(NSError *error)) onErrorBlock;

/**
 * Sets an active collection for On Device Image Recognition
 * @param collectionToken Token from the collection to be set as active.
 * @param onSuccess Executed when the whole collection has been loaded and is ready for Recognition.
 * @param onError Executed in case of error.
 */
- (void) setCollectionWithToken: (NSString*)collectionToken withOnSuccess: (void(^)(void)) onSuccessBlock andOnError: (void(^)(NSError *error)) onErrorBlock;

/**
 * Sets a collection for On Device Image Recognition
 * @param collectionToken Token from the collection to be set.
 * @param setActive Whether to select this collection as the active for searches.
 * @param onProgress Executed upon progresss in the collection load into the On Device Image Recognition.
 * @param onSuccess Executed when the whole collection has been loaded and is ready for Recognition.
 * @param onError Executed in case of error.
 */
- (void) setCollectionWithToken: (NSString*)collectionToken setActive: (bool)setActive withOnProgress: (void (^)(float progress)) onProgressBlock onSuccess: (void(^)(void)) onSuccessBlock andOnError: (void(^)(NSError *error)) onErrorBlock;

/**
 * Sets a collection for On Device Image Recognition
 * @param collectionToken Token from the collection to be set.
 * @param setActive Whether to select this collection as the active for searches.
 * @param onSuccess Executed when the whole collection has been loaded and is ready for Recognition.
 * @param onError Executed in case of error.
 */
- (void) setCollectionWithToken: (NSString*)collectionToken setActive: (bool)setActive withOnSuccess: (void(^)(void)) onSuccessBlock andOnError: (void(^)(NSError *error)) onErrorBlock;


/**
 * Sets an active collection for On Device Image Recognition
 * @param collection CraftAROnDeviceCollection to be set as active.
 * @param onProgress Executed upon progresss in the collection load into the On Device Image Recognition.
 * @param onSuccess Executed when the whole collection has been loaded and is ready for Recognition.
 * @param onError Executed in case of error.
 */
- (void) setCollection: (CraftAROnDeviceCollection*) collection withOnProgress: (void (^)(float progress)) onProgressBlock onSuccess: (void(^)(void)) onSuccessBlock andOnError: (void(^)(NSError *error)) onErrorBlock;
/**
 * Sets an active collection for On Device Image Recognition
 * @param collection CraftAROnDeviceCollection to be set as active.
 * @param onSuccess Executed when the whole collection has been loaded and is ready for Recognition.
 * @param onError Executed in case of error.
 */
- (void) setCollection: (CraftAROnDeviceCollection*) collection withOnSuccess: (void(^)(void)) onSuccessBlock andOnError: (void(^)(NSError *error)) onErrorBlock;

/**
 * Sets an active collection for On Device Image Recognition
 * @param collection CraftAROnDeviceCollection to be set .
 * @param setActive Whether to select this collection as the active for searches.
 * @param onProgress Executed upon progresss in the collection load into the On Device Image Recognition.
 * @param onSuccess Executed when the whole collection has been loaded and is ready for Recognition.
 * @param onError Executed in case of error.
 */
- (void) setCollection: (CraftAROnDeviceCollection*) collection setActive: (bool)setActive withOnProgress: (void(^)(float progress)) onProgressBlock onSuccess: (void(^)(void)) onSuccessBlock andOnError: (void(^)(NSError *error)) onErrorBlock;

/**
 * Sets an active collection for On Device Image Recognition
 * @param collection CraftAROnDeviceCollection to be set.
 * @param setActive Whether to select this collection as the active for searches.
 * @param onSuccess Executed when the whole collection has been loaded and is ready for Recognition.
 * @param onError Executed in case of error.
 */
- (void) setCollection: (CraftAROnDeviceCollection*) collection setActive: (bool)setActive withOnSuccess: (void(^)(void)) onSuccessBlock andOnError: (void(^)(NSError *error)) onErrorBlock;

/**
 * Unloads a collection from the On Device Image Recognition
 * @param collection The collection to be unloaded.
 */
- (void) unloadCollection: (CraftAROnDeviceCollection*) collection withOnDone: (void(^)(void))onDone;

/**
 * Unloads a collection from the On Device Image Recognition
 * @param collectionUUID UUID that identifies the collection.
 */
- (void) unloadCollectionWithUUID: (NSString*) collectionUUID withOnDone: (void(^)(void))onDone;


/**
 * Perform an Image Recognition search
 * @param image CraftARQueryImage to use for the recognition search.
 * @param requestCode Request identifier passed back on the callbacks
 * @param onResultBlock Executed with an NSArray of CraftARSearchResults if the search took place.
 * @param onError Executed with a CraftARError if an error happened during recognition.
 */
- (void) searchWithImage: (CraftARQueryImage*)image andRequestCode: (NSInteger)requestCode withOnResults: (void(^)(NSArray* results, NSInteger requestCode)) onResultBlock andOnError: (void(^)(NSError *error, NSInteger requestCode)) onErrorBlock;


/**
 * Perform a Cloud Image Recognition search
 * @param image CraftARQueryImage to use for the recognition search.
 * @param onResultBlock Executed with an NSArray of CraftARSearchResults if the search took place.
 * @param onError Executed with a CraftARError if an error happened during recognition.
 */
- (void) searchWithImage:(CraftARQueryImage *)image withOnResults:(void (^)(NSArray* results))onResultBlock andOnError:(void (^)(NSError* error))onErrorBlock;

/**
 * The search controller for the On-device Image Recognition
 */
@property (nonatomic, readonly) BaseSearchController* mSearchController;

@end
