# pragma once

// Copyright 2016 Massachusetts Intitute of Technology

/**
 * uwp_plan - Finds path from start to goal in a given wind field.
 */

// c system includes

// cpp system includes
#include <string>
#include <vector>
#include <list>
#include <limits>

// external library includes
#include "ros/ros.h"
#include "Eigen/Dense"
#include "visualization_msgs/Marker.h"
#include "nav_msgs/Path.h"

// project includes
#include "uwp_app/uwp_app.h"
#include "uwp_data/uwp_data.h"
#include "uwp_node/uwp_node.h"
#include "uwp_astar/uwp_astar.h"

namespace uwp_ros {
  /**
   * \brief UWPPlan class
   *
   * Finds path from start to goal in a given wind field.
  */
class UWPPlanner final {
 public:
  UWPPlanner(const ros::NodeHandle& nh, UWPData* uwp_data, UWPApp* app);
  ~UWPPlanner();
  UWPPlanner(const UWPPlanner& rhs) = delete;
  UWPPlanner& operator=(const UWPPlanner& rhs) = delete;

  void PlotStartGoal(UWPApp* app);

  // general utilities
  void freeMem(std::vector<std::vector<std::vector<Node*> > > * N, UWPData* W,
               UWPApp * app);
  void initMap(UWPData * W, UWPApp * app);
  int checkPlannerBounds(Eigen::Vector3i ixyz, UWPData * W, UWPApp* app);

  // node utilities
  void getDState(UWPApp * app);
  void getSteps(UWPApp * app);
  void initNodes(std::vector<std::vector<std::vector<Node*> > > * N,
                 UWPData* W, UWPApp * app);
  Eigen::Vector3i getNodeInd(const Eigen::Vector4f state, UWPApp * app);
  Node* createNode(Node * _parent, Eigen::Vector3i _ixyz, double _vel_g_mag,
                   UWPData * W, UWPApp * app);

  // naive planner utils
  void checkPath(std::list<Node*> * path,
                 std::vector<std::vector<std::vector<Node*> > > * N,
                 UWPData* W, UWPApp* app);
  int checkDynamics(Node * n, Node * parent, UWPData * W, UWPApp * app);

  // path utils
  void getPath(std::list<Node*> * path,
               std::vector<std::vector<std::vector<Node*> > > * N, UWPData * W,
               UWPApp * app);
  void printPath(std::list<Node*> * path, UWPApp * app);
  void sampPathSimple(std::list<Node*> * path, std::list<Node*> * samp_path,
                      UWPApp * app);
  void sampPathEnergy(std::list<Node*> * path, std::list<Node*> * samp_path,
                      UWPData* W, UWPApp * app);
  void collisionCheckPath(std::list<Node*> * path, std::list<Node*> * samp_path,
                          std::list<Node*> * samp_path_col, UWPData* W,
                          UWPApp * app);
  void dumpPath(std::list<Node*> * path, std::string path_name, UWPApp * app);
  double getEnergyDelta(Eigen::Vector4f state1, Eigen::Vector4f state2,
                        float dt, bool debug, UWPData * W, UWPApp * app);
  bool collisionCheck(Eigen::Vector3f pos1, Eigen::Vector3f pos2, bool debug,
                      UWPData * W, UWPApp * app);
  void plotPathEdgeVel(std::list<Node*>* path, std::string path_name, UWPApp* app);

  std::list<Node*> path_;

 private:
  ros::NodeHandle nh_;
  ros::Publisher start_marker_pub_;
  ros::Publisher goal_marker_pub_;
  ros::Publisher path_pub_;
};
}  // namespace uwp_ros
