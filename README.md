# DynamicWaterNode
2D physical water simulation for SpriteKit

![GIF](https://github.com/SteveBarnegren/DynamicWaterNode/raw/master/DynamicWater.gif)


# How to use

Add DynamicWaterNode.h, DynamicWaterNode.m, Droplet.png and Droplets.fsh to your project

Add to your scene:

```
- (void)didMoveToView:(SKView *)view {
     self.waterNode = [[DynamicWaterNode alloc]initWithWidth:self.size.width
                                                  numJoints:100
                                              surfaceHeight:kSurfaceHeight
                                                 fillColour:[UIColor colorWithRed:0 green:0 blue:1 alpha:0.5]];
    self.waterNode.position = CGPointMake(self.size.width/2, 0);
    [self addChild:self.waterNode];

}
```

Step the simulation in your scene’s update method. See demo project for an example of a fixed time step implementation

```
[self.waterNode update:dt];
```

Call render: after the simulation has been updated. Only call render once each frame.

```
[self.waterNode render];
```

Making splashes:

```
[self.waterNode splashAtX:100 force:20 width:20];
```

Various properties of DynamicWaterNode can be changed to control the feel of the water. The demo project includes a settings screen where you can alter these to see their effect.



