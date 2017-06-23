/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom pin annotation for display found places.
 */

#import <MapKit/MapKit.h>

@interface PlaceAnnotation : NSObject <MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subTitle;
    
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
/*@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) UIImage *icon;*/




@end


