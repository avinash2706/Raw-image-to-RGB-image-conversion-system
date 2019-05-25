# Raw image to RGB image conversion system


Given a Raw image from DSLR, this system will get the true RGB image from it.

- Initially linearized the raw image.
- Then explored Bayer mosaic pattern.
- RGGB pattern was found to be better among the four patterns. So continued further processing on this image.
- Processed this image to both GreyWorld and WhiteWorld assumptions. Found GreyWorld to be better, so further process done on this image.
- Finally the image was brightened for a better view.
