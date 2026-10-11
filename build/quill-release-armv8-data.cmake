########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(quill_COMPONENT_NAMES "")
if(DEFINED quill_FIND_DEPENDENCY_NAMES)
  list(APPEND quill_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES quill_FIND_DEPENDENCY_NAMES)
else()
  set(quill_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(quill_PACKAGE_FOLDER_RELEASE "/data/data/com.termux/files/home/.conan2/p/quillff11ee146eba3/p")
set(quill_BUILD_MODULES_PATHS_RELEASE )


set(quill_INCLUDE_DIRS_RELEASE "${quill_PACKAGE_FOLDER_RELEASE}/include")
set(quill_RES_DIRS_RELEASE )
set(quill_DEFINITIONS_RELEASE )
set(quill_SHARED_LINK_FLAGS_RELEASE )
set(quill_EXE_LINK_FLAGS_RELEASE )
set(quill_OBJECTS_RELEASE )
set(quill_COMPILE_DEFINITIONS_RELEASE )
set(quill_COMPILE_OPTIONS_C_RELEASE )
set(quill_COMPILE_OPTIONS_CXX_RELEASE )
set(quill_LIB_DIRS_RELEASE )
set(quill_BIN_DIRS_RELEASE )
set(quill_LIBRARY_TYPE_RELEASE UNKNOWN)
set(quill_IS_HOST_WINDOWS_RELEASE 0)
set(quill_LIBS_RELEASE )
set(quill_SYSTEM_LIBS_RELEASE pthread rt)
set(quill_FRAMEWORK_DIRS_RELEASE )
set(quill_FRAMEWORKS_RELEASE )
set(quill_BUILD_DIRS_RELEASE )
set(quill_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(quill_COMPILE_OPTIONS_RELEASE)
if (NOT "${quill_COMPILE_OPTIONS_CXX_RELEASE}" STREQUAL "")
    list(APPEND quill_COMPILE_OPTIONS_RELEASE
        "$<$<COMPILE_LANGUAGE:CXX>:${quill_COMPILE_OPTIONS_CXX_RELEASE}>")
endif ()
if (NOT "${quill_COMPILE_OPTIONS_C_RELEASE}" STREQUAL "")
    list(APPEND quill_COMPILE_OPTIONS_RELEASE
        "$<$<COMPILE_LANGUAGE:C>:${quill_COMPILE_OPTIONS_C_RELEASE}>")
endif ()
set(quill_LINKER_FLAGS_RELEASE)
if (NOT "${quill_SHARED_LINK_FLAGS_RELEASE}" STREQUAL "")
    list(APPEND quill_LINKER_FLAGS_RELEASE
        "$<$<OR:$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>,$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>>:${quill_SHARED_LINK_FLAGS_RELEASE}>")
endif ()
if (NOT "${quill_EXE_LINK_FLAGS_RELEASE}" STREQUAL "")
    list(APPEND quill_LINKER_FLAGS_RELEASE
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${quill_EXE_LINK_FLAGS_RELEASE}>")
endif ()


set(quill_COMPONENTS_RELEASE )