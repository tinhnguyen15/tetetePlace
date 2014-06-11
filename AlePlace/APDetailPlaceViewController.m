//
//  APDetailPlaceViewController.m
//  AlePlace
//
//  Created by VinhPhuc on 6/11/14.
//
//

#import "APDetailPlaceViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "UIImageView+AFNetworking.h"
#import "FMConstants.h"
#import "FMUtils.h"
#import "APShowFullMapViewController.h"
#import "FMUtils.h"
@interface UIView (ARES)

- (void)roundCornerShadowAndBorder;

@end

@implementation UIView (ARES)

- (void)roundCornerShadowAndBorder {
    
    [self.layer setCornerRadius:6];
    [self.layer setMasksToBounds:NO];
    
    [self.layer setShadowColor:[UIColor darkTextColor].CGColor];
    [self.layer setShadowOpacity:0.6];
    [self.layer setShadowOffset:CGSizeMake(1,1)];
    [self.layer setShadowRadius:0.9];
    [self.layer setShadowPath:[[UIBezierPath bezierPathWithRoundedRect:self.layer.bounds cornerRadius:self.layer.cornerRadius] CGPath]];
    
    [self.layer setShouldRasterize:YES];
    [self.layer setRasterizationScale:[UIScreen mainScreen].scale];
}
@end
@interface APDetailPlaceViewController ()
{
    GMSMapView *mapView_;
    APShowFullMapViewController *showFullMapViewController;
}
@end

@implementation APDetailPlaceViewController
@synthesize map,viewContaintImaves,imageDetail,titleDetail,description,address,hours,price,webView,showFull,zoomMax,zoomMin,scrollStadium,place,phone;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[NSNotificationCenter defaultCenter]postNotificationName:kAleViewController object:self userInfo:@{kNameView:@"APDetailPlaceViewController"}];
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeView) name:kRemoveDetailPlaceViewController object:nil];

}
-(void)removeView{
    [self.view removeFromSuperview];
}
-(IBAction)showFullMap:(id)sender{
    showFullMapViewController = [[APShowFullMapViewController alloc] initWithNibName:@"APShowFullMapViewController" bundle:nil];
    showFullMapViewController.place = place;
    showFullMapViewController.view.frame = self.view.frame;
    [self.view addSubview:showFullMapViewController.view];
}
-(void)loadData{
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:place.latitude
                                                            longitude:place.longitude
                                                                 zoom:20];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.map.frame.size.width, self.map.frame.size.height) camera:camera];
    mapView_.myLocationEnabled = YES;
    [self.map addSubview:mapView_];
    [self.map addSubview:showFull];
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(place.latitude, place.longitude);
    marker.title = place.nameplace;
    marker.snippet = place.city;
     UIImage *markerImg=[FMUtils imageWithImage:[UIImage imageNamed:@"stadium_map"] scaledToSize:CGSizeMake(50, 50)];
    marker.icon=markerImg;
    marker.map = mapView_;
    self.titleDetail.text = place.nameplace;
    [self.imageDetail roundCornerShadowAndBorder];
    [self.imageDetail setImageWithURL:[NSURL URLWithString:[place.thumb_photoplace stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:nil];

    self.description.text = place.description;
    self.description.frame = CGRectMake(self.description.frame.origin.x,CGRectGetMaxY(self.map.frame)+ 20, self.description.frame.size.width, [FMUtils heightForCell:place.description size:17 font:@"Helvetica" width:self.description.frame.size.width]);
    self.price.text=place.price;
    self.hours.text=place.service_hour;
    self.address.text = place.address;
    self.phone.text = place.phone;
    
    
    self.webView.frame = CGRectMake(self.webView.frame.origin.x, CGRectGetMaxY(self.description.frame)+10, self.webView.frame.size.width, self.view.frame.size.height);
    if (place.media.count > 0) {
        NSURL *urlforWebView=[NSURL URLWithString:[place.media objectAtIndex:0]];
        NSURLRequest *urlRequest=[NSURLRequest requestWithURL:urlforWebView];
        self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, self.webView.frame.size.width, self.webView.frame.size.height+ 50);
        [self.webView loadRequest:urlRequest];
    }
    
    self.scrollStadium.contentSize = CGSizeMake(self.scrollStadium.frame.size.width,CGRectGetMaxY(self.webView.frame)+100);
    
    
}
#pragma mark - Rotate View Support
- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
}
- (NSUInteger)supportedInterfaceOrientations
{
    //return orientations you want to support
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown);
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortrait: {
            NSLog(@"Portrait");
            
            mapView_.frame = CGRectMake(mapView_.frame.origin.x, mapView_.frame.origin.y, [FMUtils getMainView].frame.size.width -20, mapView_.frame.size.height);
            
            break;
        }
            
        case UIInterfaceOrientationLandscapeLeft: {
            NSLog(@"Landscape Left");
            
            mapView_.frame = CGRectMake(mapView_.frame.origin.x, mapView_.frame.origin.y, [FMUtils getMainView].frame.size.height -20, mapView_.frame.size.height);
            
            
            break;
        }
            
        case UIInterfaceOrientationLandscapeRight: {
            NSLog(@"Landscape Right");
            
            mapView_.frame = CGRectMake(mapView_.frame.origin.x, mapView_.frame.origin.y, [FMUtils getMainView].frame.size.height -20, mapView_.frame.size.height);
            
            break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end