add_subdirectory(QR-Code-generator)
add_subdirectory(QR-Code-scanner)
add_subdirectory(daemon)
add_subdirectory(libwalletqt)
add_subdirectory(model)
add_subdirectory(zxcvbn-c)

qt5_add_resources(RESOURCES ../qml.qrc)

# Compile source files (.h/.cpp)
file(GLOB SOURCE_FILES
	"*.h"
	"*.cpp"
    "main/*.h"
    "main/*.cpp"
    "libwalletqt/WalletManager.cpp"
    "libwalletqt/Wallet.cpp"
    "libwalletqt/PendingTransaction.cpp"
    "libwalletqt/TransactionHistory.cpp"
    "libwalletqt/TransactionInfo.cpp"
    "libwalletqt/QRCodeImageProvider.cpp" QR
    "QR-Code-generator/BitBuffer.cpp"
    "QR-Code-generator/QrCode.cpp"
    "QR-Code-generator/QrSegment.cpp"
    "libwalletqt/AddressBook.cpp"
    "libwalletqt/Subaddress.cpp"
    "libwalletqt/SubaddressAccount.cpp"
    "libwalletqt/UnsignedTransaction.cpp"
    "libwalletqt/WalletManager.h"
    "libwalletqt/Wallet.h"
    "libwalletqt/PendingTransaction.h"
    "libwalletqt/TransactionHistory.h"
    "libwalletqt/TransactionInfo.h"
    "libwalletqt/QRCodeImageProvider.h"
    "QR-Code-generator/BitBuffer.h"
    "QR-Code-generator/QrCode.h"
    "QR-Code-generator/QrSegment.h"
    "libwalletqt/Transfer.h"
    "libwalletqt/AddressBook.h"
    "libwalletqt/Subaddress.h"
    "libwalletqt/SubaddressAccount.h"
    "libwalletqt/UnsignedTransaction.h"
	"daemon/*.h"
	"daemon/*.cpp"
	"model/*.h"
	"model/*.cpp"
	"qt/*.h"
    "qt/*.cpp"
)

if(ENABLE_PASS_STRENGTH_METER)
    file(GLOB PASS_STRENGTH_FILES
        "zxcvbn-c/zxcvbn.h"
        "zxcvbn-c/zxcvbn.c"
    )
endif()

if(WITH_SCANNER)
    file(GLOB QR_CODE_FILES
        "QR-Code-generator/*.h"
    	"QR-Code-generator/*.cpp"
    	"QR-Code-scanner/*.h"
    	"QR-Code-scanner/*.cpp"
    )
endif()

set(EXECUTABLE_FLAG)
if(MINGW)
    set(EXECUTABLE_FLAG WIN32)

    set(ICON ${PROJECT_SOURCE_DIR}/images/appicon.ico)
    set(ICON_RC ${CMAKE_CURRENT_BINARY_DIR}/icon.rc)
    set(ICON_RES ${CMAKE_CURRENT_BINARY_DIR}/icon.o)
    file(WRITE ${ICON_RC} "IDI_ICON1 ICON DISCARDABLE \"${ICON}\"")
    add_custom_command(OUTPUT ${ICON_RES} COMMAND windres ${ICON_RC} ${ICON_RES} MAIN_DEPENDENCY ${ICON_RC})
    list(APPEND RESOURCES ${ICON_RES})
endif()

add_executable(byterub-gui ${EXECUTABLE_FLAG} main/main.cpp
    ${SOURCE_FILES}
    ${PASS_STRENGTH_FILES}
    ${QR_CODE_FILES}
    ${RESOURCES}
)
set_property(TARGET byterub-gui PROPERTY RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

# OpenGL
target_include_directories(byterub-gui PUBLIC ${OPENGL_INCLUDE_DIR})
message(STATUS "OpenGL: include dir at ${OPENGL_INCLUDE_DIR}")
message(STATUS "OpenGL: libraries at ${OPENGL_LIBRARIES}")

target_include_directories(byterub-gui PUBLIC ${Qt5Gui_PRIVATE_INCLUDE_DIRS})

file(GLOB_RECURSE SRC_SOURCES *.cpp)
file(GLOB_RECURSE SRC_HEADERS *.h)

target_include_directories(byterub-gui PUBLIC
	${CMAKE_SOURCE_DIR}/byterub/include
    ${CMAKE_SOURCE_DIR}/byterub/src
	${CMAKE_CURRENT_SOURCE_DIR}
	${CMAKE_CURRENT_SOURCE_DIR}/daemon
	${CMAKE_CURRENT_SOURCE_DIR}/libwalletqt
	${CMAKE_CURRENT_SOURCE_DIR}/model
	${CMAKE_CURRENT_SOURCE_DIR}/QR-Code-generator
	${CMAKE_CURRENT_SOURCE_DIR}/QR-Code-scanner
	${CMAKE_CURRENT_SOURCE_DIR}/zxcvbn-c
    ${LibUSB_INCLUDE_DIRS}
    ${HIDAPI_INCLUDE_DIRS}
    ${X11_INCLUDE_DIR}
    ${Boost_INCLUDE_DIRS}
    ${OPENSSL_INCLUDE_DIR}
    ${ZBAR_INCLUDE_DIR}
)

target_compile_definitions(byterub-gui
	PUBLIC
	${Qt5Widgets_DEFINITIONS}
    ${Qt5Qml_DEFINITIONS}
)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${Qt5Widgets_EXECUTABLE_COMPILE_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")

if(X11_FOUND)
    target_link_libraries(byterub-gui ${X11_LIBRARIES} pthread dl Xt xcb X11)
endif()

if(DEVICE_TREZOR_READY)
    target_link_libraries(byterub-gui ${TREZOR_DEP_LIBS})
endif()

target_link_libraries(byterub-gui
    ${CMAKE_BINARY_DIR}/lib/libwallet_merged.a
    ${LMDB_LIBRARY}
    ${CMAKE_BINARY_DIR}/byterub/contrib/epee/src/libepee.a
    ${CMAKE_BINARY_DIR}/byterub/external/unbound/libunbound.a
    ${SODIUM_LIBRARY}
    ${CMAKE_BINARY_DIR}/byterub/external/easylogging++/libeasylogging.a
    ${CMAKE_BINARY_DIR}/byterub/src/blockchain_db/libblockchain_db.a
    ${CMAKE_BINARY_DIR}/byterub/external/randomx/librandomx.a
    ${CMAKE_BINARY_DIR}/byterub/src/hardforks/libhardforks.a
    ${Boost_LIBRARIES}
    ${OPENSSL_LIBRARIES}
    ${CMAKE_DL_LIBS}
    ${LibUSB_LIBRARIES}
    ${HIDAPI_LIBRARIES}
    ${QT5_LIBRARIES}
    ${EXTRA_LIBRARIES}
    ${ICU_LIBRARIES}
)

if(WITH_SCANNER)
    target_link_libraries(byterub-gui 
        ${ZBAR_LIBRARIES}
        jpeg
        v4l2
        v4lconvert
        rt
    )
endif()

install(TARGETS byterub-gui
    DESTINATION ${CMAKE_INSTALL_PREFIX}
)
