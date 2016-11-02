#!/usr/bin/env bash

#Kast default variables
kodiport="80"
kodiuser="kodi"
kodipass="kodi"
smbpath=""
kodiipone=""
kodiiptwo=""
kodiipthree=""
kodiipfour=""
kodiipfive=""

#Load config
confdir=$(printenv XDG_CONFIG_HOME)
if [ -z $confdir ]; then
	confdir="$HOME/.config"
fi
source "$confdir/Kast/config"

kasturl=$2

if [ -z "$1" ];
then
	OUTPUT=$(zenity --forms --title="Kast for Kodi" --text="" --separator=";" --add-entry="Device ID" --add-entry="URL / Path")
fi

zenid=$(awk -F";" '{print $1}' <<<$OUTPUT)
zenpath=$(awk -F";" '{print $2}' <<<$OUTPUT)

if [ -n "$zenid" ];
then
	1=${zenid}
fi

if [ -n "$zenpath" ];
then
	kasturl=${zenpath}
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
	kasturl=$1
else
	kodiip=${kodiipone}
fi
if [[ "${kasturl}" == *youtube.com* ]]
then
	vid=$( echo "${kasturl}" | tr '?&#' '\n\n' | grep -e '^v=' | cut -d'=' -f2 )
	purl='plugin://plugin.video.youtube/?action=play_video&videoid='${vid}
elif [[ "${kasturl}" == *youtu.be* ]]
then
	vid=$( echo "${kasturl}" | tr '?&#' '\n\n' | grep -e '/' | cut -d'/' -f4 )
	purl='plugin://plugin.video.youtube/?action=play_video&videoid='${vid}
elif [[ "${kasturl}" == *vimeo.com* ]]
then
	vid=$( echo "${kasturl}" | tr '?&#' '\n\n' | grep -e '/' | cut -d'/' -f4 )
	purl='plugin://plugin.video.vimeo/?action=play_video&videoid='${vid}
elif [[ "${kasturl}" == *thedailyshow.com* ]]
then
	vid=$( echo "${kasturl}" | perl -MURI::Escape -ne 'print uri_escape($_)' )
	vname=$( echo "${kasturl}" | grep -e '/' | cut -d'/' -f5 )
	if [[ "$" == *thedailyshow.com/watch* ]]
	then
		vname=$( echo "${kasturl}" | grep -e '/' | cut -d'/' -f6 )
	fi
	purl='plugin://plugin.video.the.daily.show/?url='${vid}'&mode=play&name='${vname}
elif [[ "${kasturl}" == *rt.com* ]]
then
	if [[ "${kasturl}" == *on-air/rt-america-air/* ]]
	then
		purl='plugin://plugin.video.rt/?url=rtmp%3A%2F%2Frt.fms-04.visionip.tv%2Flive%2Frt-america-live-HD&mode=12'
	elif [[ "${kasturl}" == *on-air/* ]]
	then
		purl='plugin://plugin.video.rt/?url=rtmp%3A%2F%2Frt.fms-04.visionip.tv%2Flive%2Frt-global-live-HD&mode=12'
	elif [[ "${kasturl}" == *arabic*/live* ]]
	then
		purl='plugin://plugin.video.rt/?url=rtmp%3A%2F%2Frt.fms-04.visionip.tv%2Flive%2Frt-rusiyaalyaum-live-HD&mode=12'
	elif [[ "${kasturl}" == *en_vivo* ]]
	then
		purl='plugin://plugin.video.rt/?url=rtmp%3A%2F%2Frt.fms-04.visionip.tv%2Flive%2Frt-enespanol-live-HD&mode=12'
	else
		vid=$( echo "${kasturl}" | perl -MURI::Escape -ne 'print uri_escape($_)' )
		vname=$( echo "${kasturl}" | grep -e '/' | cut -d'/' -f6 )
		purl='plugin://plugin.video.rt/?url=plugin%3A%2F%2Fplugin.video.rt%2F%3Furl%3D'${vid}'%26name%3D'${vname}'%26mode%3D19&mode=12'
	fi
elif [[ "${kasturl}" == *colbertnation.com* ]]
then
	vid=$( echo "${kasturl}" | perl -MURI::Escape -ne 'print uri_escape($_)' )
	vname=$( echo "${kasturl}" | grep -e '/' | cut -d'/' -f5 )
	purl='plugin://plugin.video.the.colbert.report/?url='${vid}'&mode=play&name='${vname}
elif [[ "${kasturl}" == *break.com* ]]
then
	vid=$( echo "${kasturl}" | awk -F"-" '{print ($(NF))}' )
	purl='plugin://plugin.video.break_com/?url='${vid}'&mode=playVideo'
elif [[ "${kasturl}" == *time.com* ]]
then
	vid=$( echo "${kasturl}" | tr '_' '\n\n' | grep -e '/' | cut -d'/' -f7 | cut -d',' -f3 )
	purl='plugin://plugin.video.time_com/?url='${vid}'&mode=playBrightCoveStream'
elif [[ "${kasturl}" == *collegehumor.com* ]]
then
	vid=$( echo "${kasturl}" | cut -c29- | perl -MURI::Escape -ne 'print uri_escape($_)' )
	purl='plugin://plugin.video.collegehumor/watch/'${vid}
elif [[ "${kasturl}" == *twitch.tv* ]]
then
	vid=$( echo "${kasturl}" | cut -c22- )
	purl='plugin://plugin.video.twitch/playLive/'${vid}'/'
elif [[ "${kasturl}" == *dailymotion.com* ]]
then
	vid=$( echo "${kasturl}" | cut -c34-41 )
	purl='plugin://plugin.video.dailymotion_com/?url='${vid}'&mode=playVideo'
elif [[ "${kasturl}" == *mixcloud.com* ]]
then
	vid=$( echo "${kasturl}" | cut -c24- | perl -MURI::Escape -ne 'print uri_escape($_)' )
	purl='plugin://plugin.audio.mixcloud/?mode=40&key='${vid}
elif [[ "${kasturl}" == *theonion.com* ]]
then
	vid=$( echo "${kasturl}" | perl -MURI::Escape -ne 'print uri_escape($_)' )
	purl='plugin://plugin.video.theonion_com/?url='${vid}'&mode=playVideo'
elif [[ "${kasturl}" == *cbsnews.com* ]]
then
	vid=$( echo "${kasturl}" | perl -MURI::Escape -ne 'print uri_escape($_)' )
	purl='plugin://plugin.video.cbsnews_com/?url='${vid}'&mode=playVideo'
elif [[ "${kasturl}" == *ign.com* ]]
then
	vid=$( echo "${kasturl}" | perl -MURI::Escape -ne 'print uri_escape($_)' )
	purl='plugin://plugin.video.ign_com/?url='${vid}'&mode=playVideo'
elif [[ "${kasturl}" == *howstuffworks.com* ]]
then
	vid=$( echo "${kasturl}" | perl -MURI::Escape -ne 'print uri_escape($_)' )
	purl='plugin://plugin.video.howstuffworks_com/?url='${vid}'&mode=playVideo'
elif [[ "${kasturl}" == *ustream.tv* ]]
then
	vid=$( echo "${kasturl}" | tr '?&#' '\n\n' | grep -e 'socialstream/' | cut -d'/' -f5 )
	purl='http://iphone-streaming.ustream.tv/ustreamVideo/'${vid}'/streams/live/playlist.m3u8'
elif [[ "${kasturl}" == *ebaumsworld.com* ]]
then
	vid=$( echo "${kasturl}" | grep -e '/' | cut -d'/' -f6 )
	purl='plugin://plugin.video.ebaumsworld_com/?url='${vid}'&mode=playVideo'
elif [[ "${kasturl}" == *roosterteeth.com* ]]
then
	vid=$( echo "${kasturl}" | tr '?&#' '\n\n' | grep -e '^id=' | cut -d'=' -f2 )
	purl='plugin://plugin.video.roosterteeth/?url='${vid}'&mode=3&name=Filename+Unvailable'
elif [[ "${kasturl}" == *aljazeera.com* ]]
then
	purl='plugin://plugin.video.aljazeera/live/'
elif [[ "${kasturl}" == *magnet:* ]]
then
	vid=$( echo "${kasturl}" | perl -MURI::Escape -ne 'print uri_escape($_)' )
	purl='plugin://plugin.video.xbmctorrent/play/'${vid}
elif [[ "${kasturl}" == *file://* ]]
then
	vid=$( echo "${kasturl}" | awk -F"file://$HOME" '{print ($(NF))}' )
	purl=${smbpath}${vid}
elif [[ "${kasturl}" == */home/* ]]
then
	vid=$( echo "${kasturl}" | awk -F"$HOME" '{print ($(NF))}' )
	purl=${smbpath}${vid}
else
	purl=${kasturl}
fi

payload='{"jsonrpc": "2.0", "method": "Player.Open", "params":{ "item": {"file" : "'${purl}'" }}, "id" : 1}'
kodipath="http://${kodiip}:${kodiport}/jsonrpc"

curl -v -u "${kodiuser}:${kodipass}" -d "${payload}" -H "Content-type:application/json" -X POST "${kodipath}"
