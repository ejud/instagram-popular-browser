//
//  IPBInstagramAPIClient.h
//  Instagram Photo Browser
//
//  Created by Ethan Jud on 11/21/13.
//  Copyright (c) 2013 Ethan Jud. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^IPBInstagramAPIClientCallback)(NSArray *results, NSError *error);

@interface IPBInstagramAPIClient : NSObject

+ (instancetype)sharedClient;

- (void)fetchPopularImagesWithCallback:(IPBInstagramAPIClientCallback)callback;

@end
