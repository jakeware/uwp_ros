// Copyright 2016 Massachusetts Intitute of Technology

/**
 * uwp_planner - Executes the planning task for a given map and wind field.
 */

// c system includes
#include <csignal>

// cpp system includes
#include <string>
#include <vector>

// external includes
#include "ros/ros.h"
#include "nodelet/nodelet.h"

// project includes
#include "./uwp_data/uwp_data.h"
#include "./uwp_planner/uwp_planner.h"
#include "./uwp_app/uwp_app.h"

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
   * \brief UWPMain class
   *
   * A nodelet for planning over wind fields.
  */
class UWPMain final : public nodelet::Nodelet {
 public:
  UWPMain() = default;
  virtual ~UWPMain() = default;
  UWPMain(const UWPMain& rhs) = delete;
  UWPMain& operator=(const UWPMain& rhs) = delete;

  /**
   * \brief Nodelet initialization function.
   */
  virtual void onInit() {
    NODELET_DEBUG("onInit");
    // get handle to the parent node
    ros::NodeHandle nh = getNodeHandle();

    // load settings
    UWPApp uwp_app(nh);
    uwp_app.GetParams("uwp_main");

    // load and visualize wind data
    UWPData uwp_data(nh);
    uwp_data.GetParams("uwp_main");  // get params
    uwp_data.LoadUnsteadyData();  // load wind data

    // get minimums and maximums
    uwp_data.GetXYZBounds();
    uwp_data.GetVarBounds();

    // create occupancy grid from raw data
    uwp_data.InitOccGrid();

    // occ and wind plotting
    // uwp_data.PlotOccGrid();
    uwp_data.PlotXYZ(1.0, 2);
    // uwp_data.PlotUVW(1.0, 2);
    // uwp_data.PlotS2("uu");

    // actions
    // UWPActions uwp_actions;
    // uwp_actions.LoadActions();
    // uwp_actions.PlotActions();

    // planner
    UWPPlanner uwp_planner(nh, &uwp_data, &uwp_app);

    return;
  }
};

}  // namespace uwp_ros

// Export as a plugin.
#include <pluginlib/class_list_macros.h>
PLUGINLIB_EXPORT_CLASS(uwp_ros::UWPMain, nodelet::Nodelet)
