/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
  See LICENSE.txt for this sample’s licensing information
  
  Abstract:
  Displays an MKMapView and demonstrates how to use the included KMLParser class to place annotations and overlays from a parsed KML file on top of the MKMapView. 
 */

@import MapKit;


#import "KMLParser.h"
#import "KMLViewerViewController.h"
#import "PlaceAnnotation.h"
#import "AireAMG-Bridging-Header.h"


//http://www.techotopia.com/index.php/Working_with_MapKit_Local_Search_in_iOS_7
// http://eartz.github.io/rgbaToKml/

@interface KMLViewerViewController () <MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *map;
@property (nonatomic, strong) KMLParser *kmlParser;
@property (nonatomic, strong) PlaceAnnotation *annot;
@property (nonatomic, strong) NSString *lat_fav;
@property (nonatomic, strong) NSString *lon_fav;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (nonatomic, strong) NSString *useranalisis;
@property NSArray *overlays;


- (IBAction)showResults:(id)sender;



@property (nonatomic, strong) CLLocationManager *locationManager;



@end



@implementation KMLViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //CLLocationManager *locationManager;
    
    [self.view setNeedsDisplay];
    
    //[self.map setRegion:self.boundingRegion animated:YES];
    //[self.map setRegion:bou]
    
    // Adjust the map to zoom/center to the annotations we want to show.
    [self.map setRegion:self.boundingRegion animated:YES];
    
    
    
    //View location
    self.map.showsUserLocation = NO;
    self.locationManager = [CLLocationManager new];
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
    [self.map addGestureRecognizer:lpgr];
    
    self.annot = [[PlaceAnnotation alloc] init];

    
    // Locate the path to the route.kml file in the application's bundle
    // and parse it with the KMLParser.
    
    NSString *stringURL = @"http://149.56.132.38/kml/Outkml/kmlios.txt";
    
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:@"showkml"];
    if (value != nil){
        if([value  isEqual: @"pm10"]){
            stringURL = @"http://149.56.132.38/kml/Outkml/kmlios.txt";
        }
        if([value  isEqual: @"ozono"]){
            stringURL = @"http://149.56.132.38/kml/Outkml/kmliosozono.txt";
        }
    }
    
    
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"KMLios.kml"];
        [urlData writeToFile:filePath atomically:YES];
    }
    
    
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"KML_ios" ofType:@"kml"];
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString  *path = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"KMLios.kml"];
    
    NSURL *urlpath = [NSURL fileURLWithPath:path];
    self.kmlParser = [[KMLParser alloc] initWithURL:urlpath];
    [self.kmlParser parseKML];
    
    // Add all of the MKOverlay objects parsed from the KML file to the map.
    self.overlays = [self.kmlParser overlays];
    [self.map addOverlays:self.overlays];
    
    
    
    
    // Add all of the MKAnnotation objects parsed from the KML file to the map.
    NSArray *annotations = [self.kmlParser points];
    [self.map addAnnotations:annotations];
    
    // Walk the list of overlays and annotations and create a MKMapRect that
    // bounds all of them and store it into flyTo.
    MKMapRect flyTo = MKMapRectNull;
    for (id <MKOverlay> overlay in self.overlays) {
        if (MKMapRectIsNull(flyTo)) {
            flyTo = [overlay boundingMapRect];
        } else {
            flyTo = MKMapRectUnion(flyTo, [overlay boundingMapRect]);
        }
    }
    
    for (id <MKAnnotation> annotation in annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(flyTo)) {
            flyTo = pointRect;
        } else {
            flyTo = MKMapRectUnion(flyTo, pointRect);
        }
    }
    
    // Position the map so that all overlays and annotations are visible on screen.
    self.map.visibleMapRect = flyTo;
}

- (IBAction)refresh:(UIButton *)sender {
    
    //self.map.remove
    
    // Locate the path to the route.kml file in the application's bundle
    // and parse it with the KMLParser.
    _useranalisis = @"estaciones";
    
    NSString *stringURL = @"http://149.56.132.38/kml/Outkml/kmlios.txt";
    
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:@"showkml"];
    if (value != nil){
        if([value  isEqual: @"pm10"]){
            stringURL = @"http://149.56.132.38/kml/Outkml/kmlios.txt";
        }
        if([value  isEqual: @"ozono"]){
            stringURL = @"http://149.56.132.38/kml/Outkml/kmliosozono.txt";
        }
    }
    
    
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"KMLios.kml"];
        [urlData writeToFile:filePath atomically:YES];
    }
    
    //[self.map removeOverlay:<#(nonnull id<MKOverlay>)#>]
    
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"KML_ios" ofType:@"kml"];
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString  *path = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"KMLios.kml"];
    
    NSURL *urlpath = [NSURL fileURLWithPath:path];
    self.kmlParser = [[KMLParser alloc] initWithURL:urlpath];
    [self.kmlParser parseKML];
    
    // Add all of the MKOverlay objects parsed from the KML file to the map.
    [self.map removeOverlays:self.overlays];
    self.overlays = [self.kmlParser overlays];
    [self.map addOverlays:self.overlays];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.view setNeedsDisplay];
    
    // We add the placemarks here to get the "drop" animation.
    if (self.mapItemList.count == 1) {
        MKMapItem *mapItem = [self.mapItemList objectAtIndex:0];
        
        self.title = mapItem.name;
        
        
        // Add the single annotation to our map.
        PlaceAnnotation *annotation = [[PlaceAnnotation alloc] init];
        annotation.coordinate = mapItem.placemark.location.coordinate;
        annotation.title = mapItem.name;
        //annotation.url = mapItem.url;
        
        _useranalisis = @"flag";
        
        [self.map addAnnotation:annotation];
        
        // We have only one annotation, select it's callout.
        [self.map selectAnnotation:[self.map.annotations objectAtIndex:0] animated:YES];
        
        
        MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:mapItem.placemark.location.coordinate fromEyeCoordinate:CLLocationCoordinate2DMake(mapItem.placemark.location.coordinate.latitude, mapItem.placemark.location.coordinate.longitude) eyeAltitude:10000];
        [self.map setCamera:camera animated:YES];
        
        
    } else {
        self.title = @"AireAMG";
        
        // Add all the found annotations to the map.
        
        for (MKMapItem *item in self.mapItemList) {
            PlaceAnnotation *annotation = [[PlaceAnnotation alloc] init];
            annotation.coordinate = item.placemark.location.coordinate;
            annotation.title = item.name;
            
            //annotation.url = item.url;
            [self.map addAnnotation:annotation];
        }
    }
}


-(void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.map];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.map convertPoint:touchPoint toCoordinateFromView:self.map];
    
    self.annot.title = @"Analisis de esta zona";
    self.annot.subTitle = @"Analisis";
    self.annot.coordinate = touchMapCoordinate;
    
    NSNumber *str_lat_fav = [NSNumber numberWithDouble:touchMapCoordinate.latitude];
    self.lat_fav  = [str_lat_fav stringValue];
    
    NSNumber *str_lon_fav = [NSNumber numberWithDouble:touchMapCoordinate.longitude];
    self.lon_fav  = [str_lon_fav stringValue];
    
    //annotationView.canShowCallout = YES;
    
    _useranalisis = @"custom";
    
   
    
    [self.map addAnnotation:self.annot];
    //[annot release];
}

#pragma mark MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    return [self.kmlParser rendererForOverlay:overlay];
    
   
}






//view.rightCalloutAccessoryView = [self yesButton];
- (UIButton *)yesButton {
    //UIImage *image = [self yesButtonImage];
    UIImage *image = [UIImage imageNamed:@"co_logo-1"];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height); // don't use auto layout
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    return button;
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    
    //return [self.kmlParser viewForAnnotation:annotation];
    
    /*MKPinAnnotationView *MyPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    MyPin.pinColor = MKPinAnnotationColorGreen;
    */
    
    MKAnnotationView *MyPin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"identifier"];
                              
    
    
    
    //UIButton *advertButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    UIButton *advertButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    //UIButton *advertButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[advertButton setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    
    [advertButton addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UIButton *favButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [favButton addTarget:self action:@selector(favButton:) forControlEvents:UIControlEventTouchUpInside];
    
    MyPin.rightCalloutAccessoryView = advertButton;
    MyPin.leftCalloutAccessoryView = favButton;
    MyPin.draggable = NO;
    MyPin.highlighted = YES;
    //MyPin.animatesDrop = TRUE;
    
    if([_useranalisis  isEqual: @"custom"]) {
         MyPin.image = [UIImage imageNamed:@"userloc"];
        
    }else if([_useranalisis  isEqual: @"estaciones"]){
        MyPin.image = [UIImage imageNamed:@"estacion_map"];
        
    }else if([_useranalisis  isEqual: @"flag"]){
        MyPin.image = [UIImage imageNamed:@"Flag"];
    }
    MyPin.canShowCallout = YES;
    
    _useranalisis = @"estaciones";
    
    return MyPin;
}

-(void)button:(id)sender{
    NSLog(@"Button action");
    [self performSegueWithIdentifier:@"graph" sender:sender];
    
}

-(void)favButton:(id)sender{
    
    [self performSegueWithIdentifier:@"fav" sender:sender];
    
}


// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"graph"]) {
        
        NSLog(@"Graph");
        NSString *myObjcData = self.lat_fav;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:myObjcData forKey:@"lat"];
        [defaults synchronize];
        
        
        NSString *myObjcData2 = self.lon_fav;
        NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
        [defaults2 setValue:myObjcData2 forKey:@"lon"];
        [defaults2 synchronize];
        
        // Get destination view
        //SecondView *vc = [segue destinationViewController];
        // Get button tag number (or do whatever you need to do here, based on your object
        //NSInteger tagIndex = [(UIButton *)sender tag];
        // Pass the information to your destination view
        //[vc setSelectedButton:tagIndex];
        
        
    }else if ([[segue identifier] isEqualToString:@"fav"]) {
        NSLog(@"favButton");
        NSString *myObjcData = self.lat_fav;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:myObjcData forKey:@"lat"];
        [defaults synchronize];
        NSString *myObjcData2 = self.lon_fav;
        
        
        NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
        [defaults2 setValue:myObjcData2 forKey:@"lon"];
        [defaults2 synchronize];
        
        
    }
        
        
}



-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:userLocation.coordinate fromEyeCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude) eyeAltitude:10000];
    [mapView setCamera:camera animated:YES];
                                                                                                                  
                                                                                                                
}

- (IBAction)showResults:(id)sender {
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}





@end



