//
//  IPBPhotoBrowserViewController.m
//  Instagram Photo Browser
//
//  Created by Ethan Jud on 11/18/13.
//  Copyright (c) 2013 Ethan Jud. All rights reserved.
//

static NSString *const kMediaURLString = @"https://api.instagram.com/v1/media/popular?client_id=50c0e12b64a84dd0b9bbf334ba7f6bf6";

#import "IPBPhotoBrowserViewController.h"
#import "IPBPhotoDetailViewController.h"
#import "IPBPhotoCell.h"
#import "IPBInstagramAPIClient.h"
#import "IPBImageObject.h"

static const CGFloat kRowHeight = 120.0;

@interface IPBPhotoBrowserViewController () <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIBarButtonItem *refreshBarButtonItem;

// The collection of image metadata objects
@property (strong, nonatomic) NSArray *images;

@end

@implementation IPBPhotoBrowserViewController

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [_tableView release];
    [_refreshBarButtonItem release];
    [_images release];

    [super dealloc];
}

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Popular Photos", nil);

    // Set up table view
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    // Remove the infinite "empty cells" by setting an empty footer view.
    self.tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];

    self.refreshBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(downloadImages)] autorelease];

    self.navigationItem.rightBarButtonItem = self.refreshBarButtonItem;

    [self.view addSubview:self.tableView];

    [self downloadImages];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

#pragma mark - Properties

- (void)setImages:(NSArray *)images
{
    if (_images == images) {
        return;
    }

    [_images autorelease];
    _images = [images retain];

    [self.tableView reloadData];
}

#pragma mark - Populate Images

- (void)downloadImages
{
    self.view.userInteractionEnabled = NO;
    self.refreshBarButtonItem.enabled = NO;
    self.images = nil;

    [[IPBInstagramAPIClient sharedClient] fetchPopularImagesWithCallback:^(NSArray *results, NSError *error) {
        self.view.userInteractionEnabled = YES;
        self.refreshBarButtonItem.enabled = YES;

        if (error) {
            [self showPopulateError];
            return;
        }

        self.images = results;
    }];
}

- (void)showPopulateError
{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Unable to load images.", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] autorelease];
    [alertView show];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.images.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const reuseIdentifier = @"Cell";
    IPBPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[IPBPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }

    cell.imageObject = self.images[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IPBImageObject *imageObject = self.images[indexPath.row];
    IPBPhotoCell *cell = (IPBPhotoCell *)[tableView cellForRowAtIndexPath:indexPath];

    [self presentDetailViewControllerForImageObject:imageObject withPlaceholderImage:cell.thumbnailImage];
}

#pragma mark - Detail View Controller

- (void)presentDetailViewControllerForImageObject:(IPBImageObject *)imageObject withPlaceholderImage:(UIImage *)placeholderImage
{
    IPBPhotoDetailViewController *detailViewController = [[[IPBPhotoDetailViewController alloc] initWithNibName:nil bundle:nil] autorelease];

    detailViewController.imageObject = imageObject;
    detailViewController.placeholderImage = placeholderImage;
    detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    detailViewController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissPresentedViewController)] autorelease];

    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:detailViewController] autorelease];

    [self presentViewController:navController animated:YES completion:nil];
}

- (void)dismissPresentedViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
