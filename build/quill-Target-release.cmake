# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(quill_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(quill_FRAMEWORKS_FOUND_RELEASE "${quill_FRAMEWORKS_RELEASE}" "${quill_FRAMEWORK_DIRS_RELEASE}")

set(quill_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET quill_DEPS_TARGET)
    add_library(quill_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET quill_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${quill_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${quill_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### quill_DEPS_TARGET to all of them
conan_package_library_targets("${quill_LIBS_RELEASE}"    # libraries
                              "${quill_LIB_DIRS_RELEASE}" # package_libdir
                              "${quill_BIN_DIRS_RELEASE}" # package_bindir
                              "${quill_LIBRARY_TYPE_RELEASE}"
                              "${quill_IS_HOST_WINDOWS_RELEASE}"
                              quill_DEPS_TARGET
                              quill_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "quill"    # package_name
                              "${quill_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${quill_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Release ########################################
    set_property(TARGET quill::quill
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${quill_OBJECTS_RELEASE}>
                 $<$<CONFIG:Release>:${quill_LIBRARIES_TARGETS}>
                 )

    if("${quill_LIBS_RELEASE}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET quill::quill
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     quill_DEPS_TARGET)
    endif()

    set_property(TARGET quill::quill
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Release>:${quill_LINKER_FLAGS_RELEASE}>)
    set_property(TARGET quill::quill
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${quill_INCLUDE_DIRS_RELEASE}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET quill::quill
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Release>:${quill_LIB_DIRS_RELEASE}>)
    set_property(TARGET quill::quill
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${quill_COMPILE_DEFINITIONS_RELEASE}>)
    set_property(TARGET quill::quill
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:${quill_COMPILE_OPTIONS_RELEASE}>)

########## For the modules (FindXXX)
set(quill_LIBRARIES_RELEASE quill::quill)
