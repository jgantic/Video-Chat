//
//  MapViewController.m
//  LiveOne
//
//  Created by Александр on 22.08.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import "MapViewController.h"
//#import <WhirlyGlobeComponent.h>

@interface MapViewController ()

@property (strong, nonatomic) UIView *layerInfo;
@property (strong, nonatomic) UIImageView*viewInfo;
@property (strong, nonatomic) UILabel *labelInfo;
@end

@implementation MapViewController
{
    /*MaplyBaseViewController *theViewC;
    WhirlyGlobeViewController *globeViewC;
    MaplyViewController *mapViewC;*/
}

const bool DoGlobe = true;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateOrientation)
                                                 name:@"updateOrientation"
                                               object:nil];
    
    

    
    
    if (DoGlobe) {
        globeViewC = [[WhirlyGlobeViewController alloc] init];
        theViewC = globeViewC;
    }
    
    [self.view addSubview:theViewC.view];
    theViewC.view.frame = self.view.bounds;
    [self addChildViewController:theViewC];
    
    WhirlyGlobeViewController *globeViewC = nil;
    MaplyViewController *mapViewC = nil;
    if ([theViewC isKindOfClass:[WhirlyGlobeViewController class]])
        globeViewC = (WhirlyGlobeViewController *)theViewC;
    else
        mapViewC = (MaplyViewController *)theViewC;
    
    theViewC.clearColor = (globeViewC != nil) ? [UIColor clearColor] : [UIColor whiteColor];
    
    // and thirty fps if we can get it ­ change this to 3 if you find your app is struggling
    theViewC.frameInterval = 2;
    
    // add the capability to use the local tiles or remote tiles
    bool useLocalTiles = false;
    
    // we'll need this layer in a second
    MaplyQuadImageTilesLayer *layer;
    
    if (useLocalTiles)
    {
        MaplyMBTileSource *tileSource =
        [[MaplyMBTileSource alloc] initWithMBTiles:@"geography­-class_medres"];
        layer = [[MaplyQuadImageTilesLayer alloc]
                 initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
    } else {
        // Because this is a remote tile set, we'll want a cache directory
        NSString *baseCacheDir =
        [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)
         objectAtIndex:0];
        NSString *aerialTilesCacheDir = [NSString stringWithFormat:@"%@/osmtiles/",
                                         baseCacheDir];
        int maxZoom = 18;
        
        // MapQuest Open Aerial Tiles, Courtesy Of Mapquest
        // Portions Courtesy NASA/JPL­Caltech and U.S. Depart. of Agriculture, Farm Service Agency
        MaplyRemoteTileSource *tileSource =
        [[MaplyRemoteTileSource alloc]
         initWithBaseURL:@"http://otile1.mqcdn.com/tiles/1.0.0/sat/"
         ext:@"png" minZoom:0 maxZoom:maxZoom];
        tileSource.cacheDir = aerialTilesCacheDir;
        layer = [[MaplyQuadImageTilesLayer alloc]
                 initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
    }
    
    layer.handleEdges = (globeViewC != nil);
    layer.coverPoles = (globeViewC != nil);
    layer.requireElev = true;
    layer.waitLoad = true;
    layer.drawPriority = 0;
    layer.singleLevelLoading = false;
    [theViewC addLayer:layer];
    
    // start up over San Francisco, center of the universe
    if (globeViewC != nil)
    {
        globeViewC.height = 1.7;
        
        [globeViewC animateToPosition:MaplyCoordinateMakeWithDegrees(-122.4192,37.7793)
                                 time:1.0];
    
        [globeViewC setAutoRotateInterval:3.0 degrees:5.0];
    } else {
        mapViewC.height = 1.0;
        [mapViewC animateToPosition:MaplyCoordinateMakeWithDegrees(-122.4192,37.7793)
                               time:1.0];
    }
    
    if (globeViewC != nil)
        globeViewC.delegate = self;
    
    // If you're doing a map
    if (mapViewC != nil)
        mapViewC.delegate = self;
    
    
    [self addBars];
    
    //add layer for info
    
    _layerInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 100, ((self.view.bounds.size.width*45)/100), 80)];
    
    [_layerInfo setBackgroundColor:[UIColor blackColor]];
    
    _layerInfo.alpha = 0.4f;
    
    [self.view addSubview:_layerInfo];
    
    
    _viewInfo = [[UIImageView alloc] initWithFrame:CGRectMake(30, 100, ((self.view.bounds.size.width*45)/100)-80, 80)];
    
    [_viewInfo setImage:[UIImage imageNamed:@"mapView.png"]];
    
    _viewInfo.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:_viewInfo];
    
    
    //_labelInfo = [[UILabel alloc] initWithFrame:CGRectMake(5, 155, ((self.view.bounds.size.width*45)/100)-5, 75)];
    
    //[_labelInfo setTextColor:[UIColor whiteColor]];
    
    
    //[_labelInfo setFont:[UIFont systemFontOfSize:11]];
    
    //[_labelInfo setText:@"CrowdSurfer| Vaasa, FI | 3m ago"];
    
    //_labelInfo.textAlignment = NSTextAlignmentCenter;
    
   
    
    //[self.view addSubview:_labelInfo];
    
    [self hideLayerInfo];
    
    // Do any additional setup after loading the view.*/
}


- (void)updateOrientation {
    
    
   // _layerInfo.frame =  CGRectMake(0, 100, self.view.bounds.size.width, 200);
   //_viewInfo.frame = CGRectMake(30, 100, self.view.bounds.size.width, 200);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addBars
{
    // set up some locations
    /*MaplyCoordinate capitals[40];
    capitals[0] = MaplyCoordinateMakeWithDegrees(-77.036667, 38.895111);
    capitals[1] = MaplyCoordinateMakeWithDegrees(120.966667, 14.583333);
    capitals[2] = MaplyCoordinateMakeWithDegrees(55.75, 37.616667);
    capitals[3] = MaplyCoordinateMakeWithDegrees(-0.1275, 51.507222);
    capitals[4] = MaplyCoordinateMakeWithDegrees(-66.916667, 10.5);
    capitals[5] = MaplyCoordinateMakeWithDegrees(139.6917, 35.689506);
    capitals[6] = MaplyCoordinateMakeWithDegrees(166.666667, -77.85);
    capitals[7] = MaplyCoordinateMakeWithDegrees(-58.383333, -34.6);
    capitals[8] = MaplyCoordinateMakeWithDegrees(-74.075833, 4.598056);
    capitals[9] = MaplyCoordinateMakeWithDegrees(-79.516667, 8.983333);
    
    
    capitals[1] = MaplyCoordinateMakeWithDegrees(-73.036667, 39.895111);
    capitals[11] = MaplyCoordinateMakeWithDegrees(100.966667, 24.583333);
    capitals[12] = MaplyCoordinateMakeWithDegrees(55.75, 23.616667);
    capitals[13] = MaplyCoordinateMakeWithDegrees(-10.1275, 41.507222);
    capitals[14] = MaplyCoordinateMakeWithDegrees(-62.916667, 12.5);
    capitals[15] = MaplyCoordinateMakeWithDegrees(129.6917, 35.689506);
    capitals[16] = MaplyCoordinateMakeWithDegrees(126.666667, -71.85);
    capitals[17] = MaplyCoordinateMakeWithDegrees(-45.383333, -14.6);
    capitals[18] = MaplyCoordinateMakeWithDegrees(-71.075833, 3.598056);
    capitals[19] = MaplyCoordinateMakeWithDegrees(-74.516667, 23.983333);
    
    
    
    capitals[20] = MaplyCoordinateMakeWithDegrees(-80.036667, 38.895111);
    capitals[21] = MaplyCoordinateMakeWithDegrees(111.966667, 15.583333);
    capitals[22] = MaplyCoordinateMakeWithDegrees(59.75, 35.616667);
    capitals[23] = MaplyCoordinateMakeWithDegrees(-1.1275, 54.507222);
    capitals[24] = MaplyCoordinateMakeWithDegrees(-46.916667, 10.5);
    capitals[25] = MaplyCoordinateMakeWithDegrees(135.6917, 32.689506);
    capitals[26] = MaplyCoordinateMakeWithDegrees(164.666667, -72.85);
    capitals[27] = MaplyCoordinateMakeWithDegrees(-55.383333, -43.6);
    capitals[28] = MaplyCoordinateMakeWithDegrees(-73.075833, 43.598056);
    capitals[29] = MaplyCoordinateMakeWithDegrees(-75.516667, 4.983333);
    
    
    capitals[30] = MaplyCoordinateMakeWithDegrees(-75.036667, 48.895111);
    capitals[31] = MaplyCoordinateMakeWithDegrees(14.966667, 24.583333);
    capitals[32] = MaplyCoordinateMakeWithDegrees(55.75, 39.616667);
    capitals[33] = MaplyCoordinateMakeWithDegrees(-0.1275, 21.507222);
    capitals[34] = MaplyCoordinateMakeWithDegrees(-63.916667, 20.5);
    capitals[35] = MaplyCoordinateMakeWithDegrees(149.6917, 35.689506);
    capitals[36] = MaplyCoordinateMakeWithDegrees(156.666667, -27.85);
    capitals[37] = MaplyCoordinateMakeWithDegrees(-28.383333, -24.6);
    capitals[38] = MaplyCoordinateMakeWithDegrees(-54.075833, 14.598056);
    capitals[39] = MaplyCoordinateMakeWithDegrees(-75.516667, 18.983333);
    
    // get the image and create the markers
    UIImage *icon = [UIImage imageNamed:@"marker1.png"];
    NSMutableArray *markers = [NSMutableArray array];
    for (unsigned int ii=0;ii<40;ii++)
    {
        MaplyScreenMarker *marker = [[MaplyScreenMarker alloc] init];
        marker.image = icon;
        marker.loc = capitals[ii];
        marker.size = CGSizeMake(40,40);
        [markers addObject:marker];
    }
    // add them all at once (for efficency)
    [theViewC addScreenMarkers:markers desc:nil];
     */
}


#pragma WhyrlyGlobe Delegate

//- (void) globeViewController:(WhirlyGlobeViewController *)viewC didTapAt:(WGCoordinate)coord
//{
    
    /*viewC.height = 1.7;
    
    [viewC animateToPosition:MaplyCoordinateMakeWithDegrees(-122.4192,37.7793)
                             time:1.0];
    
    [self hideLayerInfo];*/
//}
//- (void) globeViewController:(WhirlyGlobeViewController *)viewC didSelect:(NSObject *)selectedObj {
    /*if ([selectedObj isKindOfClass:[MaplyScreenMarker class]])
    {
        // or it might be a screen marker
        MaplyScreenMarker *theMarker = (MaplyScreenMarker *)selectedObj;
        
        //[viewC animateToPosition:theMarker.loc height:0.3 heading:1.0 time:1.0];
        
        [self showLayerInfo];
        
    }*/
//}

- (void) showLayerInfo {
   /* [_layerInfo setHidden:NO];
    [_labelInfo setHidden:NO];
    
    [_viewInfo setHidden:NO];
    [_viewInfo setHidden:NO];*/
}
- (void) hideLayerInfo {
   /* [_layerInfo setHidden:YES];
    [_labelInfo setHidden:YES];
    
    [_viewInfo setHidden:YES];
    [_viewInfo setHidden:YES];*/
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
