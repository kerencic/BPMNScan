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
#import "CraftARError.h"

/// Notification for when a new collection is added to the device. UserInfo contains the collection than has been added under the Collection key.
extern NSString *const CollectionManagerDidFinalizeAddingCollection;
extern NSString *const CollectionKey;

/// Notification for when a collection is deleted from the device. UserInfo contains the UUID of the deleted collection under the CollectionUUID Key.
extern NSString *const CollectionManagerDidDeleteCollection;
extern NSString *const CollectionUUIDKey;

/**
 * The Collection Manager class allows to add collections of images to the
 * device. The collections are in the form of a Bundle file that can be
 * downloaded from CraftAR. A collection Bundle encapsulates the database for
 * a given collection in CraftAR.
 */
@interface CraftARCollectionManager : NSObject

/**
 * Get the singleton instance of the CollectionManager
 */
+ (id) sharedCollectionManager;

/**
 * Returns a list with all the collections in the device
 */
- (NSArray*) getCollections;


/**
 * Returns an object representing a CraftAROnDeviceCollection from the device.
 * @param collectionToken token for the collection to obtain.
 * @param error Error set when the collection could not be loaded for some reason.
 * @return The CraftAROnDeviceCollection with the provided token, nil if the collection is not available.
 */
- (CraftAROnDeviceCollection*) getCollectionWithToken: (NSString*)collectionToken andError: (NSError**) error;

/*
 * Sets the url used to connect the CraftAR Service to add or synchronize collecitons remotely.
 * @param url url to connect ot the CraftAR Service.
 */
- (void) setCollectionSyncURL: (NSString *) url;

/**
 * Downloads a collection from the CraftAR Service and add it to the collections database. If the collection is already in the databae it will be synchronized.
 * @param collectionToken token for the On-Device IR collection to download from the CraftAR service.
 * @param successBlock Executed with the added collection if the process was successful.
 * @param errorBlock Executed with a CraftARError if the collection could not be added.
 */
- (void) addCollectionWithToken: (NSString*) collectionToken withOnSuccess: (void (^)(CraftAROnDeviceCollection* collection))successBlock andOnError: (void (^)(NSError* error)) errorBlock;

/**
 * Downloads a collection from the CraftAR Service and add it to the collections database. If the collection is already in the databae it will be synchronized.
 * @param collectionToken token for the On-Device IR collection to download from the CraftAR service.
 * @param progressBlock Executed with the progress completion (percentage), 0-50% corresponds to bundle download, 50-100% to adding it to the local database.
 * @param successBlock Executed with the added collection if the process was successful.
 * @param errorBlock Executed with a CraftARError if the collection could not be added.
 */
- (void) addCollectionWithToken: (NSString*) collectionToken withOnProgress: (void (^)(float progress))progressBlock andOnSuccess: (void (^)(CraftAROnDeviceCollection* collection))successBlock andOnError: (void (^)(NSError* error) ) errorBlock;

/**
 * Add a CraftAROnDeviceCollection to the device from a collectionBundle
 * @param collectionBundlePath the path for the collectionBundle to load to the device.
 * @param successBlock Executed with the added collection if the process was successful.
 * @param errorBlock Executed with a CraftARError if the collection could not be added.
 */
- (void) addCollectionFromBundle: (NSString*) collectionBundlePath withOnSuccess: (void (^)(CraftAROnDeviceCollection* collection))successBlock andOnError: (void (^)(CraftARError* error)) errorBlock;

/**
 * Add a CraftAROnDeviceCollection to the device from a collectionBundle
 * @param collectionBundlePath the path for the collectionBundle to load to the device.
 * @param progressBlock Executed with the progress completion (percentage).
 * @param successBlock Executed with the added collection if the process was successful.
 * @param errorBlock Executed with a CraftARError if the collection could not be added.
 */
- (void) addCollectionFromBundle: (NSString*) collectionBundlePath withOnProgress: (void (^)(float progress))progressBlock andOnSuccess: (void (^)(CraftAROnDeviceCollection* collection))successBlock andOnError: (void (^)(CraftARError* error) ) errorBlock;

/**
 * Remove a collection from the device
 * @param collectionToken token for the collection to remove.
 * @param successBlock Executed when the collection is removed.
 * @param errorBlock Executed with a CraftARError if the collection could not be removed.
 */
- (void) deleteCollectionWithToken: (NSString*)collectionToken andOnSuccess:  (void (^)(void)) successBlock andOnError: (void (^)(CraftARError* error)) errorBlock;

/**
 * Remove a collection from the device
 * @param collection collection to remove.
 * @param successBlock Executed when the collection is removed.
 * @param errorBlock Executed with a CraftARError if the collection could not be removed.
 */
- (void) deleteCollection: (CraftAROnDeviceCollection*)collection andOnSuccess:  (void (^)(void)) successBlock andOnError: (void (^)(CraftARError* error)) errorBlock;

@end
