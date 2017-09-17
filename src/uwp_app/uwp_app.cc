// Copyright 2015 Jake Ware

// INCLUDES
#include "uwp_app/uwp_app.h"

namespace uwp_ros {

UWPApp::UWPApp(const ros::NodeHandle& nh) {
  ROS_INFO("Starting UWPApp Constructor");

  // setup ros
  nh_ = nh;

  // default settings
  verbose = false;
  quiet = false;
  debug = false;
  plot = true;
  publish = false;
  dump = false;
  rand = false;
  filename_flag = false;
  naive_flag = false;
  vel_a_cap_flag = false;
  test_sg = false;

  // visualization configuration
  flow_scale = 0.5;
  drag_scale = 2.0;
  flow_increment = 1;
  sg_scale = 1;

  // position constraints
  z_index = 0;

  // velocity constraints
  vel_g_step = 0.5;
  vel_a_max = 10;

  // state variables
  start_state.setZero();
  start_pos.setZero();
  start_ixyz.setZero();

  goal_state.setZero();
  goal_pos.setZero();
  goal_ixyz.setZero();

  // bounds
  ixyz_min.setZero();
  ixyz_max.setZero();
  pos_min.setZero();
  pos_max.setZero();
  state_min.setZero();
  state_max.setZero();
  vel_g_min = 0.5;
  vel_g_max = 8;

  // discretization
  x_step = 0;
  y_step = 0;
  z_step = 0;
  vel_g_step = 0;

  // number of random trials
  rand_count = 0;
  path_num = 0;
  min_dist = 10;

  // parameters
  g = 9.81;
  mass = 2;
  alpha = 1;

  // power profile
  pow_prof.setZero(5);

  // filename
  filename = "./";

  // rand_r seed
  srand(time(NULL));  // do we need to do this?
  seed = time(NULL);
}

UWPApp::~UWPApp() {
  // Nothing
}

void UWPApp::GetParams(const std::string &param_string) {
  ROS_INFO("Starting GetParams\n");

  ros::NodeHandle pnh("~");

  // create param string path
  std::string param_path = "/" + param_string + "/";

  // start state
  std::vector<float> start_state_temp(4);
  pnh.getParam(param_path + "start_state", start_state_temp);
  start_state = Eigen::VectorXf::Map(start_state_temp.data(), start_state_temp.size());
  ROS_INFO("start_state: [%0.1f,%0.1f,%0.1f,%0.1f]", start_state(0), start_state(1),
           start_state(2), start_state(3));

  // goal_state
  std::vector<float> goal_state_temp(4);
  pnh.getParam(param_path + "goal_state", goal_state_temp);
  goal_state = Eigen::VectorXf::Map(goal_state_temp.data(), goal_state_temp.size());
  ROS_INFO("goal_state: [%0.1f,%0.1f,%0.1f,%0.1f]", goal_state(0), goal_state(1),
           goal_state(2), goal_state(3));

  // ixyz min
  std::vector<int> ixyz_min_temp(3);
  pnh.getParam(param_path + "ixyz_min", ixyz_min_temp);
  ixyz_min = Eigen::VectorXi::Map(ixyz_min_temp.data(), ixyz_min_temp.size());
  ROS_INFO("ixyz_min: [%i,%i,%i]", ixyz_min(0), ixyz_min(1),
           ixyz_min(2));

  // ixyz max
  std::vector<int> ixyz_max_temp(3);
  pnh.getParam(param_path + "ixyz_max", ixyz_max_temp);
  ixyz_max = Eigen::VectorXi::Map(ixyz_max_temp.data(), ixyz_max_temp.size());
  ROS_INFO("ixyz_max: [%i,%i,%i]", ixyz_max(0), ixyz_max(1),
           ixyz_max(2));

  // // // z_index
  // // pnh.getParam(param_path + "z_index", z_index);
  // // ROS_INFO("z_index: %i", z_index);

  // // // flow_scale
  // // pnh.getParam(param_path + "flow_scale", flow_scale);
  // // ROS_INFO("flow_scale: %0.2f", flow_scale);

  // vel_g_min
  pnh.getParam(param_path + "vel_g_min", vel_g_min);
  ROS_INFO("vel_g_min: %0.1f", vel_g_min);

  // vel_g_max
  pnh.getParam(param_path + "vel_g_max", vel_g_max);
  ROS_INFO("vel_g_max: %0.1f", vel_g_max);

  // vel_g_step
  pnh.getParam(param_path + "vel_g_step", vel_g_step);
  ROS_INFO("vel_g_step: %0.1f", vel_g_step);

  // vel_a_max
  pnh.getParam(param_path + "vel_a_max", vel_a_max);
  ROS_INFO("vel_a_max: %0.1f", vel_a_max);

  // min_dist
  pnh.getParam(param_path + "min_dist", min_dist);
  ROS_INFO("min_dist: %0.1f", min_dist);

  // power profile
  std::vector<double> pow_prof_temp(5);
  pnh.getParam(param_path + "pow_prof", pow_prof_temp);
  pow_prof = Eigen::VectorXd::Map(pow_prof_temp.data(), pow_prof.size());
  ROS_INFO("pow_prof: [%0.2f,%0.2f,%0.2f,%0.2f,%0.2f]", pow_prof(0), pow_prof(1),
           pow_prof(2), pow_prof(3), pow_prof(4));

  return;
}
} // namespace uwp_ros
