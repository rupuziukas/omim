IF(NOT CMAKE_SYSTEM_NAME STREQUAL "Linux")
  MESSAGE(FATAL_ERROR "Cannot configure CPack to generate Debian packages on non-linux systems.")
ENDIF()

INCLUDE(FindDebArch)

SET(CPACK_RESOURCE_FILE_README "${CMAKE_SOURCE_DIR}/README.md")
SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/LICENCE.TXT")
SET(CPACK_PACKAGE_DESCRIPTION_FILE "${CPACK_RESOURCE_FILE_README}")
SET(CPACK_PACKAGE_VERSION_MAJOR "0")
SET(CPACK_PACKAGE_VERSION_MINOR "4")
SET(CPACK_PACKAGE_VERSION_PATCH "3")

SET(CPACK_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")

string(TOLOWER "${CMAKE_PROJECT_NAME}" LOWER_PROJECT_NAME)
SET(CPACK_PACKAGE_FILE_NAME "${LOWER_PROJECT_NAME}_${CPACK_PACKAGE_VERSION}_${CPACK_DEBIAN_PACKAGE_ARCHITECTURE}")
SET(CPACK_SOURCE_PACKAGE_FILE_NAME "${LOWER_PROJECT_NAME}_${CPACK_PACKAGE_VERSION}_orig")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Open Source Routing Machine (OSRM).")
SET(CPACK_PACKAGE_DESCRIPTION "Open Source Routing Machine (OSRM) is a routing engine.")

# To create a proper Debian/Ubuntu package, the following CMake
# options should be used:

SET(CPACK_STRIP_FILES "TRUE")
SET(CPACK_INCLUDE_TOPLEVEL_DIRECTORY "FALSE")
SET(CPACK_GENERATOR "DEB")

SET(CPACK_DEBIAN_PACKAGE_NAME        "${CPACK_PACKAGE_NAME}${VERSION_SUFFIX}")
SET(CPACK_DEBIAN_PACKAGE_VERSION     "${CPACK_PACKAGE_VERSION}${CPACK_PACKAGE_REVISION}")
SET(CPACK_DEBIAN_PACKAGE_MAINTAINER  "Dennis Luxen <info@project-osrm.org>")
SET(CPACK_DEBIAN_PACKAGE_PRIORITY    "optional")
SET(CPACK_DEBIAN_PACKAGE_SECTION     "devel")
SET(CPACK_DEBIAN_PACKAGE_DESCRIPTION "Open Source Routing Machine (OSRM) is a high-performance routing engine.
  It combines sophisticated routing algorithms with the open and free data of the OpenStreetMap."
)
SET(CPACK_DEBIAN_PACKAGE_DEPENDS     "libc6-dev, libprotobuf-dev, libosmpbf-dev, libbz2-1.0, libstxxl1, libxml2, libzip2, liblua5.1-0, libtbb2, libboost-all-dev")

file(GLOB_RECURSE ProfileGlob ${CMAKE_SOURCE_DIR}/profiles/*)
install(FILES ${ProfileGlob} DESTINATION "share/doc/${LOWER_PROJECT_NAME}/profiles")
CONFIGURE_FILE (${CMAKE_SOURCE_DIR}/cmake/postinst.in postinst)
set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_CURRENT_BINARY_DIR}/postinst;${CMAKE_CURRENT_BINARY_DIR}/copyright;")

MESSAGE(STATUS "Debian Package: ${CPACK_DEBIAN_PACKAGE_NAME} (${CPACK_DEBIAN_PACKAGE_VERSION}) [${CPACK_PACKAGE_FILE_NAME}.deb]")
