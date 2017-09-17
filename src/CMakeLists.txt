# Main library.
# add_subdirectory(./mlm_ros)

# uwp_data
add_library(uwp_data uwp_data/uwp_data.cc)
# target_link_libraries(uwp_data
#   ${PROJECT_NAME}
#   )
install(TARGETS uwp_data
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})

# uwp_app
add_library(uwp_app uwp_app/uwp_app.cc)
# target_link_libraries(uwp_data
#   ${PROJECT_NAME}
#   )
install(TARGETS uwp_app
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})

# uwp_node
add_library(uwp_node uwp_node/uwp_node.cc)
target_link_libraries(uwp_node
  uwp_data
  )
install(TARGETS uwp_node
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
  )

# uwp_astar
add_library(uwp_astar uwp_astar/uwp_astar.cc)
target_link_libraries(uwp_astar
  uwp_data
  uwp_node
  uwp_app
  )
install(TARGETS uwp_astar
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
  )


# uwp_planner
add_library(uwp_planner uwp_planner/uwp_planner.cc)
target_link_libraries(uwp_planner
  uwp_app
  uwp_data
  uwp_node
  uwp_astar
  )
install(TARGETS uwp_planner
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
  )

# uwp_main
add_library(uwp_main uwp_main.cc)
target_link_libraries(uwp_main
  uwp_app
  uwp_data
  uwp_planner
  )
install(TARGETS uwp_main
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
  )

# uwp_plotter
add_library(uwp_plotter uwp_plotter.cc)
target_link_libraries(uwp_plotter
  uwp_data
  )
install(TARGETS uwp_plotter
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
  )
