#!/bin/sh

# script pour générer mon rapport (nécessite pandoc)

cat report.md \
  | sed 's/^<!-- \\newpage -->$/\\newpage/' \
  | pandoc --toc\
    -V geometry:left=2cm,right=2cm,top=4cm,bottom=2cm \
    -V lang=fr -V fontsize=12pt \
    -o report.pdf
