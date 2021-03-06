//
//  LightingViewController.m
//  LightingTest
//
//  Created by Michael Behan on 25/02/2014.
//  Copyright (c) 2014 Michael Behan. All rights reserved.
//

#import "MBLightingController.h"
#import "MBLitAnimationView.h"

@interface MBLightingController ()
{
    CIContext *coreImageContext;
    BOOL needsLightingUpdate;
    
    NSMutableArray *lightFixtures;
    NSMutableArray *litImageViews;
}

@end

@implementation MBLightingController

-(void)addLitView:(MBLitAnimationView *)litView
{
    if(!litImageViews)
    {
        litImageViews = [[NSMutableArray alloc] init];
    }
    
    litView.lightingContext = coreImageContext;
    [litImageViews addObject:litView];
}

-(void)addLightFixture:(id<MBLightFixture>)light
{
    if(!lightFixtures)
    {
        lightFixtures = [[NSMutableArray alloc] init];
    }
    
    [lightFixtures addObject:light];
}

-(void)setNeedsLightingUpdate
{
    needsLightingUpdate = YES;
}

-(void)updateLighting
{
    if(needsLightingUpdate || _lightsConstantlyUpdating)
    {
        needsLightingUpdate = NO;
        
        for(MBLitAnimationView *view in litImageViews)
        {
            [view applyLights:lightFixtures context:coreImageContext];
        }
    }
}

-(id)init
{
    self = [super init];
    
    if(self)
    {
        EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        NSDictionary *options = @{ kCIContextWorkingColorSpace : [NSNull null] };
        coreImageContext = [CIContext contextWithEAGLContext:myEAGLContext options:options];
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateLighting) userInfo:nil repeats:YES];
    }
    return self;
}

@end
