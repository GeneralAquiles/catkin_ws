#include "ros/ros.h"
#include "geometry_msgs/Point.h"
#include "sensor_msgs/LaserScan.h"
#include <math.h>

#include "sstream"

const double pi = 3.14159265;

double angle_i(int i, double fov, int N){
  double res = fov/(N-1);
  double offset = (fov-180)/2.0;
  return( (i*res)-offset );
}

bool point_laser(int i, double fov, int N,
                 geometry_msgs::Point &p,
                 std::vector<double> &v){
  double angle = angle_i(i, fov, N)*(pi/180.0);
  try{
    p.x = v[i]*cos(angle);
    p.y = v[i]*sin(angle);
    p.z = 0;
    return(true);
  }
  catch(std::out_of_range o){
    return(false);
  }
}

geometry_msgs::Point rotate_point(geometry_msgs::Point &p, double angle){
  geometry_msgs::Point rotated_p;
  rotated_p.x = p.x*cos(angle)+p.y*sin(angle);
  rotated_p.y = p.y*cos(angle)-p.x*sin(angle);
  return(rotated_p);
}

bool points_laser(double fov, int N,
                  std::vector<geometry_msgs::Point> &vp,
                  std::vector<double> &vd,
                  double Dx, double Dy){
  for (int i = 0; i < N; i++){
    double angle = angle_i(i, fov, N)*(pi/180.0);
    if (!point_laser(i, fov, N, vp[i], vd)){
      ROS_INFO("Error al calcular punto láser\n");
      return (false);
    }
    ROS_INFO("Angulo posicion %d, angulo %f, distancia %f --> (%f,%f)\t", i, angle, vd[i], vp[i].x, vp[i].y);
    geometry_msgs::Point rotated_p = rotate_point(vp[i], pi/2.0);
    vp[i].x = rotated_p.x + Dx;
    vp[i].y = rotated_p.y + Dy;
    ROS_INFO("Angulo posicion %d, angulo %f, distancia %f --> (%f,%f)\t", i, angle, vd[i], vp[i].x, vp[i].y);
  }
  return (true);
}

void get_laser_data(const sensor_msgs::LaserScan::ConstPtr& msg){
  int N = (msg->angle_max - msg->angle_min)/msg->angle_increment;
  std::vector<double> vd;
  vd.reserve(N);

  for (int i = 0; i < N; i++){
    vd[i] = msg->ranges[i];
  }
  std::vector<geometry_msgs::Point> vp;
  vp.reserve(N);
  points_laser(240, N, vp, vd, 0, 0);
}


int main (int argc, char **argv){
  
  ros::init(argc, argv, "ejemplolaser");
  ros::NodeHandle n;

  ros::Subscriber lasertopic = n.subscribe<sensor_msgs::LaserScan>("/scan", 1, get_laser_data);

  ros::Rate looprate(4);

  while (ros::ok()){
    ROS_INFO("En el bucle de ROS\n");
    ros::spinOnce();
    looprate.sleep();
  }

  return 0;
} 
