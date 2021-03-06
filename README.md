# Radio Roundabout Amazing Visualizer


Displays the world in blobs that pulse with sound.

Requirements:

* MS Kinect + power lead
* [Processing 1.5.1](http://processing.googlecode.com/files/processing-1.5.1-macosx.zip) (not tested in 2.0)
* [Minim 2.0](http://code.compartmental.net/minim/distro/minim-2.0.2-full.zip)
* [SimpleOpenNI](http://code.google.com/p/simple-openni/wiki/Installation)
* If you want to use anything other than the internal mic or line-in on the Mac as a soundcard, you'll need something like [Soundflower](http://cycling74.com/soundflower-landing-page/)

Install Processing, then SimpleOpenNI (using the shell script - you'll probably need sudo) and finally Minim. Install soundflower.

In System Preferences -> Sound, set Input to Line In (and "use audio jack as line-in") to use the audio in socket; Microphone to use ambient sound; or set Input and Output to Soundflower (if you want to use your Mac's system sounds to drive it.)

Then just run the .pde file. Cursor keys pivot viewpoint; shift up/down zoom in out; shift left/right translate it left and right. number keys 1-0 control the amount points are "grown"/multiplied by on pulse. Spacebar toggles mirroring.

That's about it, really.

