#include <ros/ros.h>
#include <tf/transform_broadcaster.h>

int main(int argc, char **argv){
    ros::init(argc, argv, "tf_transformacion_node");
    ros::NodeHandle n;

    ros::Rate r(10);
    tf::TransformBroadcaster b;

    while (ros::ok()){
        tf::Quaternion q;
        double pi = 3.14159265;
        double yaw = 0;
        double pitch = 0.0;
        double roll = -pi/2.0;
        q.setEuler(yaw, pitch, roll); // El láser está rotado 90 grados respecto del vehículo.
        b.sendTransform(
            tf::StampedTransform(
                tf::Transform(q, tf::Vector3(0.10, 0, 0.272)),
                ros::Time::now(),
                "base_link",
                "lms100"
            )
        );
    }
    return 0;
}