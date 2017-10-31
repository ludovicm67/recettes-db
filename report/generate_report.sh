#!/bin/sh

# script pour générer mon rapport
# nécessite :
#   - pandoc

pandoc --toc\
  -V geometry:left=2cm,right=2cm,top=4cm,bottom=2cm\
  -V lang=fr -V fontsize=12pt\
  report.md -o report.pdf
