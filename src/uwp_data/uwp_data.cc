// Copyright 2016 Massachusetts Intitute of Technology

/**
 * uwp_data - load, store, parse, and visualize wind data
 */

// c system includes

// cpp system includes

// external library includes

// project includes
#include "./uwp_data/uwp_data.h" // NOLINT(build/include)

namespace uwp_ros {

  UWPData::UWPData(const ros::NodeHandle &nh)
    : nh_(nh),
      xyz_min_(3),
      xyz_max_(3),
      grid_size_(3),
      grid_res_(0),
      grid_height_(1),
      obs_mask_(1),
      occ_grid_(),
      x_(1),
      y_(1),
      z_(1),
      u_(1),
      v_(1),
      w_(1),
      s2uu_(1),
      s2vv_(1),
      s2ww_(1),
      s2uv_(1),
      s2vw_(1),
      s2uw_(1),
      s2uu_min_(std::numeric_limits<double>::infinity()),
      s2uu_max_(0),
      s2vv_min_(std::numeric_limits<double>::infinity()),
      s2vv_max_(0),
      s2ww_min_(std::numeric_limits<double>::infinity()),
      s2ww_max_(0),
      s2uv_min_(std::numeric_limits<double>::infinity()),
      s2uv_max_(0),
      s2vw_min_(std::numeric_limits<double>::infinity()),
      s2vw_max_(0),
      s2uw_min_(std::numeric_limits<double>::infinity()),
      s2uw_max_(0),
      wind_path_(""),
      x_fname_(""),
      y_fname_(""),
      z_fname_(""),
      u_fname_(""),
      v_fname_(""),
      w_fname_(""),
      s2uu_fname_(""),
      s2vv_fname_(""),
      s2ww_fname_(""),
      s2uv_fname_(""),
      s2vw_fname_(""),
      s2uw_fname_(""),
      obs_mask_fname_(""),
      grid_size_fname_(""),
      grid_res_fname_(""),
      grid_height_fname_("") {
    ROS_INFO("UWPData Contructor\n");
  }

  UWPData::~UWPData() {
    // nothing
  }

  void UWPData::GetParams(const std::string &param_string) {
    ROS_INFO("Starting GetParams\n");

    ros::NodeHandle pnh("~");

    // create param string path
    std::string param_path = "/" + param_string + "/";

    pnh.getParam(param_path + "wind_path", wind_path_);
    ROS_DEBUG("wind_path: %s\n", wind_path_.c_str());

    pnh.getParam(param_path + "x_fname", x_fname_);
    ROS_DEBUG("x_fname: %s\n", x_fname_.c_str());

    pnh.getParam(param_path + "y_fname", y_fname_);
    ROS_DEBUG("y_fname: %s\n", y_fname_.c_str());

    pnh.getParam(param_path + "z_fname", z_fname_);
    ROS_DEBUG("z_fname: %s\n", z_fname_.c_str());

    pnh.getParam(param_path + "u_fname", u_fname_);
    ROS_DEBUG("u_fname: %s\n", u_fname_.c_str());

    pnh.getParam(param_path + "v_fname", v_fname_);
    ROS_DEBUG("v_fname: %s\n", v_fname_.c_str());

    pnh.getParam(param_path + "w_fname", w_fname_);
    ROS_DEBUG("w_fname: %s\n", w_fname_.c_str());

    pnh.getParam(param_path + "s2uu_fname", s2uu_fname_);
    ROS_DEBUG("s2uu_fname: %s\n", s2uu_fname_.c_str());

    pnh.getParam(param_path + "s2vv_fname", s2vv_fname_);
    ROS_DEBUG("s2vv_fname: %s\n", s2vv_fname_.c_str());

    pnh.getParam(param_path + "s2ww_fname", s2ww_fname_);
    ROS_DEBUG("s2ww_fname: %s\n", s2ww_fname_.c_str());

    pnh.getParam(param_path + "s2uv_fname", s2uv_fname_);
    ROS_DEBUG("s2uv_fname: %s\n", s2uv_fname_.c_str());

    pnh.getParam(param_path + "s2vw_fname", s2vw_fname_);
    ROS_DEBUG("s2vw_fname: %s\n", s2vw_fname_.c_str());

    pnh.getParam(param_path + "s2uw_fname", s2uw_fname_);
    ROS_DEBUG("s2uw_fname: %s\n", s2uw_fname_.c_str());

    pnh.getParam(param_path + "obs_mask_fname", obs_mask_fname_);
    ROS_DEBUG("obs_mask_fname: %s\n", obs_mask_fname_.c_str());

    pnh.getParam(param_path + "grid_size_fname", grid_size_fname_);
    ROS_DEBUG("grid_size_fname: %s\n", grid_size_fname_.c_str());

    pnh.getParam(param_path + "grid_res_fname", grid_res_fname_);
    ROS_DEBUG("grid_res_fname: %s\n", grid_res_fname_.c_str());

    pnh.getParam(param_path + "grid_height_fname", grid_height_fname_);
    ROS_DEBUG("grid_height_fname: %s\n", grid_height_fname_.c_str());

    return;
  }

  void UWPData::LoadUnsteadyData() {
    ROS_INFO("Starting LoadUnsteadyData\n");

    // read and set veriables
    x_ = ReadVectorDouble(wind_path_ + x_fname_);
    // x_ = Eigen::VectorXd::Map(x.data(), x.size());
    y_ = ReadVectorDouble(wind_path_ + y_fname_);
    z_ = ReadVectorDouble(wind_path_ + z_fname_);
    u_ = ReadVectorDouble(wind_path_ + u_fname_);
    v_ = ReadVectorDouble(wind_path_ + v_fname_);
    w_ = ReadVectorDouble(wind_path_ + w_fname_);
    s2uu_ = ReadVectorDouble(wind_path_ + s2uu_fname_);
    s2vv_ = ReadVectorDouble(wind_path_ + s2vv_fname_);
    s2ww_ = ReadVectorDouble(wind_path_ + s2ww_fname_);
    s2uv_ = ReadVectorDouble(wind_path_ + s2uv_fname_);
    s2vw_ = ReadVectorDouble(wind_path_ + s2vw_fname_);
    s2uw_ = ReadVectorDouble(wind_path_ + s2uw_fname_);
    obs_mask_ = ReadVectorInt(wind_path_ + obs_mask_fname_);
    grid_size_ = ReadVectorInt(wind_path_ + grid_size_fname_);
    grid_res_ = ReadDouble(wind_path_ + grid_res_fname_);
    ROS_INFO("grid_res: %0.1f", grid_res_);
    grid_height_ = ReadDouble(wind_path_ + grid_height_fname_);

    // store max and min indicies
    ixyz_min_ << 0, 0, 0;
    ixyz_max_ << grid_size_[0] - 1, grid_size_[1] - 1, grid_size_[2] - 1;

    return;
  }

  std::vector<double> UWPData::ReadVectorDouble(const std::string& path) {
    ROS_DEBUG("Starting ReadVectorDouble\n");
    ROS_DEBUG("Reading: %s\n", path.c_str());

    // create temp variable
    std::vector<double> temp_data;

    // open file stream
    std::ifstream ifile(path, std::ios::in);

    // check to see that the file was opened correctly:
    if (!ifile.is_open()) {
        std::cerr << "Error: There was a problem opening the input file!\n";
        exit(1);  // exit or do additional error checking
    }

    double num = 0.0;
    temp_data.clear();
    while (ifile >> num) {
      temp_data.push_back(num);
    }

    // print data
    // for (int i = 0; i < temp_data.size(); ++i) {
    //   std::cout << temp_data[i] << std::endl;
    // }

    ROS_DEBUG("Size: %lu\n", temp_data.size());

    return temp_data;
  }

  std::vector<int> UWPData::ReadVectorInt(const std::string& path) {
    ROS_DEBUG("Starting ReadVectorInt\n");
    ROS_DEBUG("Reading: %s\n", path.c_str());

    // create temp variable
    std::vector<int> temp_data;

    // open file stream
    std::ifstream ifile(path, std::ios::in);

    // check to see that the file was opened correctly:
    if (!ifile.is_open()) {
        std::cerr << "Error: There was a problem opening the input file!\n";
        exit(1);  // exit or do additional error checking
    }

    int num = 0;
    temp_data.clear();
    while (ifile >> num) {
      temp_data.push_back(num);
    }

    // print data
    // for (int i = 0; i < temp_data.size(); ++i) {
    //   std::cout << temp_data[i] << std::endl;
    // }

    ROS_DEBUG("Size: %lu\n", temp_data.size());

    return temp_data;
  }

  int UWPData::ReadInt(const std::string& path) {
    ROS_DEBUG("Starting ReadInt\n");
    ROS_DEBUG("Reading: %s\n", path.c_str());

    // create temp variable
    int temp_data;

    // open file stream
    std::ifstream ifile(path, std::ios::in);

    // check to see that the file was opened correctly:
    if (!ifile.is_open()) {
        std::cerr << "Error: There was a problem opening the input file!\n";
        exit(1);  // exit or do additional error checking
    }

    int num = 0;
    ifile >> num;
    temp_data = num;

    return temp_data;
  }

  double UWPData::ReadDouble(const std::string& path) {
    ROS_DEBUG("Starting ReadDouble\n");
    ROS_DEBUG("Reading: %s\n", path.c_str());

    // create temp variable
    double temp_data;

    // open file stream
    std::ifstream ifile(path, std::ios::in);

    // check to see that the file was opened correctly:
    if (!ifile.is_open()) {
        std::cerr << "Error: There was a problem opening the input file!\n";
        exit(1);  // exit or do additional error checking
    }

    int num = 0;
    ifile >> num;
    temp_data = num;

    return temp_data;
  }

  void UWPData::GetXYZBounds() {
    // compute xyz min and max
    xyz_min_[0] = *std::min_element(x_.begin(), x_.end());
    xyz_max_[0] = *std::max_element(x_.begin(), x_.end());
    xyz_min_[1] = *std::min_element(y_.begin(), y_.end());
    xyz_max_[1] = *std::max_element(y_.begin(), y_.end());
    xyz_min_[2] = *std::min_element(z_.begin(), z_.end());
    xyz_max_[2] = *std::max_element(z_.begin(), z_.end());

    return;
  }

  void UWPData::InitOccGrid() {
    ROS_INFO("Starting InitOccGrid\n");

    // check for proper vector sizes
    if (grid_size_[0]*grid_size_[1] != obs_mask_.size()) {
      ROS_ERROR("InitOccGrid: Vector sizes do not match.\n");
      exit(EXIT_FAILURE);
      return;
    }

    occ_grid_.data = std::vector<signed char>(obs_mask_.size());
    int count = 0;
    for (int i = 0; i < grid_size_[0]; i++) {
      for (int j = 0; j < grid_size_[1]; j++) {
        occ_grid_.data[i + j*grid_size_[0]] = 100*obs_mask_[count++];
      }
    }

    return;
  }

  void UWPData::PlotOccGrid() {
    ROS_INFO("Starting PlotOccGrid\n");

    ros::Publisher occ_grid_pub = nh_.advertise<nav_msgs::OccupancyGrid>("occ_grid", 0, 0);
    ros::Rate r(1);

    // header.
    occ_grid_.header.stamp = ros::Time::now();
    occ_grid_.header.seq = 1;
    occ_grid_.header.frame_id = "/local";

    // metadata
    occ_grid_.info.map_load_time = ros::Time::now();
    occ_grid_.info.resolution = grid_res_;
    occ_grid_.info.width = grid_size_[0];
    occ_grid_.info.height = grid_size_[1];

    geometry_msgs::Pose orig;
    orig.position.x = xyz_min_[0];
    orig.position.y = xyz_min_[1];
    orig.position.z = xyz_min_[2];
    orig.orientation.x = 0.0;
    orig.orientation.y = 0.0;
    orig.orientation.z = 0.0;
    orig.orientation.w = 1.0;
    occ_grid_.info.origin = orig;

    // wait for subscribers and publish
    while (occ_grid_pub.getNumSubscribers() == 0) {
      ROS_DEBUG("PlotOccGrid waiting for subscibers...\n");
      sleep(1);
    }
    ROS_DEBUG("Got subscriber\n");
    occ_grid_pub.publish(occ_grid_);
    ros::spinOnce();

    return;
  }

  void UWPData::PlotXYZ(const double scale, const int increment) {
    ROS_INFO("Starting PlotXYZ\n");

    ros::Publisher points_pub = nh_.advertise<visualization_msgs::Marker>("xyz_points", 0, 0);
    ros::Rate r(1);

    visualization_msgs::Marker points;

    // Set the frame ID and timestamp.  See the TF tutorials for information on these.
    points.header.frame_id = "/local";
    points.header.stamp = ros::Time::now();

    // Set the namespace and id for this marker.  This serves to create a unique ID
    // Any marker sent with the same namespace and id will overwrite the old one
    points.ns = "uwp_plotter";
    points.id = 0;

    // Set the marker type
    points.type = visualization_msgs::Marker::POINTS;

    // Set the marker action (ADD, DELETE, DELETEALL)
    points.action = visualization_msgs::Marker::ADD;

    // Set the scale of the marker
    points.scale.x = 0.2;  // point width
    points.scale.y = 0.2;  // point height

    // set orientation
    points.pose.orientation.w = 1.0;

    // Set the color
    points.color.r = 0.0f;
    points.color.g = 0.0f;
    points.color.b = 1.0f;
    points.color.a = 1.0;

    // set duration
    points.lifetime = ros::Duration();  // never expire

    // Set the position
    int count = 0;
    for (int i = 0; i < grid_size_[0]; i+=increment) {
      for (int j = 0; j < grid_size_[1]; j+=increment) {
        count = i*grid_size_[1] + j;

        // create new point
        geometry_msgs::Point p;
        p.x = x_[count];
        p.y = y_[count];
        p.z = z_[count];

        // add to array
        points.points.push_back(p);
      }
    }

    // wait for subscribers and publish
    while (points_pub.getNumSubscribers() == 0) {
      ROS_DEBUG("PlotXYZ waiting for subscibers...\n");
      sleep(1);
    }
    ROS_DEBUG("Got subscriber\n");
    points_pub.publish(points);
    ros::spinOnce();

    return;
  }

  void UWPData::PlotUVW(const double scale, const int increment) {
    ROS_INFO("Starting PlotUVW\n");

    // create publisher
    ros::Publisher marker_array_pub =
      nh_.advertise<visualization_msgs::MarkerArray>("uvw_vectors", 0, 0);
    ros::Rate r(0.5);

    visualization_msgs::MarkerArray marker_array;
    int count = 0;
    for (int i = 0; i < grid_size_[0]; i+=increment) {
      for (int j = 0; j < grid_size_[1]; j+=increment) {
        count = i*grid_size_[1] + j;

        // check if occuppied
        if (obs_mask_[i]) {
          continue;
        }

        // create marker
        visualization_msgs::Marker marker;

        // Set the frame ID and timestamp.  See the TF tutorials for information on these.
        marker.header.frame_id = "/local";
        marker.header.stamp = ros::Time::now();

        // Set the namespace and id for this marker.  This serves to create a unique ID
        // Any marker sent with the same namespace and id will overwrite the old one
        marker.ns = "uwp_plotter";
        marker.id = count;

        // Set the marker type
        marker.type = visualization_msgs::Marker::ARROW;

        // Set the marker action (ADD, DELETE, DELETEALL)
        marker.action = visualization_msgs::Marker::ADD;

        // Set the pose of the marker
        marker.pose.position.x = x_[count];
        marker.pose.position.y = y_[count];
        marker.pose.position.z = z_[count];

        Eigen::Vector3d vec1;
        vec1 << 1.0, 0.0, 0.0;
        Eigen::Vector3d vec2;
        vec2 << u_[count], v_[count], w_[count];
        vec2.normalized();
        if (vec2.hasNaN()) {
          ROS_INFO("PlotUVW: NaN in velocity\n");
        }

        Eigen::Quaternion<double> quat;
        quat.setFromTwoVectors(vec1, vec2);

        // check for infs or nans in orientation
        if (std::isnan(quat.x()) || std::isinf(quat.x())) {
          ROS_DEBUG("PlotUVW: NaN or Inf in quat\n");
          ROS_DEBUG("u: %0.2f, v: %0.2f, w: %0.2f\n", u_[count], v_[count], w_[count]);
          continue;
        } else {
          marker.pose.orientation.x = quat.x();
          marker.pose.orientation.y = quat.y();
          marker.pose.orientation.z = quat.z();
          marker.pose.orientation.w = quat.w();
        }

        // Set the scale of the marker
        marker.scale.x = scale * pow(pow(u_[count], 2) + pow(v_[count], 2) +
                                     pow(w_[count], 2), 0.5);  // arrow length
        marker.scale.y = 0.2;  // arrow width
        marker.scale.z = 0.2;  // arrow height

        // Set the color
        marker.color.r = 1.0f;
        marker.color.g = 0.0f;
        marker.color.b = 0.0f;
        marker.color.a = 1.0;

        // set duration
        marker.lifetime = ros::Duration();  // never expire

        // add to array
        marker_array.markers.push_back(marker);
      }
    }

    // publish
    while (marker_array_pub.getNumSubscribers() == 0) {
      ROS_DEBUG("PlotUVW waiting for subscibers...\n");
      sleep(1);
    }
    ROS_DEBUG("Got subscriber\n");
    marker_array_pub.publish(marker_array);
    ros::spinOnce();

    return;
  }

  void UWPData::GetVarBounds() {
    ROS_INFO("Starting InitVars\n");

    for (int i = 0; i < s2uu_.size(); i++) {
      // check uu min
      if (s2uu_[i] < s2uu_min_) {
        s2uu_min_ = s2uu_[i];
      }

      // check uu max
      if (s2uu_[i] > s2uu_max_) {
        s2uu_max_ = s2uu_[i];
      }

      // check vv min
      if (s2vv_[i] < s2vv_min_) {
        s2vv_min_ = s2vv_[i];
      }

      // check vv max
      if (s2vv_[i] > s2vv_max_) {
        s2vv_max_ = s2vv_[i];
      }

      // check ww min
      if (s2ww_[i] < s2ww_min_) {
        s2ww_min_ = s2ww_[i];
      }

      // check ww max
      if (s2ww_[i] > s2ww_max_) {
        s2ww_max_ = s2ww_[i];
      }

      // check uv min
      if (s2uv_[i] < s2uv_min_) {
        s2uv_min_ = s2uv_[i];
      }

      // check uv max
      if (s2uv_[i] > s2uv_max_) {
        s2uv_max_ = s2uv_[i];
      }

      // check vw min
      if (s2vw_[i] < s2vw_min_) {
        s2vw_min_ = s2vw_[i];
      }

      // check vw max
      if (s2vw_[i] > s2vw_max_) {
        s2vw_max_ = s2vw_[i];
      }

      // check uw min
      if (s2uw_[i] < s2uw_min_) {
        s2uw_min_ = s2uw_[i];
      }

      // check uw max
      if (s2uw_[i] > s2uw_max_) {
        s2uw_max_ = s2uw_[i];
      }
    }

    ROS_DEBUG("s2uu_min: %0.2f\n", s2uu_min_);
    ROS_DEBUG("s2uu_max: %0.2f\n", s2uu_max_);
    ROS_DEBUG("s2vv_min: %0.2f\n", s2vv_min_);
    ROS_DEBUG("s2vv_max: %0.2f\n", s2vv_max_);
    ROS_DEBUG("s2ww_min: %0.2f\n", s2ww_min_);
    ROS_DEBUG("s2ww_max: %0.2f\n", s2ww_max_);
    ROS_DEBUG("s2uv_min: %0.2f\n", s2uv_min_);
    ROS_DEBUG("s2uv_max: %0.2f\n", s2uv_max_);
    ROS_DEBUG("s2vw_min: %0.2f\n", s2vw_min_);
    ROS_DEBUG("s2vw_max: %0.2f\n", s2vw_max_);
    ROS_DEBUG("s2uw_min: %0.2f\n", s2uw_min_);
    ROS_DEBUG("s2uw_max: %0.2f\n", s2uw_max_);

    return;
  }

  void UWPData::PlotS2(std::string s2_name) {
    ROS_INFO("Starting PlotS2\n");

    // check for variance type and assign variables
    std::vector<double>* s2_ptr;
    double s2_min;
    double s2_max;
    if (s2_name == "uu") {
      ROS_INFO("Plotting S2UU\n");
      s2_ptr = &s2uu_;
      s2_min = s2uu_min_;
      s2_max = s2uu_max_;
    } else if (s2_name == "vv") {
      ROS_INFO("Plotting S2VV\n");
      s2_ptr = &s2vv_;
      s2_min = s2vv_min_;
      s2_max = s2vv_max_;
    } else if (s2_name == "ww") {
      ROS_INFO("Plotting S2WW\n");
      s2_ptr = &s2ww_;
      s2_min = s2ww_min_;
      s2_max = s2ww_max_;
    } else if (s2_name == "uv") {
      ROS_INFO("Plotting S2UV\n");
      s2_ptr = &s2uv_;
      s2_min = s2uv_min_;
      s2_max = s2uv_max_;
    } else if (s2_name == "vw") {
      ROS_INFO("Plotting S2VW\n");
      s2_ptr = &s2vw_;
      s2_min = s2vw_min_;
      s2_max = s2vw_max_;
    } else if (s2_name == "uw") {
      ROS_INFO("Plotting S2UW\n");
      s2_ptr = &s2uw_;
      s2_min = s2uw_min_;
      s2_max = s2uw_max_;
    } else {
      ROS_ERROR("PlotS2: Unrecognized variance name string\n");
      return;
    }

    nav_msgs::OccupancyGrid s2_grid;
    ros::Publisher s2_grid_pub = nh_.advertise<nav_msgs::OccupancyGrid>("s2" + s2_name, 0, 0);
    ros::Rate r(1);

    // header.
    // TODO(jakeware): DOES SEQ NEED TO BE INCREMENTED?
    s2_grid.header.stamp = ros::Time::now();
    s2_grid.header.seq = 1;
    s2_grid.header.frame_id = "/local";

    // metadata
    s2_grid.info.map_load_time = ros::Time::now();
    s2_grid.info.resolution = grid_res_;
    s2_grid.info.width = grid_size_[0];
    s2_grid.info.height = grid_size_[1];

    geometry_msgs::Pose orig;
    orig.position.x = xyz_min_[0];
    orig.position.y = xyz_min_[1];
    orig.position.z = xyz_min_[2];
    orig.orientation.x = 0.0;
    orig.orientation.y = 0.0;
    orig.orientation.z = 0.0;
    orig.orientation.w = 1.0;
    s2_grid.info.origin = orig;

    s2_grid.data = std::vector<signed char>(s2_ptr->size());
    int count = 0;
    double temp_val = 0.0;
    for (int i = 0; i < grid_size_[0]; i++) {
      for (int j = 0; j < grid_size_[1]; j++) {
        if (obs_mask_[i*grid_size_[1] + j]) {
          s2_grid.data[i + j*grid_size_[0]] = 0;
        } else {
          temp_val = round(100.0*((*s2_ptr)[count] - s2_min)/(s2_max - s2_min));
          s2_grid.data[i + j*grid_size_[0]] = static_cast<signed char>(temp_val);
        }
        count++;
      }
    }

    // wait for subscribers and publish
    while (s2_grid_pub.getNumSubscribers() == 0) {
      ROS_DEBUG("PlotS2UU waiting for subscibers...\n");
      sleep(1);
    }
    ROS_DEBUG("Got subscriber\n");
    s2_grid_pub.publish(s2_grid);
    ros::spinOnce();
    sleep(1);
    s2_grid_pub.publish(s2_grid);
    ros::spinOnce();

    return;
  }

  float UWPData::getX(Eigen::Vector3i ixyz) {
  if (checkMapBounds(ixyz)) {
    fprintf(stderr, "Bad Index\n");
    fprintf(stderr, "ixyz: %i, %i, %i\n", ixyz(0), ixyz(1),
            ixyz(2));
  }

  return x_[ixyz(0)*grid_size_[1] + ixyz(1)];
}

float UWPData::getY(Eigen::Vector3i ixyz) {
  if (checkMapBounds(ixyz)) {
    fprintf(stderr, "Bad Index\n");
    fprintf(stderr, "ixyz: %i, %i, %i\n", ixyz(0), ixyz(1),
            ixyz(2));
  }

  return y_[ixyz(0)*grid_size_[1] + ixyz(1)];
}

float UWPData::getZ(Eigen::Vector3i ixyz) {
  if (checkMapBounds(ixyz)) {
    fprintf(stderr, "Bad Index\n");
    fprintf(stderr, "ixyz: %i, %i, %i\n", ixyz(0), ixyz(1),
            ixyz(2));
  }

  return z_[ixyz(0)*grid_size_[1] + ixyz(1)];
}

Eigen::Vector3f UWPData::getXYZ(Eigen::Vector3i ixyz) {
  if (checkMapBounds(ixyz)) {
    fprintf(stderr, "Bad Index\n");
    fprintf(stderr, "ixyz: %i, %i, %i\n", ixyz(0), ixyz(1),
            ixyz(2));
  }

  Eigen::Vector3f vec;
  vec(0) = getX(ixyz);
  vec(1) = getY(ixyz);
  vec(2) = getZ(ixyz);

  return vec;
}

Eigen::Vector3i UWPData::getInd(Eigen::Vector3f pos) {
  Eigen::Vector3i ind;
  ind(0) = static_cast<int>(floor(static_cast<double>(pos(0)))) - xyz_min_(0);
  ind(1) = static_cast<int>(floor(static_cast<double>(pos(1)))) - xyz_min_(1);
  ind(2) = static_cast<int>(ceil(static_cast<double>(pos(2)))) - xyz_min_(2);

  return ind;
}

int UWPData::checkMapBounds(Eigen::Vector3i ixyz) {
  if (ixyz(0) < ixyz_min_(0) || ixyz(0) > ixyz_max_(0) || ixyz(1) < ixyz_min_(1)
      || ixyz(1) > ixyz_max_(1) || ixyz(2) < ixyz_min_(2)
      || ixyz(2) > ixyz_max_(2)) {
    return 1;
  } else {
    return 0;
  }
}

int UWPData::getObs2D(Eigen::Vector3i ixyz) {
  if (checkMapBounds(ixyz)) {
    return -1;
  } else {
    return (obs_mask_[ixyz(0)*grid_size_[1] + ixyz(1)] > 0);
  }
}

float UWPData::getU(Eigen::Vector3i ixyz) {
  if (checkMapBounds(ixyz)) {
    fprintf(stderr, "Bad Index\n");
    fprintf(stderr, "ixyz: %i, %i, %i\n", ixyz(0), ixyz(1),
            ixyz(2));
  }

  return u_[ixyz(0)*grid_size_[1] + ixyz(1)];
}

float UWPData::getV(Eigen::Vector3i ixyz) {
  if (checkMapBounds(ixyz)) {
    fprintf(stderr, "Bad Index\n");
    fprintf(stderr, "ixyz: %i, %i, %i\n", ixyz(0), ixyz(1),
            ixyz(2));
  }

  return v_[ixyz(0)*grid_size_[1] + ixyz(1)];
}

float UWPData::getW(Eigen::Vector3i ixyz) {
  if (checkMapBounds(ixyz)) {
    fprintf(stderr, "Bad Index\n");
    fprintf(stderr, "ixyz: %i, %i, %i\n", ixyz(0), ixyz(1),
            ixyz(2));
  }

  return w_[ixyz(0)*grid_size_[1] + ixyz(1)];
}

Eigen::Vector3f UWPData::getUVW(Eigen::Vector3i ixyz) {
  if (checkMapBounds(ixyz)) {
    fprintf(stderr, "Bad Index\n");
    fprintf(stderr, "ixyz: %i, %i, %i\n", ixyz(0), ixyz(1),
            ixyz(2));
  }

  Eigen::Vector3f vec;
  vec(0) = getU(ixyz);
  vec(1) = getV(ixyz);
  vec(2) = getW(ixyz);

  return vec;
}
}  // namespace uwp_ros

