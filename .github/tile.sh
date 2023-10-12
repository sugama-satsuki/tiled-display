#!/usr/bin/env bash

git clone https://github.com/mapbox/tippecanoe.git
cd tippecanoe
make -j
sudo make install
cd ..

tippecanoe -v

set -ex

cd ./data
xlsx2csv 12_suisyou_koukyoushisetu-1.xlsx 12_suisyou_koukyoushisetu-1.csv
sed -i'' "s/緯度/lat/" 12_suisyou_koukyoushisetu-1.csv
sed -i'' "s/経度/lon/" 12_suisyou_koukyoushisetu-1.csv
ogr2ogr -f GeoJSON 12_suisyou_koukyoushisetu-1.geojson 12_suisyou_koukyoushisetu-1.csv -oo X_POSSIBLE_NAMES=lat* -oo Y_POSSIBLE_NAMES=lon*
tippecanoe -zg -o 'sample.pmtiles' *.geojson
mv -f 'sample.mbtiles' ../
ls ../
pwd


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
