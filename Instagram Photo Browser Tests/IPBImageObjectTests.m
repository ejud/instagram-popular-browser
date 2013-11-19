//
//  IPBImageObjectTests.m
//  Instagram Photo Browser
//
//  Created by Ethan Jud on 11/18/13.
//  Copyright (c) 2013 Ethan Jud. All rights reserved.
//

#import "IPBImageObjectTests.h"
#import "IPBImageObject.h"

@implementation IPBImageObjectTests

- (void)testParseImageObject
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"exampleImageObject" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];

    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    IPBImageObject *imageObject = [[[IPBImageObject alloc] initWithAPIResponse:json] autorelease];
    STAssertNotNil(imageObject, @"An image object should be created");

    STAssertEqualObjects(imageObject.imageURL.absoluteString, @"http://distilleryimage5.s3.amazonaws.com/1369fb1050a611e39c1412d6a650978d_8.jpg", @"Image URL should be correct.");
    STAssertEqualObjects(imageObject.thumbnailURL.absoluteString, @"http://distilleryimage5.s3.amazonaws.com/1369fb1050a611e39c1412d6a650978d_5.jpg", @"Thumbnail URL should be correct");
    STAssertEqualObjects(imageObject.userName, @"theshaneharper", @"User name should be correct.");
    STAssertEqualObjects(imageObject.userFullName, @"ⓢⓗⓐⓝⓔ ⓗⓐⓡⓟⓔⓡ", @"User full name should be correct.");
    STAssertEqualObjects(imageObject.userProfilePictureURL.absoluteString, @"http://images.ak.instagram.com/profiles/profile_51298697_75sq_1347039459.jpg", @"Profile picture URL should be correct.");
}

- (void)testParseEntireResponse
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"exampleInstagramFeed" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];

    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    NSError *error = nil;
    NSArray *imageObjects = [IPBImageObject imageObjectsForAPIResponse:json error:&error];

    STAssertNil(error, @"No error should be generated.");
    STAssertNotNil(imageObjects, @"An array of image objects should be returned.");
    STAssertEquals(imageObjects.count, 14u, @"14 image objects should be returned.");
}

@end
