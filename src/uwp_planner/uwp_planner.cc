// Copyright 2016 Massachusetts Intitute of Technology

// c system includes

// cpp system includes

// external includes

// project includes
#include "uwp_planner/uwp_planner.h"

namespace uwp_ros {
  UWPPlanner::UWPPlanner(const ros::NodeHandle& nh, UWPData* W, UWPApp* app)
    : nh_(nh) {
    ROS_INFO("UWPPlanner: Start Constructor\n");
    start_marker_pub_ = nh_.advertise<visualization_msgs::Marker>("start", 0, false);
    goal_marker_pub_ = nh_.advertise<visualization_msgs::Marker>("goal", 0, false);
    path_pub_ = nh_.advertise<nav_msgs::Path>("path", 0, false);

    if (!app->quiet && app->verbose) {
      fprintf(stderr, "Starting planner...\n");
    }

    initMap(W, app);

    if (!app->test_sg) {
      // min planner bounds
      app->pos_min = W->getXYZ(app->ixyz_min);
      app->state_min.segment(0, 3) = app->pos_min;
      app->state_min(3) = app->vel_g_min;

      // max planner bounds
      app->pos_max = W->getXYZ(app->ixyz_max);
      app->state_max.segment(0, 3) = app->pos_max;
      app->state_max(3) = app->vel_g_max;

      // initialize start states
      app->start_pos = app->start_state.segment(0, 3);
      app->start_ixyz = W->getInd(app->start_pos);

      // initialize goal states
      app->goal_pos = app->goal_state.segment(0, 3);
      app->goal_ixyz = W->getInd(app->goal_pos);

      // discretizations
      app->x_step = W->grid_res_;
      app->y_step = W->grid_res_;
      app->z_step = W->grid_res_;
      getSteps(app);
      getDState(app);

      if (app->verbose) {
        fprintf(stderr, "Start: x: %0.1f y: %0.1f z: %0.1f vel: %0.1f\n",
                app->start_state(0), app->start_state(1), app->start_state(2),
                app->start_state(3));
        fprintf(stderr, "Goal1: x: %0.1f y: %0.1f z: %0.1f vel: %0.1f\n",
                app->goal_state(0), app->goal_state(1), app->goal_state(2),
                app->goal_state(3));
      }

      // node storage array
      std::vector<std::vector<std::vector<Node*> > > N;

      // initialize nodes
      initNodes(&N, W, app);

      // get graph
      SearchAS G(&N);

      if (!G.getGraph(W, app)) {
        if (!app->quiet) {
          fprintf(stderr, "Success: Found goal\n");
        }

        // find optimal path in graph
        std::list<Node*> path;
        getPath(&path, &N, W, app);

        // find path given naive planner and dynamics constraints
        // if (app->vel_a_cap_flag && app->naive_flag) {
        //   checkPath(&path, &N, W, app);
        // }

        path_ = path;

        // plot initial path
        if (app->plot) {
          plotPathEdgeVel(&path, "path", app);
          // plotPathNodePos(&path, "path", app);
        }

        // dump path to file
        if (app->dump) {
          // printPath(&path, app);
          dumpPath(&path, "path", app);
        }
      } else {
        fprintf(stderr, "Error: Could not find goal\n");
      }

      freeMem(&N, W, app);
    }
  }

  UWPPlanner::~UWPPlanner() {
    // do nothing
  }

  void UWPPlanner::PlotStartGoal(UWPApp* app) {
    ROS_INFO("Starting PlotStartGoal");

    // start
    visualization_msgs::Marker start_marker;
    start_marker.header.frame_id = "local";
    start_marker.header.stamp = ros::Time();
    start_marker.ns = "uwp";
    start_marker.id = 0;
    start_marker.type = visualization_msgs::Marker::SPHERE;
    start_marker.action = visualization_msgs::Marker::ADD;

    start_marker.pose.position.x = app->start_pos(0);
    start_marker.pose.position.y = app->start_pos(1);
    start_marker.pose.position.z = app->start_pos(2);

    start_marker.pose.orientation.x = 0.0;
    start_marker.pose.orientation.y = 0.0;
    start_marker.pose.orientation.z = 0.0;
    start_marker.pose.orientation.w = 1.0;

    start_marker.scale.x = 2;
    start_marker.scale.y = 2;
    start_marker.scale.z = 2;

    start_marker.color.a = 1.0;
    start_marker.color.r = 0.0;
    start_marker.color.g = 1.0;
    start_marker.color.b = 0.0;

    start_marker.lifetime = ros::Duration();

    while (start_marker_pub_.getNumSubscribers() < 1) {
      if (!ros::ok()) {
        return;
      }
      ROS_WARN_ONCE("Please create a subscriber to the marker");
      sleep(1);
    }
    ROS_INFO("Publishing start marker.");
    start_marker_pub_.publish(start_marker);

    // goal
    visualization_msgs::Marker goal_marker;
    goal_marker.header.frame_id = "local";
    goal_marker.header.stamp = ros::Time();
    goal_marker.ns = "uwp";
    goal_marker.id = 0;
    goal_marker.type = visualization_msgs::Marker::SPHERE;
    goal_marker.action = visualization_msgs::Marker::ADD;

    goal_marker.pose.position.x = app->goal_pos(0);
    goal_marker.pose.position.y = app->goal_pos(1);
    goal_marker.pose.position.z = app->goal_pos(2);

    goal_marker.pose.orientation.x = 0.0;
    goal_marker.pose.orientation.y = 0.0;
    goal_marker.pose.orientation.z = 0.0;
    goal_marker.pose.orientation.w = 1.0;

    goal_marker.scale.x = 2;
    goal_marker.scale.y = 2;
    goal_marker.scale.z = 2;

    goal_marker.color.a = 1.0;
    goal_marker.color.r = 1.0;
    goal_marker.color.g = 0.0;
    goal_marker.color.b = 0.0;

    goal_marker.lifetime = ros::Duration();

    // publish the marker
    while (goal_marker_pub_.getNumSubscribers() < 1) {
      if (!ros::ok()) {
        return;
      }
      ROS_WARN_ONCE("Please create a subscriber to the marker");
      sleep(1);
    }
    ROS_INFO("Publishing goal marker.");
    goal_marker_pub_.publish(goal_marker);

    return;
  }

  int UWPPlanner::checkDynamics(Node* n, Node* parent, UWPData* W, UWPApp* app) {
    // check air velocity
    if (n->getVelAMagTrue(parent, W) > app->vel_a_max && app->vel_a_cap_flag
        && app->naive_flag) {
      return 0;
    }

    return 1;
  }

  void UWPPlanner::initMap(UWPData * W, UWPApp * app) {
    // get start pos and index
    app->start_pos = app->start_state.segment(0, 3);
    app->start_ixyz = W->getInd(app->start_pos);
    // fprintf(stderr, "start_ixyz: %i, %i, %i\n", app->start_ixyz(0), app->start_ixyz(1),
    //         app->start_ixyz(2));

    // check if start_pos is valid
    // TODO(jakeware): fix segfault that occurs after this is done
    Eigen::Vector3f start_pos_test = Eigen::Vector3f::Zero();
    // cppcheck-suppress redundantAssignment
    start_pos_test = W->getXYZ(app->start_ixyz);
    if (app->start_pos != start_pos_test) {
      fprintf(stderr, "Warning: Invalid start_pos not on grid.\n");

      app->start_pos = start_pos_test;
      fprintf(stderr, "Resetting to: %f, %f, %f\n", app->start_pos(0),
              app->start_pos(1), app->start_pos(2));
    }

    // get goal pos and index
    app->goal_pos = app->goal_state.segment(0, 3);
    app->goal_ixyz = W->getInd(app->goal_pos);

    // check if goal_pos is valid
    Eigen::Vector3f goal_pos_test = Eigen::Vector3f::Zero();
    // cppcheck-suppress redundantAssignment
    goal_pos_test = W->getXYZ(app->goal_ixyz);
    if (app->goal_pos != goal_pos_test) {
      fprintf(stderr, "Warning: Invalid goal_pos not on grid.\n");
      // fprintf(stderr, "goal_pos: %0.1f, %0.1f, %0.1f\n", goal_pos_test(0), goal_pos_test(1),
      //         goal_pos_test(2));
      app->goal_pos = goal_pos_test;
      fprintf(stderr, "Resetting to: %f, %f, %f\n", app->goal_pos(0),
              app->goal_pos(1), app->goal_pos(2));
    }

    // check if start and goal locations are in obstacle space
    if (W->getObs2D(app->start_ixyz)) {
      fprintf(stderr, "Start Location in Obstacle Space\n");
    }

    if (W->getObs2D(app->goal_ixyz)) {
      fprintf(stderr, "Goal Location in Obstacle Space\n");
    }

    // plotting
    if (app->plot) {
      PlotStartGoal(app);
      // plotBounds(W->getXYZ(app->ixyz_min), W->getXYZ(app->ixyz_max), app);
    }

    // check bounds
    if (W->checkMapBounds(app->ixyz_min)) {
      fprintf(stderr, "Error: Invalid min bounds.  Using map min bound.\n");
      app->ixyz_min = W->ixyz_min_;
    }
    if (W->checkMapBounds(app->ixyz_max)) {
      fprintf(stderr, "Error: Invalid max bounds.  Using map max bound.\n");
      app->ixyz_max = W->ixyz_max_;
    }

    return;
  }

void UWPPlanner::freeMem(std::vector<std::vector<std::vector<Node*> > > * N,
                      UWPData* W, UWPApp * app) {
  // nodes
  // x
  for (int i = 0; i < app->x_steps.rows(); i++) {
    // y
    for (int j = 0; j < app->y_steps.rows(); j++) {
      // vel
      for (int k = 0; k < app->vel_g_steps.rows(); k++) {
        Eigen::Vector3i ixyz = Eigen::Vector3i::Zero();
        ixyz(0) = app->x_steps(i);
        ixyz(1) = app->y_steps(j);
        ixyz(2) = app->start_ixyz(2);
        // don't create node if in obstacle space
        if (W->getObs2D(ixyz)) {
          continue;
        }

        delete (*N)[i][j][k];
      }
    }
  }

  return;
}

  int UWPPlanner::checkPlannerBounds(Eigen::Vector3i ixyz, UWPData * W, UWPApp * app) {
    int ret = 0;

    // loop over indicies
    for (int i = 0; i < 3; i++) {
      if (ixyz(i) < app->ixyz_min(i) || ixyz(i) > app->ixyz_max(i)) {
        ret = 1;
      }
    }

    if (W->checkMapBounds(ixyz)) {
      ret = 1;
    }

    return ret;
  }

  Node* UWPPlanner::createNode(Node* parent, const Eigen::Vector3i ixyz,
                            const double vel_g_mag, UWPData* W, UWPApp* app) {
    Node* n = new Node(parent, ixyz, vel_g_mag, W, app);

    return n;
  }

  Eigen::Vector3i UWPPlanner::getNodeInd(const Eigen::Vector4f state, UWPApp * app) {
    Eigen::Vector3i ind = Eigen::Vector3i::Zero();
    ind(0) = (state(0) - app->state_min(0)) / app->x_step;
    ind(1) = (state(1) - app->state_min(1)) / app->y_step;
    ind(2) = (state(3) - app->state_min(3)) / app->vel_g_step;

    return ind;
  }

  void UWPPlanner::getDState(UWPApp * app) {
    app->d_pos.setZero(3, 8);
    app->d_pos.col(0) << 1, 0, 0;  // forward
    app->d_pos.col(1) << -1, 0, 0;  // backward
    app->d_pos.col(2) << 0, 1, 0;  // right
    app->d_pos.col(3) << 0, -1, 0;  // left
    app->d_pos.col(4) << 1, 1, 0;  // forward-right
    app->d_pos.col(5) << 1, -1, 0;  // forward-left
    app->d_pos.col(6) << -1, 1, 0;  // backward-right
    app->d_pos.col(7) << -1, -1, 0;  // backward-left

    app->d_speed.setZero(3);
    app->d_speed << -0.5, 0, 0.5;  // possible speed deltas

    // x,y
    //  d_state.setZero(4, d_pos.cols());
    //  for (int i = 0; i < d_pos.cols(); i++) {
    //    d_state.col(i).segment(0, 3) = d_pos.col(i);
    //    d_state(3, i) = 0;
    //  }

    // x,y,vel
    app->d_state.setZero(4, app->d_pos.cols() * app->d_speed.rows());
    for (int i = 0; i < app->d_pos.cols(); i++) {
      for (int j = 0; j < app->d_speed.rows(); j++) {
        app->d_state.col(i * app->d_speed.rows() + j).segment(0, 3) = app->d_pos
          .col(i);
        app->d_state(3, i * app->d_speed.rows() + j) = app->d_speed(j);
      }
    }

    // eigen_dump(d_state);
    // fprintf(stderr, "d_state: %lu\n", d_state.cols());

    return;
  }

  void UWPPlanner::getSteps(UWPApp * app) {
    // x
    int x_size = (app->ixyz_max(0) - app->ixyz_min(0)) / app->x_step;
    app->x_steps.setZero(x_size + 1);
    for (int i = 0; i < app->x_steps.rows(); i++) {
      app->x_steps(i) = app->ixyz_min(0) + i * app->x_step;
    }

    // y
    int y_size = (app->ixyz_max(1) - app->ixyz_min(1)) / app->y_step;
    app->y_steps.setZero(y_size + 1);
    for (int i = 0; i < app->y_steps.rows(); i++) {
      app->y_steps(i) = app->ixyz_min(1) + i * app->y_step;
    }

    // z
    int z_size = (app->ixyz_max(2) - app->ixyz_min(2)) / app->z_step;
    app->z_steps.setZero(z_size + 1);
    for (int i = 0; i < app->z_steps.rows(); i++) {
      app->z_steps(i) = app->ixyz_min(2) + i * app->z_step;
    }

    // vel
    int vel_size = (app->vel_g_max - app->vel_g_min) / app->vel_g_step;
    app->vel_g_steps.setZero(vel_size + 1);
    for (int i = 0; i < app->vel_g_steps.rows(); i++) {
      app->vel_g_steps(i) = app->vel_g_min + i * app->vel_g_step;
    }

    return;
  }

  void UWPPlanner::initNodes(std::vector<std::vector<std::vector<Node*> > > * N,
                          UWPData* W, UWPApp* app) {
    if (!app->quiet && app->verbose) {
      fprintf(stderr, "initNodes... ");
    }

    // init node array
    (*N).resize(app->x_steps.rows());
    for (int i = 0; i < app->x_steps.rows(); ++i) {
      (*N)[i].resize(app->y_steps.rows());

      for (int j = 0; j < app->y_steps.rows(); ++j)
        (*N)[i][j].resize(app->vel_g_steps.rows());
    }

    // eigen_dump(z_steps);
    // fprintf(stderr, "z: %i\n", z_steps(start_ixyz(2)));

    Eigen::Vector3i ixyz = Eigen::Vector3i::Zero();
    double speed = 0;
    int node_count = 0;
    // x
    for (int i = 0; i < app->x_steps.rows(); i++) {
      // y
      for (int j = 0; j < app->y_steps.rows(); j++) {
        // vel
        for (int k = 0; k < app->vel_g_steps.rows(); k++) {
          ixyz(0) = app->x_steps(i);
          ixyz(1) = app->y_steps(j);
          ixyz(2) = app->start_ixyz(2);
          speed = app->vel_g_steps(k);

          // don't create node if in obstacle space
          if (W->getObs2D(ixyz)) {
            continue;
          }

          node_count++;

          Node* n = createNode(NULL, ixyz, speed, W, app);

          n->g = std::numeric_limits<double>::infinity();
          n->dist = std::numeric_limits<double>::infinity();
          n->energy = std::numeric_limits<double>::infinity();
          n->energy_sto = std::numeric_limits<double>::infinity();
          n->energy_pot = std::numeric_limits<double>::infinity();
          (*N)[i][j][k] = n;
          // Q.push(n);
        }
      }
    }

    // fprintf(stderr, "Total Nodes: %i\n", node_count);
    if (!app->quiet && app->verbose) {
      fprintf(stderr, "Done\n");
    }

    return;
  }

  void UWPPlanner::getPath(std::list<Node*> * path,
                        std::vector<std::vector<std::vector<Node*> > > * N,
                        UWPData* W, UWPApp* app) {
    if (!app->quiet && app->verbose) {
      fprintf(stderr, "Getting path... ");
    }

    // reset start node
    Eigen::Vector3i start_ind = getNodeInd(app->start_state, app);
    Node* n_start = (*N)[start_ind(0)][start_ind(1)][start_ind(2)];
    n_start->parent = NULL;
    n_start->g = 0;

    // get goal node
    Eigen::Vector3i goal_ind = getNodeInd(app->goal_state, app);
    Node* n = (*N)[goal_ind(0)][goal_ind(1)][goal_ind(2)];

    while (n != NULL) {
      // n->print();
      path->push_front(n);
      n = n->parent;

      if (n->state == app->start_state) {
        path->push_front(n);
        break;
      }
    }

    // fprintf(stderr, "path size: %lu\n", P.size());
    if (!app->quiet && app->verbose) {
      fprintf(stderr, "Done\n");
    }

    return;
  }

  void UWPPlanner::plotPathEdgeVel(std::list<Node*>* path, std::string path_name, UWPApp* app) {
    ROS_INFO("Starting plotPathEdgeVel");
    nav_msgs::Path path_msg;

    // header
    path_msg.header.stamp = ros::Time::now();
    path_msg.header.seq = 1;
    path_msg.header.frame_id = "/local";

    path_msg.poses.resize(path->size());
    for (std::list<Node*>::iterator it = path->begin(); it != path->end(); ++it) {
      geometry_msgs::PoseStamped pose_msg;
      // header
      pose_msg.header.seq = std::distance(path->begin(), it);
      pose_msg.header.stamp = ros::Time::now();
      pose_msg.header.frame_id = "/local";

      // position
      pose_msg.pose.position.x = (*it)->pos(0);
      pose_msg.pose.position.y = (*it)->pos(1);
      pose_msg.pose.position.z = (*it)->pos(2);

      // orientation
      pose_msg.pose.orientation.x = 0.0;
      pose_msg.pose.orientation.y = 0.0;
      pose_msg.pose.orientation.z = 0.0;
      pose_msg.pose.orientation.w = 1.0;

      path_msg.poses[std::distance(path->begin(), it)] = pose_msg;
    }

    path_pub_.publish(path_msg);

    return;
  }
}  // namespace uwp_ros
