#include "ros/ros.h"
#include "geometry_msgs/Point.h"
#include "sensor_msgs/LaserScan.h"
#include "visualization_msgs/Marker.h"
#include <math.h>

#include "sstream"

const double pi = 3.14159265;

ros::Publisher vis_pub;
ros::Publisher vis_pub_map;

enum TCell{
    OCCUPIED = 1,
    FREE = 0,
    UNKNOWN = -1
};

class TGridMap{
    private:
        TCell **occupancy_grid;
        int r, c; // Número de filas y de columnas
        double rescell; // Resolución de la celda en metros
        double max_range; // Rango máximo de distancia del láser
    public:
        TGridMap(){
            occupancy_grid = NULL;
        }
        TGridMap(double rescell, double max_range){
            occupancy_grid = NULL;
            this->rescell = rescell;
            this->max_range = max_range;
        }
        void set_rescell(double rescell){
            this->rescell = rescell;
        }
        void set_max_range(double max_range){
            this->max_range = max_range;
        }
        void alloc_map();
        void init_empty_map();
        void reset_map();
        void update_cell(geometry_msgs::Point p);
        void update_map(std::vector<geometry_msgs::Point> &vp, int N);
        void visualize_map(ros::Publisher vis_pub);
        float calculate_dist_to_robot(geometry_msgs::Point p){
            return(sqrt(p.x*p.x+p.y*p.y));            
        }
        ~TGridMap(){
            reset_map();
        }
};

void TGridMap::alloc_map(){
  r = ceil(max_range/rescell);
  c = r*2;
  ROS_INFO("Numero de filas: %d, numero de columnas: %d\n", r, c);
  occupancy_grid = (TCell **)malloc(sizeof(TCell*)*r);
  for (int i = 0; i < r; i++){
    occupancy_grid[i] = (TCell *)malloc(sizeof(TCell)*c);
  }
}

void TGridMap::init_empty_map(){
  for (int i = 0; i < r; i++){
    for (int j = 0; j < c; j++){
      occupancy_grid[i][j] = FREE; // Celda libre
    }
  }
} 

void TGridMap::reset_map(){
  if (occupancy_grid != NULL){
    for (int i = 0; i < r; i++){
      if (occupancy_grid[i]!=NULL){
        free(occupancy_grid[i]);
        occupancy_grid[i] = NULL;
      }
    }
    free(occupancy_grid);
  }
}

void TGridMap::update_cell(geometry_msgs::Point p){
  int irow = r - p.x/rescell;
  int icol = c/2 - p.y/rescell;
  ROS_INFO("row = %d, col = %d --- (x,y) = (%f, %f), rescell = %f\n", irow, icol, p.x, p.y, rescell);
  occupancy_grid[irow][icol] = OCCUPIED;
}

void TGridMap::update_map(std::vector<geometry_msgs::Point> &vp, int N){
    for (int i = 0; i < N; i++){
        if (vp[i].x > 0){
            if (calculate_dist_to_robot(vp[i]) < 5){
                update_cell(vp[i]);
            }
        }
    }
}

void TGridMap::visualize_map(ros::Publisher vis_pub){
  visualization_msgs::Marker marker;
  marker.header.frame_id = "base_link";
  marker.header.stamp = ros::Time();
  marker.ns = "laser_data";
  marker.type = visualization_msgs::Marker::CUBE_LIST;
  marker.color.a = 0.5;
  marker.color.r = 0.0;
  marker.color.g = 0.0;
  marker.color.b = 1.0;
  marker.action = visualization_msgs::Marker::ADD;
  marker.pose.position.x = 0;
  marker.pose.position.y = 0;
  marker.pose.position.z = 0;
  marker.pose.orientation.x = 0;
  marker.pose.orientation.y = 0;
  marker.pose.orientation.z = 0;
  marker.pose.orientation.w = 1;
  marker.scale.x = rescell;
  marker.scale.y = rescell;
  marker.scale.z = 0.0001;
  for (int i = 0; i < r; i++){
    for (int j = 0; j < c; j++){
        if (occupancy_grid[i][j] == OCCUPIED){
          geometry_msgs::Point p;      
          p.y = ((((c-1)/2)-j)*rescell)+(rescell/2.0); 
          p.x = (((r-1)-i)*rescell)+(rescell/2.0);
          marker.points.push_back(p);
        }
    }
  }
  marker.lifetime=ros::Duration();
  vis_pub.publish(marker);  
  
}

TGridMap gridmap(0.25, 5.6);

double angle_i(int i, double fov, int N){
  double res = fov/(N-1);
  double offset = (fov-180)/2.0;
  return( (i*res)-offset );
}

bool point_laser(int i, double fov, int N,
                 geometry_msgs::Point &p,
                 std::vector<double> &v, double max_range){
  double angle = angle_i(i, fov, N)*(pi/180.0);
  try{
    double dist;
    if (std::isfinite(v[i])){
        dist = v[i];
    }
    else{
        dist = 5.6;
    }
    p.x = dist*cos(angle);
    p.y = dist*sin(angle);
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
                  std::vector<double> &vd, double max_range,
                  double Dx, double Dy){
  for (int i = 0; i < N; i++){
    double angle = angle_i(i, fov, N)*(pi/180.0);
    if (!point_laser(i, fov, N, vp[i], vd, max_range)){
      return (false);
    }
    geometry_msgs::Point rotated_p = rotate_point(vp[i], pi/2.0);
    vp[i].x = rotated_p.x + Dx;
    vp[i].y = rotated_p.y + Dy;
  }
  return (true);
}

void view_in_Rviz(std::vector<geometry_msgs::Point> &vp, ros::Publisher vis_pub, int N){
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
  for (int i = 0; i < N; i++){
    marker.points.push_back(vp[i]);
  }
  marker.lifetime=ros::Duration();
  vis_pub.publish(marker);  
}

void get_laser_data(const sensor_msgs::LaserScan::ConstPtr& msg){
  double max_range = msg->range_max;
  int N = (msg->angle_max - msg->angle_min)/msg->angle_increment;
  std::vector<double> vd;
  vd.reserve(N);    

  for (int i = 0; i < N; i++){
    vd[i] = msg->ranges[i];
  }
  std::vector<geometry_msgs::Point> vp;
  vp.reserve(N);
  points_laser((msg->angle_max - msg->angle_min)*180.0/pi, N, vp, vd, max_range, 0, 0);
  ROS_INFO("Actualizando mapa\n");
  gridmap.init_empty_map();
  gridmap.update_map(vp, N);
  ROS_INFO("Visualizando mapa\n");
  view_in_Rviz(vp, vis_pub, N);
  gridmap.visualize_map(vis_pub_map);
}



int main (int argc, char **argv){
  
  ros::init(argc, argv, "ejemplolaser");
  ros::NodeHandle n;

  ros::Subscriber lasertopic = n.subscribe<sensor_msgs::LaserScan>("/p3dx/laser/scan", 1, get_laser_data);
  vis_pub = n.advertise<visualization_msgs::Marker>("/visualization_marker", 0);
  vis_pub_map = n.advertise<visualization_msgs::Marker>("/visualization_marker_map", 0);
  gridmap.alloc_map();
  gridmap.init_empty_map();

  ros::Rate looprate(4);

  while (ros::ok()){
    ros::spinOnce();
    looprate.sleep();
  }

  return 0;
} 
