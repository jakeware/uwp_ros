#pragma once

// Copyright 2015 Jake Ware

// c system includes

// cpp system includes
#include <queue>
#include <list>
#include <vector>
#include <algorithm>
#include <iostream>
#include <string>
#include <limits>

// external includes
#include "eigen3/Eigen/Dense"

// project includes
#include "uwp_node/uwp_node.h"
#include "uwp_data/uwp_data.h"
#include "uwp_app/uwp_app.h"

namespace uwp_ros {

class SearchAS {
 public:
  explicit SearchAS(std::vector<std::vector<std::vector<Node*> > > * _N);
  ~SearchAS();

  // storage
  struct nodeCompare {
    bool operator()(const Node* n1, const Node* n2) const {
      return (n1->f > n2->f);
    }
  };

  // node queue
  std::priority_queue<Node*, std::vector<Node*>, nodeCompare> Q;

  // node storage array
  std::vector<std::vector<std::vector<Node*> > > * N;

  // utilities
  void initStart(UWPData* W, UWPApp * app);
  int checkPlannerBounds(Eigen::Vector3i ixyz, UWPData * W, UWPApp * app);
  Eigen::Vector3i getNodeInd(const Eigen::Vector4f state, UWPApp * app);
  std::vector<Node*> getNeighbors(Node * u, UWPData * W, UWPApp * app);

  // search
  int getGraph(UWPData * W, UWPApp * app);
};

}  // namespace uwp_ros
