#!/usr/bin/env bash
set -ex

LOG_ERR=../err_log/`date +%Y-%m-%d_%H-%M-%S.log`

# execlファイルからcsvファイルを生成
function excelToCsv() {
    filename=$(basename $1 .xlsx)
    csv=$filename".csv"
    xlsx2csv $1 $csv
}

# csvファイルからgeojsonファイルを生成
function csvToGeojson() {
    filename=$(basename $1 .csv)
    geojson=$filename".geojson"
    sed -i '' "s/緯度/lat/" $1
    sed -i '' "s/経度/lon/" $1

    ogr2ogr -f GeoJSON $geojson $1 -oo X_POSSIBLE_NAMES=lat* -oo Y_POSSIBLE_NAMES=lon*
    if [ ! -e ../geojson_data ]; then mkdir ../geojson_data ; fi
    mv -f $geojson ../geojson_data
}

# geojsonファイルからpmtilesを生成
function geojsonToTile() {
    fileName='sample.pmtiles'
    tippecanoe -zg -o $fileName ../geojson_data/*
    if [ ! -e ../tile_data ]; then mkdir ../tile_data ; fi
    mv -f $fileName ../tile_data
}


# タイルの生成
function makeTile(){

    cd ../../data

    if [ -e ../geojson_data ]; then rm -rf ../geojson_data ; fi
    if [ -e ../tile_data ]; then rm -rf ../tile_data ; fi    

    ls | while read line
    do
        extension="."${line##*.}
        filename=$(basename $line $extension)

        case $extension in
            ".xlsx") echo "1"$line
                    excelToCsv $line
                    csvToGeojson $filename".csv";;
            ".csv") echo $line
                    csvToGeojson $line;;
        esac
    done

    geojsonToTile

}

makeTile
