#!/usr/bin/env bash

# git clone https://github.com/mapbox/tippecanoe.git
# cd tippecanoe
# make -j
# sudo make install
# cd ..

# tippecanoe -v

set -ex

cd ./data
xlsx2csv suisyou_koukyoushisetu-1.xlsx suisyou_koukyoushisetu-1.csv
ogr2ogr -f GeoJSON suisyou_koukyoushisetu-1.geojson suisyou_koukyoushisetu-1.csv -oo X_POSSIBLE_NAMES=緯度* -oo Y_POSSIBLE_NAMES=経度*
tippecanoe -zg -o 'sample.pmtiles' *.geojson
mv -f 'sample.pmtiles' ../
cd ../
pwd
ls


# # execlファイルからcsvファイルを生成
# function excelToCsv() {
#     filename=$(basename $1 .xlsx)
#     xlsx2csv $1 $filename".csv"
# }

# # csvファイルからgeojsonファイルを生成
# function csvToGeojson() {
#     filename=$(basename $1 .csv)
#     sed -i'' "s/緯度/lat/" $1
#     sed -i'' "s/経度/lon/" $1

#     ogr2ogr -f GeoJSON $filename".geojson" $1 -oo X_POSSIBLE_NAMES=lat* -oo Y_POSSIBLE_NAMES=lon*
# }

# # geojsonファイルからpmtilesを生成
# function geojsonToTile() {
#     fileName='sample.mbtiles'
#     tippecanoe -zg -o $fileName *.geojson
#     pwd
# }

# タイルの生成
# function makeTile(){
#     cd ./data
#     ls | while read line
#     do
#         extension="."${line##*.}
#         filename=$(basename $line $extension)

#         case $extension in
#             ".xlsx") excelToCsv $line
#                     csvToGeojson $filename".csv";;
#             ".csv") csvToGeojson $line;;
#         esac
#     done
#     geojsonToTile
# }
# makeTile
