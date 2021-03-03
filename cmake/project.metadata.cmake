# Default project values
set(DEX_PROJECT_NAME "smartdex-desktop")
set(DEX_DISPLAY_NAME "SmartDEX")
set(DEX_COMPANY "SmartFi")
set(DEX_WEBSITE "https://smartportal.smartfi.com")
option(DISABLE_GEOBLOCKING "Enable to disable geoblocking (for dev purpose)" OFF)

if (UNIX AND NOT APPLE)
    set(DEX_LINUX_APP_ID "dex.desktop")
endif ()

# Erases default project values with environment variables if they exist.
if (DEFINED ENV{DEX_PROJECT_NAME})
    set(DEX_PROJECT_NAME $ENV{DEX_PROJECT_NAME})
endif ()
if (DEFINED ENV{DEX_DISPLAY_NAME})
    set(DEX_DISPLAY_NAME $ENV{DEX_DISPLAY_NAME})
endif ()
if (DEFINED ENV{DEX_COMPANY})
    set(DEX_COMPANY $ENV{DEX_COMPANY})
endif ()
if (DEFINED ENV{DEX_WEBSITE})
    set(DEX_WEBSITE $ENV{DEX_WEBSITE})
endif ()

# Shows project metadata
message(STATUS "Project Metadata: ${DEX_PROJECT_NAME}.${DEX_DISPLAY_NAME}.${DEX_COMPANY}.${DEX_WEBSITE}")

macro(generate_dex_project_metafiles)
    set(DEX_TARGET_DIR "@ApplicationsDir@/${DEX_DISPLAY_NAME}")
    set(DEX_TARGET_DIR_WIN64 "@ApplicationsDirX64@/${DEX_DISPLAY_NAME}")
    set(DEX_RUN_CMD "@TargetDir@/${DEX_PROJECT_NAME}.app/Contents/MacOS/${DEX_PROJECT_NAME}")
    set(DEX_RUN_CMD_WIN64 "@TargetDir@/${DEX_PROJECT_NAME}.exe")

    # Configures installer scripts
    configure_file(${CMAKE_SOURCE_DIR}/ci_tools_atomic_dex/installer/osx/config/config.xml.in ${CMAKE_SOURCE_DIR}/ci_tools_atomic_dex/installer/osx/config/config.xml)
    configure_file(${CMAKE_SOURCE_DIR}/ci_tools_atomic_dex/installer/osx/packages/com.komodoplatform.atomicdex/meta/package.xml.in ${CMAKE_SOURCE_DIR}/ci_tools_atomic_dex/installer/osx/packages/com.komodoplatform.atomicdex/meta/package.xml)
    configure_file(${CMAKE_SOURCE_DIR}/ci_tools_atomic_dex/installer/windows/config/config.xml.in ${CMAKE_SOURCE_DIR}/ci_tools_atomic_dex/installer/windows/config/config.xml)
    configure_file(${CMAKE_SOURCE_DIR}/ci_tools_atomic_dex/installer/windows/packages/com.komodoplatform.atomicdex/meta/package.xml.in ${CMAKE_SOURCE_DIR}/ci_tools_atomic_dex/installer/windows/packages/com.komodoplatform.atomicdex/meta/package.xml)
    if (UNIX AND NOT APPLE)
        configure_file(${CMAKE_SOURCE_DIR}/cmake/install/linux/dex.appdata.xml.in ${CMAKE_SOURCE_DIR}/cmake/install/linux/dex.appdata.xml)
        configure_file(${CMAKE_SOURCE_DIR}/cmake/install/linux/dex.desktop.in ${CMAKE_SOURCE_DIR}/cmake/install/linux/dex.desktop)
    endif ()

    # Configures logo
    configure_file(${CMAKE_CURRENT_LIST_DIR}/assets/logo/dex-logo-64.png ${CMAKE_CURRENT_LIST_DIR}/cmake/install/linux/dex-logo-64.png COPYONLY)                  # Configures x64 Linux logo
    configure_file(${CMAKE_CURRENT_LIST_DIR}/assets/logo/dex-logo.png ${CMAKE_CURRENT_LIST_DIR}/cmake/install/linux/dex-logo.png COPYONLY)                        # Configures Linux logo
    configure_file(${CMAKE_CURRENT_LIST_DIR}/assets/logo/dex-logo.ico ${CMAKE_CURRENT_LIST_DIR}/cmake/install/windows/dex-logo.ico COPYONLY)                      # Configures Windows logo
    configure_file(${CMAKE_CURRENT_LIST_DIR}/assets/logo/dex-logo.icns ${CMAKE_CURRENT_LIST_DIR}/cmake/install/macos/dex-logo.icns COPYONLY)                      # Configures MacOS logo
    configure_file(${CMAKE_CURRENT_LIST_DIR}/assets/logo/dex-logo.svg ${CMAKE_CURRENT_LIST_DIR}/atomic_defi_design/assets/images/dex-logo.svg COPYONLY)           # Configures application fronted sidebar logo
    configure_file(${CMAKE_CURRENT_LIST_DIR}/assets/logo/dex-logo-dark.svg ${CMAKE_CURRENT_LIST_DIR}/atomic_defi_design/assets/images/dex-logo-dark.svg COPYONLY) # Configures application fronted sidebar logo
endmacro()