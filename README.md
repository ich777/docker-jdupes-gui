# DEPRECATED

# jdupes and jdupes-gui in Docker optimized for Unraid
jdupes is a command line program for identifying and taking actions upon duplicate files combined with jdupes-gui it becomes a usefull tool for identifying duplicated files on your server.

**A WORD OF WARNING:** jdupes IS NOT a drop-in compatible replacement for fdupes!

**ATTENTION:** A minor inconvenience is caused by the fact that the jdupes-gui script is single-threaded. This causes the application to seemingly hang when running long jobs like searching through large folders or deleting large batches of files. Please be patient, it is still working.

**WARNING:** Please always double check what you are deleting in the containers since this affects the files on your Server and you won't be able to recover them!!!

See the official GitHub repository for jdupes here: https://github.com/jbruchon/jdupes and jdupes-gui here: https://github.com/Pesc0/jdupes-gui

Please consider donating to the creators of jdupes and jdupes-gui

## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Can be deleted if you don't need a VNC password | /jdupes |
| CUSTOM_RES_W | Minimum of 1024 pixesl (leave blank for 1280 pixels) | 1280 |
| CUSTOM_RES_H | Minimum of 768 pixesl (leave blank for 850 pixels) | 850 |
| UMASK | Set permissions for newly created files | 000 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |

## Run example
```
docker run --name jdupes-gui -d \
    -p 8080:8080 \
    --env 'CUSTOM_RES_W=1280' \
    --env 'CUSTOM_RES_H=850' \
    --env 'UMASK=000' \
	--env 'UID=99' \
	--env 'GID=100' \
    --volume /path/to/yourfiles:/mnt/yourfiles \
    --restart=unless-stopped\
	ich777/jdupes-gui
```

### Webgui address: http://[SERVERIP]:[PORT]/vnc.html?autoconnect=true

## Set VNC Password:
 Please be sure to create the password first inside the container, to do that open up a console from the container (Unraid: In the Docker tab click on the container icon and on 'Console' then type in the following):

1) **su $USER**
2) **vncpasswd**
3) **ENTER YOUR PASSWORD TWO TIMES AND PRESS ENTER AND SAY NO WHEN IT ASKS FOR VIEW ACCESS**

Unraid: close the console, edit the template and create a variable with the `Key`: `TURBOVNC_PARAMS` and leave the `Value` empty, click `Add` and `Apply`.

All other platforms running Docker: create a environment variable `TURBOVNC_PARAMS` that is empty or simply leave it empty:
```
    --env 'TURBOVNC_PARAMS='
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/83786-support-ich777-application-dockers/