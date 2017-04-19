//
//  GameViewController.h
//  RemoteNotes2
//
//  Created by Omar A Rodriguez on 4/18/17.
//  Copyright © 2017 Omar A Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import "Renderer.h"

// Our view controller.  Implements the MTKViewDelegate protocol, which allows it to accept
//   per-frame update and drawable resize callbacks.  Also implements the RenderDestinationProvider
//   protocol, which allows our renderer object to get and set drawable properties such as pixel
//   format and sample count

@interface GameViewController : UIViewController<MTKViewDelegate, RenderDestinationProvider>

@end


