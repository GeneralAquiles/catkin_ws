#include "ros/ros.h"
#include "geometry_msgs/Twist.h"
#include "tf/tf.h"
#include "nav_msgs/Odometry.h"
#include "geometry_msgs/Pose2D.h"
#include "std_msgs/Float64.h"
#include "sensor_msgs/LaserScan.h"

#include <sstream>

using namespace std; 

geometry_msgs::Twist msgconsigna;
geometry_msgs::Pose2D pose2d;
float xobj, yobj;
sensor_msgs::LaserScan laserdatos;
float v;
const float pi = 3.14159265;
bool aplicavelocidad;

void actualizarpuntoobjetivoapartirlaser(float &xobj, float &yobj, bool &apvel, float amin, float rmin, float rmax, float inca, std::vector<float>r, int n){
	int indice;
        bool enc = false;
	int i;
	float distanciaobjetivocomomaximo = rmax - 1;
	for (i = 0; (i < n) && (!enc); i++){
		if ((r[i] < distanciaobjetivocomomaximo) && (r[i] > rmin)){
			indice = i;
			enc = true;
		}
	}
	if (enc){
		float d = r[i];
		float angulo = i*inca + amin;
		xobj = d * cos(angulo);
		yobj = d * sin(angulo);
		cout << "Punto objetivo: (" << xobj << ", " << yobj << ") con angulo " << angulo << "\n";
	}
	else{
		xobj = pose2d.x;
		yobj = pose2d.y;
		
	}
	apvel = enc;
	
}

void obtenerdatosscannerlaser (const sensor_msgs::LaserScan::ConstPtr& msg){
	int numerodemuestras = (msg->angle_max - msg->angle_min)/msg->angle_increment;
	actualizarpuntoobjetivoapartirlaser(xobj, yobj, aplicavelocidad, msg->angle_min, msg->range_min, msg->range_max, msg->angle_increment, msg->ranges, numerodemuestras);
	
	
}

void obtenerposicionactualodom (const nav_msgs::Odometry::ConstPtr& msg){
   pose2d.x = msg->pose.pose.position.x;
   pose2d.y = msg->pose.pose.position.y;
   tf::Quaternion q(msg->pose.pose.orientation.x,
			msg->pose.pose.orientation.y,
			msg->pose.pose.orientation.z,
			msg->pose.pose.orientation.w);
   tf::Matrix3x3 m(q);
   double roll, pitch, yaw;
   m.getRPY(roll, pitch, yaw);
   pose2d.theta = yaw;
}

void obtenerv (const std_msgs::Float64::ConstPtr& msg){
  if (aplicavelocidad)
  	v = msg->data;
  else
	v = 0.0;
}

void purepursuit (void){
  float ganma = 0;

  float L = sqrt((xobj)*(xobj)+(yobj)*(yobj));

  if (L > 0.05){
    ganma = (2*yobj)/(L*L);
  }
  else{
    v = 0.0;
  }

  cout << "Haciendo purepursuit\n";
  cout << "pose = " << pose2d.x << ", " << pose2d.y << ", " << pose2d.theta << "\n";
  cout << "L = " << L << ", incx = " << xobj << "\n";
  cout << "xobj = " << xobj << ", yobj = " << yobj << "\n\n\n\n";

  msgconsigna.linear.x = v;
  msgconsigna.angular.z = ganma*v;
}

int main(int argc, char **argv)
{
  
  ros::init(argc, argv, "envpurepursuit");
  ros::NodeHandle n;
  
  ros::Subscriber lasertopic = n.subscribe<sensor_msgs::LaserScan>("/p3dx/laser/scan", 1, obtenerdatosscannerlaser);
  ros::Subscriber vtopic = n.subscribe<std_msgs::Float64>("/myv", 1, obtenerv);
  ros::Subscriber odomet = n.subscribe<nav_msgs::Odometry>("/p3dx/odom", 1, obtenerposicionactualodom);
  ros::Publisher consigna = n.advertise<geometry_msgs::Twist>("/p3dx/cmd_vel", 1);

  aplicavelocidad = false;
  xobj = 0.0;
  yobj = 0.0;
  pose2d.x = 0;
  pose2d.y = 0;
  pose2d.theta = 0;

  msgconsigna.linear.x = 0.0;
  msgconsigna.angular.z = 0.0;

  msgconsigna.linear.y = 0.0;
  msgconsigna.linear.z = 0.0;
  msgconsigna.angular.x = 0.0;
  msgconsigna.angular.y = 0.0;

  ros::Rate loop_rate(1);

  while (ros::ok())
  {
    purepursuit();
    consigna.publish(msgconsigna);
    ros::spinOnce();
    loop_rate.sleep();
  }


  return 0;
}
