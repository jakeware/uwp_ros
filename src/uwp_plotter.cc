// Copyright 2016 Massachusetts Intitute of Technology

/**
 * uwp_plotter - plots wind data
 */

// c system includes
#include <csignal>

// cpp system includes
#include <string>
#include <vector>

// external includes
#include "Eigen/Dense"
#include "Eigen/Geometry"
#include "ros/ros.h"
#include "nodelet/nodelet.h"

// project includes
#include "./uwp_data/uwp_data.h"

/**
 * We override the default ROS SIGINT handler to set a global variable which
 * tells the other threads to stop.
 */
void signal_handler(int signal) {
  printf("SIGINT Received!\n");

  // Tell other threads to stop.
  // uwp_ros::STOP_SIGNAL = 1;

  // Tell ROS to shutdown nodes.
  ros::shutdown();

  return;
}

namespace uwp_ros {
  /**
   * \brief UWPPlotter class
   *
   * An nodelet for visualizing wind fields and trajectories.
  */
class UWPPlotter final : public nodelet::Nodelet {
 public:
  UWPPlotter() = default;
  virtual ~UWPPlotter() = default;
  UWPPlotter(const UWPPlotter& rhs) = delete;
  UWPPlotter& operator=(const UWPPlotter& rhs) = delete;

  /**
   * \brief Nodelet initialization function.
   */
  virtual void onInit() {
    NODELET_DEBUG("onInit");
    // get handle to the parent node
    ros::NodeHandle nh = getNodeHandle();

    // load and visualize wind data
    UWPData wind_data(nh);
    wind_data.GetParams("uwp_plotter");  // get params
    wind_data.LoadUnsteadyData();  // load wind data

    // get minimums and maximums
    wind_data.GetXYZBounds();
    wind_data.GetVarBounds();

    // create occupancy grid from raw data
    wind_data.InitOccGrid();

    // plotting
    wind_data.PlotOccGrid();
    wind_data.PlotXYZ(1.0, 2);
    wind_data.PlotUVW(1.0, 2);
    wind_data.PlotS2("uu");

    return;
  }
};

}  // namespace uwp_ros

// Export as a plugin.
#include <pluginlib/class_list_macros.h>
PLUGINLIB_EXPORT_CLASS(uwp_ros::UWPPlotter, nodelet::Nodelet)
