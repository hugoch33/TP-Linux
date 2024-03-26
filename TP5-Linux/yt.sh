#!/usr/bin/bash
# hugo
# 7/03/2024

_youtube_dl='/usr/local/bin/youtube-dl'

if [[ -z $1 ]]
then
    echo "Veuillez insérer un lien"
    exit
fi

if [[ ! $1 =~ ^https:\/\/www\.youtube\.com\/watch\?v=[a-zA-Z0-9\_\-]{11}.*$ ]] 
then
    echo "Le lien n'est pas valide"
    exit
fi        

date=$(date +["%y/%m"/%d' '%H:%M:%S])

if [[ ! -d "download" ]]
then
    mkdir download
    echo "Le dossier 'download' a été créé."
fi

title=$($_youtube_dl -e $1)
if [ ! -d download/${title// /_} ]; then
    mkdir download/${title// /_}
    $_youtube_dl $1 -o download/${title// /_}/${title// /_}.mp4
else
    echo "La vidéo est déjà téléchargée "
    exit
fi

description=$($_youtube_dl --get-description $1)
touch download/${title// /_}/description
echo $description >> download/${title// /_}/description
echo "Video : $1"
echo "Path  : ${pwd}/${title// /_}/${title// /_}.mp4"

echo "$date Video : $1 File path : ${pwd}/${title// /_}/${title// /_}.mp4" >> /var/log/yt/download.log