#include <ros/ros.h>
#include <tf/transform_listener.h>
#include "geometry_msgs/PointStamped.h"
#include "sensor_msgs/LaserScan.h"
#include "visualization_msgs/Marker.h"

const double pi = 3.14159265;

ros::Publisher vis_pub_inlaserframe;
ros::Publisher vis_pub_inbaseframe;

std::vector<geometry_msgs::PointStamped> vp_laserframe;
std::vector<geometry_msgs::PointStamped> vp_baseframe;

tf::TransformListener *ptr_to_listener;



double angle_i(int i, double fov, int N){
  double res = fov/(N-1);
  double offset = (fov-180)/2.0;
  return( (i*res)-offset );
}

geometry_msgs::PointStamped get_point_in_laserframe(float d, float angle){
    double dist;
    if (std::isfinite(d)){
        dist = d;
    }
    else{
        dist = 5.6;
    }
    geometry_msgs::PointStamped p;
    p.header.frame_id = "lms100";
    p.header.stamp = ros::Time();
    p.point.x = dist*cos(angle);
    p.point.y = dist*sin(angle);
    p.point.z = 0.0;
    return(p);
}

geometry_msgs::PointStamped get_point_in_baseframe(float d, float angle){
    double dist;
    if (std::isfinite(d)){
        dist = d;
    }
    else{
        dist = 5.6;
    }
    geometry_msgs::PointStamped p_fromlaser;
    geometry_msgs::PointStamped p;
    p_fromlaser.header.frame_id = "lms100";
    p_fromlaser.header.stamp = ros::Time();
    p_fromlaser.point.x = dist*cos(angle);
    p_fromlaser.point.y = dist*sin(angle);
    p_fromlaser.point.z = 0.0;
    try{
        ptr_to_listener->transformPoint("base_link", p_fromlaser, p);
    }
    catch(tf::TransformException& ex){
        ROS_INFO("Excepción\n");
    }
    return(p);
}

void view_in_Rviz_pointsinlaserframe(std::vector<geometry_msgs::PointStamped> &vp, ros::Publisher vis_pub_inlaserframe, int N){
  visualization_msgs::Marker marker;
  marker.header.frame_id = "lms100";
  marker.header.stamp = ros::Time();
  marker.ns = "laser_data";
  marker.type = visualization_msgs::Marker::LINE_STRIP;
  marker.color.a = 1.0;
  marker.color.r = 1.0;
  marker.color.g = 1.0;
  marker.color.b = 1.0;
  marker.action = visualization_msgs::Marker::ADD;
  marker.pose.position.x = 0;
  marker.pose.position.y = 0;
  marker.pose.position.z = 0;
  marker.pose.orientation.x = 0;
  marker.pose.orientation.y = 0;
  marker.pose.orientation.z = 0;
  marker.pose.orientation.w = 1;
  marker.scale.x = 0.01;
  marker.scale.y = 0.01;
  marker.scale.z = 0.01;
  marker.points.clear();
  for (int i = 0; i < N; i++){
    geometry_msgs::Point a_point;
    a_point.x = vp[i].point.x;
    a_point.y = vp[i].point.y;
    a_point.z = 0;
    marker.points.push_back(a_point);
  }
  marker.lifetime=ros::Duration();
  vis_pub_inlaserframe.publish(marker);  
}

void view_in_Rviz_pointsinbaseframe(std::vector<geometry_msgs::PointStamped> &vp, ros::Publisher vis_pub_inbaseframe, int N){
  visualization_msgs::Marker marker;
  marker.header.frame_id = "base_link";
  marker.header.stamp = ros::Time();
  marker.ns = "laser_data";
  marker.type = visualization_msgs::Marker::LINE_STRIP;
  marker.color.a = 1.0;
  marker.color.r = 1.0;
  marker.color.g = 1.0;
  marker.color.b = 1.0;
  marker.action = visualization_msgs::Marker::ADD;
  marker.pose.position.x = 0;
  marker.pose.position.y = 0;
  marker.pose.position.z = 0;
  marker.pose.orientation.x = 0;
  marker.pose.orientation.y = 0;
  marker.pose.orientation.z = 0;
  marker.pose.orientation.w = 1;
  marker.scale.x = 0.01;
  marker.scale.y = 0.01;
  marker.scale.z = 0.01;
  marker.points.clear();
  for (int i = 0; i < N; i++){
    geometry_msgs::Point a_point;
    a_point.x = vp[i].point.x;
    a_point.y = vp[i].point.y;
    a_point.z = 0;
    marker.points.push_back(a_point);
  }
  marker.lifetime=ros::Duration();
  vis_pub_inbaseframe.publish(marker);  
}

void get_laser_data(const sensor_msgs::LaserScan::ConstPtr& msg){
    double max_range = msg->range_max;
    int N = (msg->angle_max - msg->angle_min)/msg->angle_increment;

    vp_laserframe.clear();
    vp_baseframe.clear();

    for (int i = 0; i < N; i++){
        ROS_INFO("-- Muestra i = %d", i);
        float angle = angle_i(i, (msg->angle_max - msg->angle_min)*180.0/pi, N);
        geometry_msgs::PointStamped p_laserframe = get_point_in_laserframe(msg->ranges[i], angle*pi/180.0);
        ROS_INFO("angle = %f, (%f, %f)\n", angle, p_laserframe.point.x, p_laserframe.point.y);
        vp_laserframe.push_back(p_laserframe);
        geometry_msgs::PointStamped p_baseframe = get_point_in_baseframe(msg->ranges[i], angle*pi/180.0);
        ROS_INFO("angle = %f, (%f, %f)\n", angle, p_baseframe.point.x, p_baseframe.point.y);
        vp_baseframe.push_back(p_baseframe);
    }

    view_in_Rviz_pointsinlaserframe(vp_laserframe, vis_pub_inlaserframe, N);
    view_in_Rviz_pointsinbaseframe(vp_baseframe, vis_pub_inbaseframe, N);
}

int main(int argc, char **argv){
    
    ros::init(argc, argv, "tf_listener_lms100_to_baselink_node");

    ros::NodeHandle n;

    tf::TransformListener listener(ros::Duration(10));
    ptr_to_listener = &listener;

    vis_pub_inbaseframe = n.advertise<visualization_msgs::Marker>("/markerbaseframe", 0);
    vis_pub_inlaserframe = n.advertise<visualization_msgs::Marker>("/markerlaserframe", 0);
    ros::Subscriber lasertopic = n.subscribe<sensor_msgs::LaserScan>("/p3dx/laser/scan", 1, get_laser_data);

    ros::spin();

    return 0;
}
