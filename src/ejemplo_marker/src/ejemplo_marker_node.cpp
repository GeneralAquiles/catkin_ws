#include "ros/ros.h"
#include "visualization_msgs/Marker.h"


void dibujar_marca (ros::Publisher &marker_pub){
    visualization_msgs::Marker marker;

    marker.header.frame_id = "base_link";
    marker.header.stamp = ros::Time();
    marker.ns = "ejemplo_namespace";
    marker.id = 0;
    marker.type = visualization_msgs::Marker::SPHERE;
    marker.action = visualization_msgs::Marker::ADD;
    marker.pose.position.x = 1;
    marker.pose.position.y = 1;
    marker.pose.position.z = 1;
    marker.pose.orientation.x = 0.0;
    marker.pose.orientation.y = 0.0;
    marker.pose.orientation.z = 0.0;
    marker.pose.orientation.w = 1.0;
    marker.scale.x = 0.5;
    marker.scale.y = 0.5;
    marker.scale.z = 0.5;
    marker.color.a = 0.75;
    marker.color.r = 1.0;
    marker.color.g = 0.0;
    marker.color.b = 0.0;

    marker_pub.publish(marker);
}

int main(int argc, char **argv)
{
  ros::init(argc, argv, "ejemplo_marker_node");
  ros::NodeHandle n;

  ros::Publisher marker_pub = n.advertise<visualization_msgs::Marker>("/marca", 0);

  ros::Rate loop_rate(4);

  while (ros::ok()){
    dibujar_marca(marker_pub);
    ros::spinOnce();

    loop_rate.sleep();
  }


  return 0;
}
