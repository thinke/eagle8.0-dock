
KEY=$(xauth list  |grep $(hostname) | awk '{ print $3 }' | head -n 1)
DCK_HOST=eagle-dock
xauth add $DCK_HOST/unix:0 . $KEY
uid=$(id -u)
id=$(id -g)

if [ ! -d $HOME/eagle-8 ]; then
  mkdir $HOME/eagle-8
fi

docker run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v $HOME/.Xauthority:/tmp/.Xauthority \
           -v /dev/snd:/dev/snd \
	   -v $HOME/eagle-8:/home/eagle/eagle \
	   -v $HOME/.eagle8-rc:/home/eagle/.eaglerc \
           -v /dev/shm:/dev/shm \
    	   -v /etc/machine-id:/var/lib/dbus/machine-id \
           -v /run/user/$uid/pulse:/run/user/$uid/pulse \
           -v /var/lib/dbus:/var/lib/dbus \
	   -v ~/.pulse:/home/eagle/.pulse \
           -e DISPLAY=$DISPLAY \
           -e XAUTHORITY=/tmp/.Xauthority  \
           -h $DCK_HOST \
eagle-dock:8.0.0
