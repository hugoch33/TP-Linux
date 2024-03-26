#!/usr/bin/bash
# hugo
# 23/02/2024

_youtube_dl='/usr/local/bin/youtube-dl'

while [[ true ]]
do
        if [[ $(cat /srv/yt/youtube-url | head -n 1) =~ ^https:\/\/www\.youtube\.com\/watch\?v=[a-zA-Z0-9\_\-]{11}.*$ ]]
        then
            date=$(date +["%y/%m"/%d' '%H:%M:%S])

            if [[ ! -d "/srv/yt/download" ]]
            then
                mkdir /srv/yt/download
                echo "Le dossier 'download' a été créé."
            fi

            title=$($_youtube_dl -e $(cat /srv/yt/youtube-url | head -n 1))
            if [ ! -d /srv/yt/download/${title// /_} ]; then
                mkdir /srv/yt/download/${title// /_}
                $_youtube_dl $(cat /srv/yt/youtube-url | head -n 1) -o /srv/yt/download/${title// /_}/${title// /_}.mp4
            else
                echo "La vidéo est déjà téléchargée "
                continue
            fi
            description=$($_youtube_dl --get-description $(cat /srv/yt/youtube-url | head -n 1))
            touch /srv/yt/download/${title// /_}/description
            echo $description >> /srv/yt/download/${title// /_}/description
            echo "Video : $(cat /srv/yt/youtube-url | head -n 1)"
            echo "Path  : ${pwd}/${title// /_}/${title// /_}.mp4"

            echo "$date Video : $(cat /srv/yt/youtube-url | head -n 1) File path : ${pwd}/${title// /_}/${title// /_}.mp4" >> /var/log/yt/download.log
        else
        if [[ ! -z "$(cat /srv/yt/youtube-url | head -n 1)" ]]; then
                echo "Le dernier lien n'est pas une URL Youtube"
        fi
            
        fi
        sed -i '1d' /srv/yt/youtube-url
        sleep 1
done