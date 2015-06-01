//
//  FlickrWebViewController.m
//  Flickr-HWVI
//
//  Created by plt3ch on 6/1/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "FlickrWebViewController.h"
#import "FlickrController.h"

@interface FlickrWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *flickrWebView;

@end

@implementation FlickrWebViewController

-(void)viewDidLoad{
    FlickrController* flickrController = [FlickrController sharedInstance];
    FlickrEntry* flickrEntry = flickrController.chosenFlickrEntry;
    [self.flickrWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:flickrEntry.flickrAlternativeLink]]];
    self.navigationItem.title = @"Alternative page";
}
@end
