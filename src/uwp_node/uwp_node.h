#pragma once

// Copyright 2016 Jake Ware

// c system includes

// cpp system includes
#include <string>

// external includes
#include "Eigen/Dense"

// project includes
#include "uwp_data/uwp_data.h"
#include "uwp_app/uwp_app.h"

namespace uwp_ros {
class Node {
 public:
  Node(Node* _parent, const Eigen::Vector3i _ixyz, double _vel_g_mag,
       UWPData* W, UWPApp* app);
  Node(Node* _parent, const Eigen::Vector3i _ixyz, double _vel_g_mag,
       UWPData* W);
  ~Node();

  bool visited;
  Node* parent;  // pointer to parent node

  // state variables
  Eigen::Vector3i ixyz;  // grid index
  Eigen::Vector3f pos;  // position [m]
  double vel_g_mag;  // speed along edge [m/s]
  Eigen::Vector4f state;  // x,y,z,speed

  // cost variables
  Eigen::Vector3f vel_f;  // u,v,w wind velocities [m/s]
  Eigen::Vector3f vel_g;  // resulting ground speed [m/s]
  Eigen::Vector3f vel_a;  // x,y,z air speed
  double vel_a_mag;  // magnitude of air speed [m/s]
  double energy;  // cost to come [J]
  double energy_pot;  // potential energy [J]
  double energy_sto;  // stored energy [J]
  double dist;  // edge distance [m]
  double g;  // total cost to come
  double h;  // heuristic (euclidean distance to goal)
  double f;  // total cost (g + h)

  // book keeping variables
  Eigen::Vector3f vel_a_true;  // x,y,z air speed
  double vel_a_mag_true;
  double energy_true;  // cost to come [J]
  double energy_pot_true;  // potential energy [J]
  double energy_sto_true;  // stored energy [J]
  double g_true;  // total cost (g + h)

  // parameters
  double mass;
  double alpha;

  // actions
  Eigen::VectorXi valid;  // flags  // dx, dy, dz, dspeed

  Eigen::MatrixXf getVels(const Node * _parent, bool naive, UWPData * W);
  double getVelAMagTrue(Node* _parent, UWPData * W);
  Eigen::Vector3f getEnergy(const Node * _parent, bool naive, UWPData * W,
                            UWPApp* app);
  double getStored(const double _vel_a_mag, UWPApp * app);
  double getDist(const Node * _parent);
  double getCost(const Node * _parent, UWPData* W, UWPApp * app);
  void setNode(const Node * _parent, UWPData* W, UWPApp * app);
  void getActions(UWPData * W, const Eigen::Vector4f state_min,
                  const Eigen::Vector4f state_max,
                  const Eigen::MatrixXf d_state);
  int checkState(const Eigen::Vector4f _state, const Eigen::Vector4f state_min,
                 const Eigen::Vector4f state_max, UWPData * W);
  void print();
};
}  // namespace uwp_ros
