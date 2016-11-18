# Setup optional dependencies and features
# alters these things
#
# 	GSCF_DEPENDENCIES			everyone needs these libraries
# 	GSCF_DEPENDENCIES_DEBUG		debug mode needs these extras
# 	GSCF_DEPENDENCIES_RELEASE		release mode needs these extras
# 	GSCF_DEPENDENCIES_TEST		tests need these extra libraries
#
#       GSCF_DEFINITIONS			definitions for all compilation
#       GSCF_DEFINITIONS_DEBUG		definitions for debug mode
#       GSCF_DEFINITIONS_RELEASE		definitions for release mode
#

####################
#-- C++ standard --#
####################
if (NOT CMAKE_CXX_STANDARD VERSION_LESS 14)
	message(STATUS "Detected C++14 support: Setting GSCF_HAVE_CXX14")
	LIST(APPEND GSCF_DEFINITIONS "GSCF_HAVE_CXX14")
endif()
if (NOT CMAKE_CXX_STANDARD VERSION_LESS 17)
	message(STATUS "Detected C++17 support: Setting GSCF_HAVE_CXX17")
	LIST(APPEND GSCF_DEFINITIONS "GSCF_HAVE_CXX17")
endif()

