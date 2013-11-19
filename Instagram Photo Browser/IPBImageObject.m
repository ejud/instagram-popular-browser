//
//  IPBImageObject.m
//  Instagram Photo Browser
//
//  Created by Ethan Jud on 11/18/13.
//  Copyright (c) 2013 Ethan Jud. All rights reserved.
//

#import "IPBImageObject.h"

NSString *const IPBImageObjectErrorDomain = @"edu.self.IPBImageObjectErrorDomain";

@interface NSDictionary (IPBImageObjectAdditions)

- (NSURL *)urlAtKeyPath:(NSString *)keyPath;

@end

@implementation IPBImageObject

+ (NSArray *)imageObjectsForAPIResponse:(id)apiResponse error:(NSError **)error
{
    id data = [apiResponse valueForKeyPath:@"data"];
    if (![data isKindOfClass:[NSArray class]]) {
        if (error) {
            *error = [NSError errorWithDomain:IPBImageObjectErrorDomain code:0 userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"Invalid API response for image object", nil)}];
        }

        return nil;
    }

    NSMutableArray *resultArray = [NSMutableArray array];

    NSArray *dataArray = data;
    for (id mediaObject in dataArray) {
        NSString *type = [mediaObject valueForKeyPath:@"type"];
        if ([type isEqualToString:@"image"]) {
            IPBImageObject *imageObject = [[[self alloc] initWithAPIResponse:mediaObject] autorelease];
            [resultArray addObject:imageObject];
        }
    }

    return resultArray;
}

- (id)initWithAPIResponse:(id)apiResponse
{
    self = [super init];
    if (self) {
        [self populateWithAPIResponse:apiResponse];
    }
    return self;
}

- (void)populateWithAPIResponse:(id)apiResponse
{
    if (![apiResponse isKindOfClass:[NSDictionary class]]) {
        return;
    }

    _userName = [[apiResponse valueForKeyPath:@"user.username"] retain];
    _userFullName = [[apiResponse valueForKeyPath:@"user.full_name"] retain];

    _imageURL = [[apiResponse urlAtKeyPath:@"images.standard_resolution.url"] retain];
    _thumbnailURL = [[apiResponse urlAtKeyPath:@"images.thumbnail.url"] retain];
    _userProfilePictureURL = [[apiResponse urlAtKeyPath:@"user.profile_picture"] retain];
}

- (void)dealloc
{
    [_imageURL release];
    [_thumbnailURL release];
    [_userName release];
    [_userFullName release];
    [_userProfilePictureURL release];

    [super dealloc];
}

@end

@implementation NSDictionary (IPBImageObjectAdditions)

- (NSURL *)urlAtKeyPath:(NSString *)keyPath
{
    NSString *string = [self valueForKeyPath:keyPath];
    if (!string) return nil;

    return [NSURL URLWithString:string];
}

@end
