#!/bin/bash
#Beamable Variables
beamurl=$2
kodiport="8080" #kodi webserver port (default = 80)
kodiuser="kodi" #kodi webserver user (default = kodi)
kodipass="kodi" #kodi webserver password (default = kodi)
smbpath="smb://BAAL" 
kodiipone="192.168.1.111" #kodi device IP (System -> System Info -> Summary)
kodiiptwo="192.168.1.101"
kodiipthree=""
kodiipfour=""
kodiipfive=""

if [ -z "$1" ];
then
OUTPUT=$(zenity --forms --title="Beamable" --text="" --separator=";" --add-entry="Device ID" --add-entry="URL / Path")
fi

zenid=$(awk -F";" '{print $1}' <<<$OUTPUT)
zenpath=$(awk -F";" '{print $2}' <<<$OUTPUT)

if [ -n "$zenid" ];
then
1=${zenid}
fi

if [ -n "$zenpath" ];
then
beamurl=${zenpath}
fi

if [[ "$1" == '1' ]]
then
	kodiip=${kodiipone}
elif [[ "$1" == '2' ]]
then
	kodiip=${kodiiptwo}
elif [[ "$1" == '3' ]]
then
	kodiip=${kodiipthree}
elif [[ "$1" == '4' ]]
then
	kodiip=${kodiipfour}
elif [[ "$1" == '5' ]]
then
	kodiip=${kodiipfive}
elif [[ "$1" == *http* ]]
then
	kodiip=${kodiipone}
	beamurl=$1
else
	kodiip=${kodiipone}
fi
if [[ "${beamurl}" == *youtube.com* ]]
then
	vid=$( echo "${beamurl}" | tr '?&#' '\n\n' | grep -e '^v=' | cut -d'=' -f2 )
	purl='plugin://plugin.video.youtube/?action=play_video&videoid='${vid}
elif [[ "${beamurl}" == *youtu.be* ]]
then
	vid=$( echo "${beamurl}" | tr '?&#' '\n\n' | grep -e '/' | cut -d'/' -f4 )
	purl='plugin://plugin.video.youtube/?action=play_video&videoid='${vid}
elif [[ "${beamurl}" == *vimeo.com* ]]
then
	vid=$( echo "${beamurl}" | tr '?&#' '\n\n' | grep -e '/' | cut -d'/' -f4 )
	purl='plugin://plugin.video.vimeo/?action=play_video&videoid='${vid}
elif [[ "${beamurl}" == *thedailyshow.com* ]]
then
	vid=$( echo "${beamurl}" | perl -MURI::Escape -ne 'print uri_escape($_)' )
	vname=$( echo "${beamurl}" | grep -e '/' | cut -d'/' -f5 )
	if [[ "$" == *thedailyshow.com/watch* ]]
	then
		vname=$( echo "${beamurl}" | grep -e '/' | cut -d'/' -f6 )
	fi
	purl='plugin://plugin.video.the.daily.show/?url='${vid}'&mode=play&name='${vname}
elif [[ "${beamurl}" == *rt.com* ]]
then
	if [[ "${beamurl}" == *on-air/rt-america-air/* ]]
	then
		purl='plugin://plugin.video.rt/?url=rtmp%3A%2F%2Frt.fms-04.visionip.tv%2Flive%2Frt-america-live-HD&mode=12'
	elif [[ "${beamurl}" == *on-air/* ]]
	then
		purl='plugin://plugin.video.rt/?url=rtmp%3A%2F%2Frt.fms-04.visionip.tv%2Flive%2Frt-global-live-HD&mode=12'
	elif [[ "${beamurl}" == *arabic*/live* ]]
	then
		purl='plugin://plugin.video.rt/?url=rtmp%3A%2F%2Frt.fms-04.visionip.tv%2Flive%2Frt-rusiyaalyaum-live-HD&mode=12'
	elif [[ "${beamurl}" == *en_vivo* ]]
	then
		purl='plugin://plugin.video.rt/?url=rtmp%3A%2F%2Frt.fms-04.visionip.tv%2Flive%2Frt-enespanol-live-HD&mode=12'
	else
		vid=$( echo "${beamurl}" | perl -MURI::Escape -ne 'print uri_escape($_)' )
		vname=$( echo "${beamurl}" | grep -e '/' | cut -d'/' -f6 )
		purl='plugin://plugin.video.rt/?url=plugin%3A%2F%2Fplugin.video.rt%2F%3Furl%3D'${vid}'%26name%3D'${vname}'%26mode%3D19&mode=12'
	fi
elif [[ "${beamurl}" == *colbertnation.com* ]]
then
	vid=$( echo "${beamurl}" | perl -MURI::Escape -ne 'print uri_escape($_)' )
	vname=$( echo "${beamurl}" | grep -e '/' | cut -d'/' -f5 )
	purl='plugin://plugin.video.the.colbert.report/?url='${vid}'&mode=play&name='${vname}
elif [[ "${beamurl}" == *break.com* ]]
then
	vid=$( echo "${beamurl}" | awk -F"-" '{print ($(NF))}' )
	purl='plugin://plugin.video.break_com/?url='${vid}'&mode=playVideo'
elif [[ "${beamurl}" == *time.com* ]]
then
	vid=$( echo "${beamurl}" | tr '_' '\n\n' | grep -e '/' | cut -d'/' -f7 | cut -d',' -f3 )
	purl='plugin://plugin.video.time_com/?url='${vid}'&mode=playBrightCoveStream'
elif [[ "${beamurl}" == *collegehumor.com* ]]
then
	vid=$( echo "${beamurl}" | cut -c29- | perl -MURI::Escape -ne 'print uri_escape($_)' )
	purl='plugin://plugin.video.collegehumor/watch/'${vid}
elif [[ "${beamurl}" == *twitch.tv* ]]
then
	vid=$( echo "${beamurl}" | cut -c22- )
	purl='plugin://plugin.video.twitch/playLive/'${vid}'/'
elif [[ "${beamurl}" == *dailymotion.com* ]]
then
	vid=$( echo "${beamurl}" | cut -c34-41 )
	purl='plugin://plugin.video.dailymotion_com/?url='${vid}'&mode=playVideo'
elif [[ "${beamurl}" == *mixcloud.com* ]]
then
	vid=$( echo "${beamurl}" | cut -c24- | perl -MURI::Escape -ne 'print uri_escape($_)' )
	purl='plugin://plugin.audio.mixcloud/?mode=40&key='${vid}
elif [[ "${beamurl}" == *theonion.com* ]]
then
	vid=$( echo "${beamurl}" | perl -MURI::Escape -ne 'print uri_escape($_)' )
	purl='plugin://plugin.video.theonion_com/?url='${vid}'&mode=playVideo'
elif [[ "${beamurl}" == *cbsnews.com* ]]
then
	vid=$( echo "${beamurl}" | perl -MURI::Escape -ne 'print uri_escape($_)' )
	purl='plugin://plugin.video.cbsnews_com/?url='${vid}'&mode=playVideo'
elif [[ "${beamurl}" == *ign.com* ]]
then
	vid=$( echo "${beamurl}" | perl -MURI::Escape -ne 'print uri_escape($_)' )
	purl='plugin://plugin.video.ign_com/?url='${vid}'&mode=playVideo'
elif [[ "${beamurl}" == *howstuffworks.com* ]]
then
	vid=$( echo "${beamurl}" | perl -MURI::Escape -ne 'print uri_escape($_)' )
	purl='plugin://plugin.video.howstuffworks_com/?url='${vid}'&mode=playVideo'
elif [[ "${beamurl}" == *ustream.tv* ]]
then
	vid=$( echo "${beamurl}" | tr '?&#' '\n\n' | grep -e 'socialstream/' | cut -d'/' -f5 )
	purl='http://iphone-streaming.ustream.tv/ustreamVideo/'${vid}'/streams/live/playlist.m3u8'
elif [[ "${beamurl}" == *ebaumsworld.com* ]]
then
	vid=$( echo "${beamurl}" | grep -e '/' | cut -d'/' -f6 )
	purl='plugin://plugin.video.ebaumsworld_com/?url='${vid}'&mode=playVideo'
elif [[ "${beamurl}" == *roosterteeth.com* ]]
then
	vid=$( echo "${beamurl}" | tr '?&#' '\n\n' | grep -e '^id=' | cut -d'=' -f2 )
	purl='plugin://plugin.video.roosterteeth/?url='${vid}'&mode=3&name=Filename+Unvailable'
elif [[ "${beamurl}" == *aljazeera.com* ]]
then
	purl='plugin://plugin.video.aljazeera/live/'
elif [[ "${beamurl}" == *magnet:* ]]
then
	vid=$( echo "${beamurl}" | perl -MURI::Escape -ne 'print uri_escape($_)' )
	purl='plugin://plugin.video.xbmctorrent/play/'${vid}
elif [[ "${beamurl}" == *file://* ]]
then
	vid=$( echo "${beamurl}" | awk -F"file://$HOME" '{print ($(NF))}' )
	purl=${smbpath}${vid}
elif [[ "${beamurl}" == */home/* ]]
then
	vid=$( echo "${beamurl}" | awk -F"$HOME" '{print ($(NF))}' )
	purl=${smbpath}${vid}
else
	purl=${beamurl}
fi

payload='{"jsonrpc": "2.0", "method": "Player.Open", "params":{ "item": {"file" : "'${purl}'" }}, "id" : 1}'
kodipath="http://${kodiip}:${kodiport}/jsonrpc"

curl -v -u "${kodiuser}:${kodipass}" -d "${payload}" -H "Content-type:application/json" -X POST "${kodipath}"
