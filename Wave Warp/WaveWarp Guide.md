# Wave 0.6 Quick Guide

## Author: AyItzmatt

# Parameter Guide

## Primary Wave Settings

Height (Amp): The intensity of the wave. Higher values result in more dramatic displacement.

Width (Freq): The distance between wave peaks. Smaller values create a "tight" zig-zag, while larger values create long, gentle slopes.

Direction: The angle (0-360°) the wave travels. 90° is a standard vertical wave; 180° is horizontal.

Cycles/Loop: How many full wave rotations occur over the duration of the animation. Use 1 for a standard loop, or higher for faster motion.

## Secondary Wave

Enable Secondary Wave: Toggles the second layer of math.

Sec. Height/Width/Direction: Independent controls to overlay a different pattern.

Tip: Set the Secondary Wave to a different direction and frequency than the Primary to create complex "wind" or "liquid" looks.

# General & Animation

### Pinning:

None: The entire image moves freely.

Left/Right/Top/Bottom: The chosen side stays 100% stationary, while the opposite side receives 100% of the warp intensity. Perfect for flags or plants.

Frame Count: The total length of the animation you want to generate.

Live Preview: Toggle this to see the warp effect on your current frame in real-time as you move the sliders.

# Quick guide for making certain elements

## Waving Flag

Draw a flag pointing to the right.

Set Pinning to Left.

Set Direction to 90.

Set Cycles to 1.

Use a low Secondary Amp (e.g., 2 or 3) to add subtle fluttering.

## Rippling Water

Select your water area.

Set Direction to 0.

Use a high Width (Freq) and low Amp.

Set Cycles to 2 for faster ripples.

## Bubbling Acid/Slime

Enable Secondary Wave.

Set both wave Directions to different angles (e.g., 45° and 135°).

Set Cycles to different values (e.g., Primary: 1, Secondary: 2).

This creates a "clashing" interference pattern that looks like churning liquid.

# Notes

This script works best on transparent layers. If you use it on a "Background" layer, it may produce unexpected results.

For very large sprites over 128px or high frame counts, the generation process might take a few seconds as it calculates every pixel displacement.

If you cancel the dialog, the script automatically restores your original image to prevent permanent accidental warping.
