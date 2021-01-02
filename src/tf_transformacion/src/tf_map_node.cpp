#include <ros/ros.h>
#include <tf/transform_broadcaster.h>

int main(int argc, char **argv){
    ros::init(argc, argv, "tf_map_broadcaster");
    ros::NodeHandle n;

    ros::Rate r(10);
    tf::TransformBroadcaster b;

    while (ros::ok()){
        q.setEuler(yaw, pitch, roll); // El láser está rotado 90 grados respecto del vehículo.
        b.sendTransform(
            tf::StampedTransform(
                (0.0, 0.0, 0.0),
                (0.0, 0.0, 0.0, 1.0),
                ros::Time::now(),
                "odom",
                "map"
            )
        );
    }
    return 0;
}