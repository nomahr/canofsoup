//
//  ReplayTestRecorder.m
//

#import "ReplayTestRecorder.h"

@implementation ReplayTestRecorder

RPScreenRecorder* _screenRecorder;
RPPreviewViewController* _screenPreviewController;

RPBroadcastActivityViewController* _broadcastActivityController;
RPBroadcastController* _broadcastController;

BOOL _bCameraEnabled;
BOOL _bMicrophoneEnabled;


- (void) initializeWithCameraEnabled:(BOOL)bCameraEnabled microphoneEnabled:(BOOL)bMicrophonEnabled {
	_screenRecorder = [RPScreenRecorder sharedRecorder];
	[_screenRecorder setDelegate:self];
	
	_bCameraEnabled = bCameraEnabled;
	_bMicrophoneEnabled = bMicrophonEnabled;
}

- (void)startRecording {
	// NOTE(omar): stop any live broadcasts before staring a local recording
	if( [_broadcastController isBroadcasting] ) {
		[self stopBroadcast];
	}
	
	if( [_screenRecorder isAvailable] ) {
		[_screenRecorder setCameraEnabled:_bCameraEnabled];
		[_screenRecorder setMicrophoneEnabled:_bMicrophoneEnabled];
		[_screenRecorder startRecordingWithHandler:^(NSError * _Nullable error) {
			if( error ) {
				NSLog( @"error starting screen recording");
			}
		}];
	}
	
}

- (void)stopRecording {
	if( [_screenRecorder isAvailable] && [_screenRecorder isRecording] ) {
		[_screenRecorder stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
			[previewViewController setPreviewControllerDelegate:self];
			_screenPreviewController = previewViewController;
		}];
	}
}

- (void)displayVideoPreview:( UIViewController* )uiViewController {
	if( _screenPreviewController ) {
		[uiViewController presentViewController:_screenPreviewController animated:YES completion:nil];
	}
}

//
// livestreaming functionality
//

- (void)startBroadcast:( UIViewController* _Nullable )uiViewController {
	// NOTE(omar): ending any local recordings that might be active before starting a broadcast
	if( [_screenRecorder isRecording] ) {
		[self stopRecording];
	}
	
	[RPBroadcastActivityViewController loadBroadcastActivityViewControllerWithHandler:^(RPBroadcastActivityViewController * _Nullable broadcastActivityViewController, NSError * _Nullable error) {
		_broadcastActivityController = broadcastActivityViewController;
		[_broadcastActivityController setDelegate:self];
		[uiViewController presentViewController:broadcastActivityViewController animated:YES completion:nil];
	}];
}

- (void)pauseBroadcast {
	if( [_broadcastController isBroadcasting] ) {
		[_broadcastController pauseBroadcast];
	}
}

- (void)resumeBroadcast {
	if( [_broadcastController isPaused] ) {
		[_broadcastController resumeBroadcast];
	}
}

- (void)stopBroadcast {
	if( [_broadcastController isBroadcasting ] ) {
		[_broadcastController finishBroadcastWithHandler:^(NSError * _Nullable error) {
			if( error ) {
				NSLog( @"error finishing broadcast" );
			}
		}];
	}
}

//
// delegates
//

// screen recorder delegate
- (void)screenRecorder:(RPScreenRecorder *)screenRecorder didStopRecordingWithError:(NSError *)error previewViewController:(nullable RPPreviewViewController *)previewViewController {
	NSLog(@"RTRScreenRecorderDelegate::didStopRecrodingWithError");
	
	[previewViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)screenRecorderDidChangeAvailability:(RPScreenRecorder *)screenRecorder {
	NSLog(@"RTRScreenRecorderDelegate::screenRecorderDidChangeAvailability");
}

// screen recorder preview view controller delegate
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
	NSLog( @"RTRPreviewViewControllerDelegate::previewControllerDidFinish" );
	[previewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet <NSString *> *)activityTypes __TVOS_PROHIBITED {
	NSLog( @"RTRPreviewViewControllerDelegate::didFinishWithActivityTypes" );
}

// broadcast activity view controller delegate
- (void)broadcastActivityViewController:(RPBroadcastActivityViewController *)broadcastActivityViewController didFinishWithBroadcastController:(nullable RPBroadcastController *)broadcastController error:(nullable NSError *)error {
	NSLog( @"RPBroadcastActivityViewControllerDelegate::didFinishWithBroadcastController" );
	
	[broadcastActivityViewController dismissViewControllerAnimated:YES completion:^{
		_broadcastController = broadcastController;
		[_broadcastController startBroadcastWithHandler:^(NSError * _Nullable error) {
			if( error ) {
				NSLog( @"error starting broadcast" );
			}
		}];
	}];
}

// broadcast controller delegate
- (void)broadcastController:(RPBroadcastController *_Nullable)broadcastController didFinishWithError:(NSError * __nullable)error {
	NSLog( @"RPBroadcastControllerDelegate::didFinishWithError" );
}

- (void)broadcastController:(RPBroadcastController *_Nullable)broadcastController didUpdateServiceInfo:(NSDictionary <NSString *, NSObject <NSCoding> *> *_Nullable)serviceInfo {
	NSLog( @"RPBroadcastControllerDelegate::didUpdateServiceInfo" );
}

@end
