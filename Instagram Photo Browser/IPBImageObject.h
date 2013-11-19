//
//  IPBImageObject.h
//  Instagram Photo Browser
//
//  Created by Ethan Jud on 11/18/13.
//  Copyright (c) 2013 Ethan Jud. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const IPBImageObjectErrorDomain;

@interface IPBImageObject : NSObject

@property (strong, nonatomic, readonly) NSString *userName;
@property (strong, nonatomic, readonly) NSString *userFullName;

@property (strong, nonatomic, readonly) NSURL *imageURL;
@property (strong, nonatomic, readonly) NSURL *thumbnailURL;
@property (strong, nonatomic, readonly) NSURL *userProfilePictureURL;

// Note that this does not currently support pagination.
+ (NSArray *)imageObjectsForAPIResponse:(id)apiResponse error:(NSError **)error;

- (id)initWithAPIResponse:(id)apiResponse;

@end
