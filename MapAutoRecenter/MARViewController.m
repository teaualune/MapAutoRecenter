//
//  MARViewController.m
//  MapAutoRecenter
//
//  Created by Teaualune Tseng on 13/1/4.
//  Copyright (c) 2013年 Teaualune Tseng. All rights reserved.
//

#import "MARViewController.h"

@interface MARViewController ()

- (void)longPressOnMap:(UIGestureRecognizer *)gestureRecognizer;

- (void)tap:(UIGestureRecognizer *)gestureRecognizer;

- (void)dismissCallout;
- (void)showPartialCallout;
- (void)showCallout;

@end

@implementation MARViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    annotation = [[MKPointAnnotation alloc] init];
    
    longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnMap:)];
    [self.map addGestureRecognizer:longPressGestureRecognizer];
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.map.delegate = nil;
}

- (void)longPressOnMap:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint pressPoint = [gestureRecognizer locationInView:self.map];
    CLLocationCoordinate2D coordinate = [self.map convertPoint:pressPoint toCoordinateFromView:self.map];
        
    annotation.coordinate = coordinate;
    [self.map addAnnotation:annotation];
    self.coordinateLabel.text = [NSString stringWithFormat:@"%f, %f", coordinate.latitude, coordinate.longitude];
    
    [self showPartialCallout];
}

- (void)tap:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint tapPoint = [gestureRecognizer locationInView:self.calloutView];
    CGFloat screenHeight = [[UIApplication sharedApplication].delegate window].frame.size.height - 20;
    CGRect frame = self.calloutView.frame;

    if (tapPoint.y < 0 && frame.origin.y < screenHeight / 2.0) {
        [self dismissCallout];
    } else if (tapPoint.y >= 0) {
        [self showCallout];
    }
}

- (void)dismissCallout
{
    CGRect frame = self.calloutView.frame;
    CGFloat screenHeight = [[UIApplication sharedApplication].delegate window].frame.size.height - 20;
    [UIView animateWithDuration:0.5 animations:^{
        self.calloutView.frame = CGRectMake(frame.origin.x, screenHeight, frame.size.width, frame.size.height);
        [self.map setCenterCoordinate:previousCoordinate animated:YES];
    }];
}

- (void)showPartialCallout
{
    CGFloat screenHeight = [[UIApplication sharedApplication].delegate window].frame.size.height - 20;
    CGRect frame = self.calloutView.frame;
    
    self.calloutView.frame = CGRectMake(frame.origin.x, screenHeight, frame.size.width, frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        self.calloutView.frame= CGRectMake(frame.origin.x, screenHeight - 44.0, frame.size.width, frame.size.height);
    }];
}

- (void)showCallout
{
    CGRect frame = self.calloutView.frame;
    CGFloat screenHeight = [[UIApplication sharedApplication].delegate window].frame.size.height - 20;
    
    previousCoordinate = self.map.centerCoordinate;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.calloutView.frame = CGRectMake(frame.origin.x, screenHeight - frame.size.height, frame.size.width, frame.size.height);
        
        CGFloat offset = frame.size.height / 2.0;
        CGRect newRect = CGRectMake(0, 0, self.map.frame.size.width, offset);
        MKCoordinateRegion region = [self.map convertRect:newRect toRegionFromView:self.map];
        double yDistance = region.span.latitudeDelta;
        
        CLLocationCoordinate2D newCoordinate = CLLocationCoordinate2DMake(annotation.coordinate.latitude - yDistance, annotation.coordinate.longitude);
        [self.map setCenterCoordinate:newCoordinate animated:YES];
        
    }];
}

#pragma mark - Map View Delegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [self showPartialCallout];
}


@end
