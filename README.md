# Lightroom
## Lightroom Plug-in: Convert Tags to Flags
A simple plug-in to convert Colors or Stars to Lightroom Flags. I wrote this plug-in to solve a very simple problem I had incorporating Photo Mechanic into my workflow. In lightroom I use flags and Photo Mechanic only offers Rating or Color. This plug-in solves the problem by converting the selected option of colors or rating (stars) into flags: flagged, unflagged, or rejected. 

I have only tested it with [Adobe PhotoShop Lightroom](http://www.adobe.com/products/photoshop-lightroom.html) CC 1015.10.1 (6.10.1.10) on Windows 10. You do not need [Photo Mechanic](http://www.camerabits.com/) 5.0 to make it work. Any external editor that supports color or rating will do provided, once imported into Lightroom, the rating and/or color labels show up.

### Change Log
0.6 - Added a conditional that will reset rating to 0 or color to none. It only does the reset of the chosen flagging scheme and not both (even if selected). If you use color it will reset color. If you use rating it will reset rating, not both. I also added a more granular undo label.

### Installation
1. Download the folder tags2flags.lrdevplugin and all files contained within.
2. Open Lightroom and Launch the Plug-in Manager.
3. Click Add and select the tags2flags.lrdevplugin folder.
4. Configure the plug-in to use either Color or Rating and select the scheme you wish to use.
5. Close the Plug-in Manager.

### Using the plug-in
1. Select the images you wish to "convert".
2. While in the Library module, launch the plug-in: **Library | Plug-in Extras | Convert Colors to Flags**. On Windows you can use [ALT][L][U][L]. The colors or labels will be converted without confirmation. The changes are sent to the undo history in the event you need to roll them back.

### Demo Video
<a href="http://www.youtube.com/watch?feature=player_embedded&v=UtW6FXZ_GEU" target="_blank"><img src="http://img.youtube.com/vi/UtW6FXZ_GEU/0.jpg" alt="Video Instructions" width="480" height="360" border="10" /></a>


<!--More MD @ https://github.com/primer/markdown/blob/master/README.md -->