#!/bin/bash

install_ross(){
    #Desinstalamos primero de todo ros
    sudo apt-get purge ros-*
    sudo apt-get autoremove
    sudo rm -r catkin_ws
    sed -i '\?^source /opt/ros/melodic/setup.bash?d' /home/pablo/.bashrc
    sed -i '\?^source /home/pablo/catkin_ws/devel/setup.bash?d' /home/pablo/.bashrc
    sudo rm /etc/ros/rosdep/sources.list.d/20-default.list


    #Instalamos ros
    #setup sources list
    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    #setupkeys
    sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
    #installation
    sudo apt update
    sudo apt install ros-melodic-desktop-full
    apt search ros-melodic
    #environment setup
    echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
    source ~/.bashrc    #There's a manual option: source /opt/ros/melodic/setup.bash
    #intall dependencies for building packages
    sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential
    sudo apt install python-rosdep
    sudo rosdep init
    rosdep update
    echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
    source ~/.bashrc  
}

new_dir(){
    cd /home/$USER
    rm -r catkin_ws
    source /opt/ros/melodic/setup.bash
    mkdir -p ~/catkin_ws/src
    cd ~/catkin_ws/
    catkin_make
    source devel/setup.bash
    echo "source /home/pablo/catkin_ws/devel/setup.bash" >> ~/.bashrc
}

crbackup(){
    today="$(date '+%d\%m\%y_%H:%M:%S')"
    newname="catkin_ws($today)"
    sudo mkdir /home/$USER/catkin_ws_backups/$newname
    sudo cp -r /home/$USER/catkin_ws/** /home/$USER/catkin_ws_backups/$newname
    echo "~/catkin_ws_backups/$newname created."
}

run(){
	exiting=false
	rosclean purge
	cd /home/$USER/catkin_ws
	gnome-terminal	gnome-terminal --tab --title="NODE_ROSCORE" --command="bash -c ' roscore; $SHELL'"
	#gnome-terminal	gnome-terminal --tab --title="NODE_GRID" --command="bash -c ' rosrun ejerciciogrid  ejerciciogrid_node; $SHELL'"
	#gnome-terminal	gnome-terminal --tab --title="NODE_PURSUIT" --command="bash -c ' rosrun envpurepursuit envpurepursuit_node; $SHELL'"
	#gnome-terminal	gnome-terminal --tab --title="NODE_MARKER" --command="bash -c ' rosrun ejemplo_marker  ejemplo_marker_node; $SHELL'"
	gnome-terminal --tab --title="RVIZ" --command="bash -c ' rosrun rviz rviz -d /home/pablo/RVIZ_CONFIG/gmapping_config.rviz; $SHELL'"
	gnome-terminal --tab --title="RUN_GAZEBO" --command="bash -c ' roslaunch --wait p3dx_gazebo gazebo.launch; $SHELL'"
	gnome-terminal --tab --title="TELEOP" --command="bash -c ' rosrun teleop_twist_keyboard teleop_twist_keyboard.py cmd_vel:=/p3dx/cmd_vel; $SHELL'"

	while [ $exiting == false ]; do
	  echo  $'\n'"Opciones:"
		echo " [s|slam]    	Iniciar SLAM"
		echo " [l|load]   	Cargar Mapa"
		echo " [m|move]   	Cargar mapa e iniciar localizacion"
		echo " [e|end|exit]   	Salir"
		echo " [s|save]    	Guardar Mapa"
		echo " [i|image]    	Guardar imagen"
	  read fun

	  case ${fun} in
	    s|slam ) # map
		echo $'\n'$'\n'"Creating map: ETSII_MAP_$(date '+%d\%m\%y_%H:%M:%S')"	
		gnome-terminal	gnome-terminal --tab --title="NODE_GMAP" --command="bash -c ' rosrun gmapping slam_gmapping scan:=/p3dx/laser/scan _odom_frame:=odom; $SHELL'"
		;;
	    l|load ) # load map
		last_map=$(ls /home/pablo/catkin_ws/maps/ | grep yaml | head -1)
		echo $'\n'$'\n'"Loading map: $last_map"
		gnome-terminal --tab --title="MAP" --command="bash -c ' rosrun map_server map_server /home/pablo/catkin_ws/maps/$last_map; $SHELL'"
		kill $PPID	
		;;
	    m|move ) # move robot
		last_map=$(ls /home/pablo/catkin_ws/maps/ | grep yaml | tail -1)
		echo $'\n'$'\n'"Loading map: $last_map"
		gnome-terminal --tab --title="MOVE" --command="bash -c ' roslaunch amcl amcl_diff.launch scan_topic_:=p3dx/laser/scan map_file:='/home/pablo/catkin_ws/maps/$last_map'; $SHELL'"
		echo "Localizing"
		gnome-terminal --tab --title="GOALS" --command="bash -c ' rosrun move_base move_base odom:=p3dx/odom; $SHELL'"
		gnome-terminal --tab --title="DOOR_DETECTOR" --command="bash -c ' rosrun topomapping topomapping_node; $SHELL'"
		gnome-terminal --tab --title="TOPO_MAP" --command="bash -c ' rosrun topomapping toponode_node; $SHELL'"
		gnome-terminal --tab --title="GOOGLE" --command="bash -c ' rosrun topomapping room_name_generator.py; $SHELL'"
		;;
	    e|end|exit ) #end
		echo $'\n'$'\n'"Killing on exit"
		exiting=true
		pkill -f gmapping
		pkill -f ejemplo_marker
		pkill -f envpurepursuit
		pkill -f ejerciciogrid
		pkill -f rviz
		pkill -f gazebo
		pkill -f roscore
		pkill -f teleop
		pkill -f rosbag
		pkill -f move_base
		pkill -f hector_exploration
		pkill -f mapping
		pkill -f hector_exploration_controller
		pkill -f hector_path_follower
		pkill -f map_server
		pkill -f amcl
		pkill -f image_view
		;;
	    s|save ) #save map
		echo "Saving map in /home/$USER/catkin_ws/maps/"
		gnome-terminal	gnome-terminal --tab --title="SAVING" --command="bash -c ' rosrun map_server map_saver -f /home/pablo/catkin_ws/maps/ETSII_MAP_$(date '+%d\%m\%y_%H:%M:%S'); $SHELL'"
		kill $PPID
		;;
	    i|image ) #save image
		cd /home/pablo/catkin_ws/images
		gnome-terminal	gnome-terminal --tab --title="IMS" --command="bash -c ' rosrun image_view image_saver image:=/rrbot/camera1/image_raw __name:=image_saver; $SHELL'"

		;;
	    \? ) echo "Opcion invalida. Opciones:"
		 echo " [-m|map]    	Iniciar SLAM"
		 echo " [-l|load]   	Cargar Mapa"
		 echo " [-e|end|exit]   Salir"
		 echo " [-s|save]    	Guardar Mapa"
		;;
	    : ) echo "Opcion invalida. Opciones:"
		 echo " [-m|map]    	Iniciar SLAM"
		 echo " [-l|load]   	Cargar Mapa"
		 echo " [-e|end|exit]   Salir"
		 echo " [-s|save]    	Guardar Mapa"
		;;
	    * ) echo "Opcion invalida. Opciones:"
		 echo " [-m|map]    	Iniciar SLAM"
		 echo " [-l|load]   	Cargar Mapa"
		 echo " [-e|end|exit]   Salir"
		 echo " [-s|save]    	Guardar Mapa"
		;;
	  esac
	done
}

compile(){
    cd ~/catkin_ws/
    catkin_make
    source devel/setup.bash
}

while getopts ":idbcrgo" opt; do
  case ${opt} in
    i ) # installing ros
        echo "installing ros"
        install_ross;;
    d ) # new dir
        echo "Restoring workspace. This will delete your current WS"
	echo "You sure? [Y/N]"
	read sure
        if [[ $sure == *"y"* ]] ||  [[ $sure == *"Y"* ]]; then new_dir; fi;;
    b ) #create backup
        echo "creating backup"
        crbackup;;
    r ) #create backup
        echo "Running..."
        run;;
    c ) #create backup
        echo "Compiling..."
        compile;;
    --go ) #create backup
        echo "Initialicing"
        compile
	echo "Running..."
	run;;
    \? ) echo "Opcion invalida. Opciones:"
         echo " [-i]    Reinstall Ros"
         echo " [-d]    Crear catkin_ws en blanco"
         echo " [-b]    Crear una copia de seguridad"
	 echo " [-r]    Lanzar simulacion"
	 echo " [-c]    Compilar entorno"
	 echo " [-go]   Compilar y lanzar"
        ;;
    : ) echo "Error requiere un argumento:"
         echo " [-r]    Reinstall Ros"
         echo " [-d]    Crear catkin_ws en blanco"
         echo " [-b]    Crear una copia de seguridad"
        ;;
    * ) echo "kk:"
         echo " [-r]    Reinstall Ros"
         echo " [-d]    Crear catkin_ws en blanco"
         echo " [-b]    Crear una copia de seguridad"
        ;;
  esac
done
