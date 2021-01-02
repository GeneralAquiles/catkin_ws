cmake_minimum_required(VERSION 2.8.3)
project(envpurepursuit)

find_package(catkin REQUIRED COMPONENTS
  geometry_msgs
  nav_msgs
  sensor_msgs
  std_msgs
  roscpp
)

catkin_package(
)

include_directories(
  ${catkin_INCLUDE_DIRS}
)

add_executable(${PROJECT_NAME}_node src/envpurepursuit_node.cpp)


target_link_libraries(${PROJECT_NAME}_node
  ${catkin_LIBRARIES}
)

