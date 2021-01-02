cmake_minimum_required(VERSION 2.8.3)
project(tf_transformacion)

find_package(catkin REQUIRED COMPONENTS
  geometry_msgs
  sensor_msgs
  roscpp
  tf
  visualization_msgs
)

catkin_package(
)

include_directories(
  ${catkin_INCLUDE_DIRS}
)

add_executable(${PROJECT_NAME}_node src/tf_transformacion_node.cpp)
add_executable(tf_listener_lms100_to_baselink_node src/tf_listener_lms100_to_baselink_node.cpp)

target_link_libraries(${PROJECT_NAME}_node
  ${catkin_LIBRARIES}
)

target_link_libraries(tf_listener_lms100_to_baselink_node
  ${catkin_LIBRARIES}
)
