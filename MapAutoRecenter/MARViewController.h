//
//  MARViewController.h
//  MapAutoRecenter
//
//  Created by Teaualune Tseng on 13/1/4.
//  Copyright (c) 2013年 Teaualune Tseng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MARViewController : UIViewController<MKMapViewDelegate>
{
    MKPointAnnotation *annotation;
    UILongPressGestureRecognizer *longPressGestureRecognizer;
    UITapGestureRecognizer *tapGestureRecognizer;
    CLLocationCoordinate2D previousCoordinate;
}

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIView *calloutView;
@property (weak, nonatomic) IBOutlet UILabel *coordinateLabel;

@end
