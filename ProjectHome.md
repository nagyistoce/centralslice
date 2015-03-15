An undergraduate group project to simulate computerized tomography using Matlab.

## Useful Links ##
[CTSim](http://ctsim.org/)
A very good CT simulation software. The only drawback is that it does not provide instruction for Direct Fourier Reconstruction.

## Aims ##
  * To be able to simulate CT reconstruction using Central Slice Theorem
  * To study a number of factors on image reconstruction:
    1. Number of sensors
    1. Number of projection slices
    1. Scan angle range
    1. Noise
    1. Sensor damage


## Schedule ##
| Date | Remark |
|:-----|:-------|
| 24 Feb | Project starts |
| 6 March | First successful reconstruction |
| 8 March | Studied effect of noise, sensor damage, motion error... etc |
| 9 March | Finished powerpoint slides |
| 10 March | Finished Report |
| 11 Mar | Project Presentation and submission of Report |

## Report ##
Please go to **Downloads** page to download our Report:

http://code.google.com/p/centralslice/downloads/detail?name=MEDE%202007%20report.pdf

## Simulation Program ##

### Program summary ###
  1. Generate a phantom
  1. Apply Radon Transform from theta=0deg to theta=180deg
  1. Do 1D Fourier Transform to each angle theta
  1. Interpolate data to change from polar coordinates to rectangular coordinates
  1. Apply inverse 2D Fourier Transforms.

### Matlab Source ###
Source code is captured every 5~10 revisions and uploaded in the Downloads section:

http://code.google.com/p/centralslice/downloads/list

To view the latest modifications, check the following link:

http://code.google.com/p/centralslice/source/list

### Code Documentation ###
Online version:

http://centralslice.googlecode.com/svn/branches/doc/files.html

Printable version:

http://code.google.com/p/centralslice/downloads/detail?name=code_documentation.pdf

### Results ###
Here is the model in the simulation:

[Phantom.png](http://centralslice.googlecode.com/svn/trunk/Phantom.png)

The interpolated Fourier Space it shown here:

[Interpolated\_Fourier\_Space\_(log\_scale).png](http://centralslice.googlecode.com/svn/trunk/Interpolated_Fourier_Space_(log_scale).png)

And here is the reconstructed image (which is buggy):

[Reconstructed\_Image.png](http://centralslice.googlecode.com/svn/trunk/Reconstructed_Image.png)