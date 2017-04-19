//
//  GameViewController.m
//  RemoteNotes2
//
//  Created by Omar A Rodriguez on 4/18/17.
//  Copyright © 2017 Omar A Rodriguez. All rights reserved.
//

#import "GameViewController.h"
#import "Renderer.h"
#import "ReplayTestRecorder.h"

@implementation GameViewController
{
    MTKView *_view;

    id<MTLDevice> _device;

    Renderer *_renderer;
	
	ReplayTestRecorder* _rtr;
	int _numRecordedFrames;
	BOOL _gamePaused;
	
	IBOutlet UILabel *statusLabel;
	IBOutlet UIButton *startRecordingButton;
	IBOutlet UIButton *stopRecordingButton;

	IBOutlet UIButton *startBroadcastButton;
	IBOutlet UIButton *pauseBroadcastButton;
	IBOutlet UIButton *resumeBroadcastButton;
	IBOutlet UIButton *stopBroadcastButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set the view to use the default device
    _device = MTLCreateSystemDefaultDevice();
    _view = (MTKView *)self.view;
    _view.delegate = self;
    _view.device = _device;

    _renderer = [[Renderer alloc] initWithMetalDevice:_device
                            renderDestinationProvider:self];

    [_renderer drawRectResized:_view.bounds.size];

    if(!_device)
    {
        NSLog(@"Metal is not supported on this device");
        self.view = [[UIView alloc] initWithFrame:self.view.frame];
    }
	
	statusLabel.text = @"...";
	
	// screen recording
	_rtr = [[ReplayTestRecorder alloc] init];
	[_rtr initializeWithCameraEnabled:NO microphoneEnabled:NO];
}

// Called whenever view changes orientation or layout is changed
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{
    [_renderer drawRectResized:view.bounds.size];
}

// Called whenever the view needs to render
- (void)drawInMTKView:(nonnull MTKView *)view
{
    @autoreleasepool
    {
		[_renderer update];
    }
}

// button handlers
- (IBAction)handleStartRecording:(id)sender {
	[_rtr startRecording];
	statusLabel.text = @"recording: ON";
}

- (IBAction)handleStopRecording:(id)sender {
	statusLabel.text = @"recording: OFF";
	[_rtr stopRecording];
	[_rtr displayVideoPreview:self];
}

- (IBAction)handleStartBroadcast:(id)sender {
	[_rtr startBroadcast:self];
	statusLabel.text = @"broadcasting: LIVE";
}

- (IBAction)handlePauseBroadcast:(id)sender {
	statusLabel.text = @"broadcasting: PAUSED";
	[_rtr pauseBroadcast];
}

- (IBAction)handleResumeBroadcast:(id)sender {
	statusLabel.text = @"broadcasting: RESUMED";
	[_rtr resumeBroadcast];
}

- (IBAction)handleStopBroadcast:(id)sender {
	statusLabel.text = @"broadcasting: STOPPED";
	[_rtr stopBroadcast];
}


// Methods to get and set state of the our ultimate render destination (i.e. the drawable)
# pragma mark RenderDestinationProvider implementation

- (MTLRenderPassDescriptor*) currentRenderPassDescriptor
{
    return _view.currentRenderPassDescriptor;
}

- (MTLPixelFormat) colorPixelFormat
{
    return _view.colorPixelFormat;
}

- (void) setColorPixelFormat: (MTLPixelFormat) pixelFormat
{
    _view.colorPixelFormat = pixelFormat;
}

- (MTLPixelFormat) depthStencilPixelFormat
{
    return _view.depthStencilPixelFormat;
}

- (void) setDepthStencilPixelFormat: (MTLPixelFormat) pixelFormat
{
    _view.depthStencilPixelFormat = pixelFormat;
}

- (NSUInteger) sampleCount
{
    return _view.sampleCount;
}

- (void) setSampleCount:(NSUInteger) sampleCount
{
    _view.sampleCount = sampleCount;
}

- (id<MTLDrawable>) currentDrawable
{
    return _view.currentDrawable;
}

@end

