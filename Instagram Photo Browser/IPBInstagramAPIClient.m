//
//  IPBInstagramAPIClient.m
//  Instagram Photo Browser
//
//  Created by Ethan Jud on 11/21/13.
//  Copyright (c) 2013 Ethan Jud. All rights reserved.
//

#import "IPBInstagramAPIClient.h"
#import "IPBImageObject.h"

static NSString *const kBaseInstagramURL = @"https://api.instagram.com";

@interface IPBInstagramAPIClient ()

@property (strong, nonatomic) NSString *clientID;
@property (strong, nonatomic) NSURL *baseURL;

@end

@implementation IPBInstagramAPIClient

#pragma mark - Client Lifecycle

+ (instancetype)sharedClient
{
    static IPBInstagramAPIClient *sharedClient = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });

    return sharedClient;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *plistPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"InstagramPhotoBrowserSettings" ofType:@"plist"];
        NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        
        _clientID = [[settings valueForKey:@"ClientID"] retain];
        _baseURL = [[NSURL alloc] initWithString:kBaseInstagramURL];
    }
    return self;
}

- (void)dealloc
{
    [_clientID release];
    [_baseURL release];
    
    [super dealloc];
}

#pragma mark - Fetch

- (void)fetchPopularImagesWithCallback:(IPBInstagramAPIClientCallback)callback
{
    NSString *relativeURLString = [NSString stringWithFormat:@"/v1/media/popular?client_id=%@", self.clientID];
    NSURL *url = [NSURL URLWithString:relativeURLString relativeToURL:self.baseURL];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        if (error) {
            callback(nil, error);
            return;
        }

        NSError *jsonError = nil;
        id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (!jsonResponse || jsonError) {
            callback(nil, jsonError);
            return;
        }

        NSError *parseError = nil;
        NSArray *images = [IPBImageObject imageObjectsForAPIResponse:jsonResponse error:&parseError];
        if (!images || parseError) {
            callback(nil, parseError);
            return;
        }

        callback(images, nil);
    }];
}

@end
