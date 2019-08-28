#!/bin/bash

# gives a flat two-dimensional label a three-dimensional look with rich textures and simulated depth
convert label.gif +matte \( +clone -shade 110x90 -normalize -negate +clone -compose Plus -composite \) \( -clone 0 -shade 110x50 -normalize -channel BG -fx 0 +channel -matte \) -delete 0 +swap -compose Multiply -composite button.gif

# percent completion of a task as a shaded cylinder
convert -size 320x90 canvas:none -stroke snow4 -size 1x90 -tile gradient:white-snow4 -draw 'roundrectangle 16, 5, 304, 85 20,40' +tile -fill snow -draw 'roundrectangle 264, 5, 304, 85  20,40' -tile gradient:chartreuse-green -draw 'roundrectangle 16,  5, 180, 85  20,40' -tile gradient:chartreuse1-chartreuse3 -draw 'roundrectangle 140, 5, 180, 85  20,40' +tile -fill none -draw 'roundrectangle 264, 5, 304, 85 20,40' -strokewidth 2 -draw 'roundrectangle 16, 5, 304, 85 20,40' \( +clone -background snow4 -shadow 80x3+3+3 \) +swap -background none -layers merge \( +size -font Helvetica -pointsize 90 -strokewidth 1 -fill red label:'50 %' -trim +repage \( +clone -background firebrick3 -shadow 80x3+3+3 \) +swap -background none -layers merge \) -insert 0 -gravity center -append -background white -gravity center -extent 320x200 cylinder_shaded.png

