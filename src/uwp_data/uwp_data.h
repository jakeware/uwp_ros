# pragma once

// Copyright 2014 Massachusetts Intitute of Technology

/**
 * uwp_data - load, store, parse, and visualize wind data
 */

// c system includes

// cpp system includes
#include <string>
#include <vector>
#include <fstream>
#include <limits>

// external library includes
#include "ros/ros.h"
#include "Eigen/Dense"
#include "octomap/octomap.h"
#include "geometry_msgs/Point.h"
#include "geometry_msgs/Pose.h"
#include "visualization_msgs/Marker.h"
#include "visualization_msgs/MarkerArray.h"
#include "nav_msgs/OccupancyGrid.h"

// project includes

namespace uwp_ros {
  /**
   * \brief UWPData class
   *
   * Loads, stores, parses, and visualizes wind data
  */
class UWPData final {
 public:
  explicit UWPData(const ros::NodeHandle& nh);
  ~UWPData();
  UWPData(const UWPData& rhs) = delete;
  UWPData& operator=(const UWPData& rhs) = delete;

  /**
   * \brief Get position bounds
   *
   * Gets xyz position bounds of map.
   */
  void GetXYZBounds();

  /**
   * \brief Plots regular grid points.
   *
   * Plots markers at each regular grid point in rviz.
   *
   * @param nh[input] ros node handle.
   * @param scale[input] scale factor.
   * @param increment[input] downsampling step size.
   */
  void PlotXYZ(const double scale, const int increment);

  /**
   * \brief Gets velocity value.
   *
   * Returns the appropriate velocity value at a given xyz position.
   *
   * @param pos[input] xyz position vector.
   * @param vel[output] interpolated velocity.
   */
  double GetU(const Eigen::Vector3d &pos);
  double GetV(const Eigen::Vector3d &pos);
  double GetW(const Eigen::Vector3d &pos);
  Eigen::Vector3d GetUVW(const Eigen::Vector3d &pos);

  /**
   * \brief Plots velocity at regular grid points..
   *
   * Creates a quiver plot of the uvw velocity vector at each regular grid point.
   *
   * @param nh[input] ros node handle.
   * @param scale[input] scale factor.
   * @param increment[input] downsampling step size.
   */
  void PlotUVW(const double scale, const int increment);

  /**
   * \brief Gets variance value.
   *
   * Returns the appropriate covariance matrix for a given xyz position.
   *
   * @param pos[input] xyz position vector.
   * @param var[output] 3x3 velocity covariance.
   */
  Eigen::Matrix3d getS2(Eigen::Vector3d pos);

  /**
   * \brief Get velocity variance bounds
   *
   * Finds the minimum and maximum variance values for each component.
   */
  void GetVarBounds();

  /**
   * \brief Plots velocity variance at regular grid points..
   *
   * Creates an occupancy grid, cost function visualization of a single component of the velocity variance.
   *
   * @param nh[input] ros node handle.
   * @param s2_name[input] variance identifier string.
   */
  void PlotS2(std::string s2_name);

  /**
   * \brief Initializes occupancy grid variables.
   *
   * Creates an occupancy grid from the given occupancy data.
   */
  void InitOccGrid();

  /**
   * \brief Inflates obstacles in occupancy grid.
   *
   * Not implemented.
   */
  void InflateOccGrid();

  /**
   * \brief Gets occupancy value.
   *
   * Returns the occupancy at a given xyz position.
   *
   * @param pos[input] xyz position vector.
   * @param occ[output] occupancy value.
   */
  bool GetOcc(Eigen::Vector3d pos);
  bool GetInfOcc(Eigen::Vector3d pos);

    /**
   * \brief Plots occupancy grid.
   *
   * Plots occupancy grid data in rviz.
   *
   * @param nh[input] ros node handle.
   */
  void PlotOccGrid();
  void PlotInfObsGrid();

  /**
   * \brief Loads relevant params.
   */
  void GetParams(const std::string &param_string);

  /**
   * \brief Loads wind data.
   */
  void LoadUnsteadyData();

    /**
   * \brief Reads data from CSV file into vector.
   *
   * Plots occupancy grid data in rviz.
   *
   * @param path[input] file path.
   * @param vec[output] data vector.
   */
  std::vector<double> ReadVectorDouble(const std::string& path);
  std::vector<int> ReadVectorInt(const std::string& path);
  double ReadDouble(const std::string& path);
  int ReadInt(const std::string& path);

  float getX(Eigen::Vector3i ixyz);
  float getY(Eigen::Vector3i ixyz);
  float getZ(Eigen::Vector3i ixyz);
  Eigen::Vector3f getXYZ(Eigen::Vector3i ixyz);
  Eigen::Vector3i getInd(Eigen::Vector3f pos);
  int checkMapBounds(Eigen::Vector3i ixyz);
  int getObs2D(Eigen::Vector3i ixyz);
  float getU(Eigen::Vector3i ixyz);
  float getV(Eigen::Vector3i ixyz);
  float getW(Eigen::Vector3i ixyz);
  Eigen::Vector3f getUVW(Eigen::Vector3i ixyz);

  Eigen::Vector3i ixyz_min_;
  Eigen::Vector3i ixyz_max_;

  // private:
  ros::NodeHandle nh_;

  // map origin offset (start_state)
  Eigen::Vector4f start_state;
  Eigen::Vector3f start_pos;
  Eigen::Vector3i start_ixyz;

  // grid dimensions
  Eigen::Vector3d xyz_min_;
  Eigen::Vector3d xyz_max_;
  std::vector<int> grid_size_;
  double grid_res_;  // xy grid resolutions
  double grid_height_;  // height of map

  // occupancy
  std::vector<int> obs_mask_;
  nav_msgs::OccupancyGrid occ_grid_;
  int r_obs;

  // position
  std::vector<double> x_;
  std::vector<double> y_;
  std::vector<double> z_;

  // velocity mean
  std::vector<double> u_;
  std::vector<double> v_;
  std::vector<double> w_;

  // velocity variance
  std::vector<double> s2uu_;
  std::vector<double> s2vv_;
  std::vector<double> s2ww_;
  std::vector<double> s2uv_;
  std::vector<double> s2vw_;
  std::vector<double> s2uw_;

  // velocity variance min and max
  double s2uu_min_;
  double s2uu_max_;
  double s2vv_min_;
  double s2vv_max_;
  double s2ww_min_;
  double s2ww_max_;
  double s2uv_min_;
  double s2uv_max_;
  double s2vw_min_;
  double s2vw_max_;
  double s2uw_min_;
  double s2uw_max_;

  // paths and filenames
  std::string wind_path_;
  std::string x_fname_;
  std::string y_fname_;
  std::string z_fname_;
  std::string u_fname_;
  std::string v_fname_;
  std::string w_fname_;
  std::string s2uu_fname_;
  std::string s2vv_fname_;
  std::string s2ww_fname_;
  std::string s2uv_fname_;
  std::string s2vw_fname_;
  std::string s2uw_fname_;
  std::string obs_mask_fname_;
  std::string grid_size_fname_;
  std::string grid_res_fname_;
  std::string grid_height_fname_;
};
}  // namespace uwp_ros
