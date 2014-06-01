# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = PublicRoute

CONFIG += sailfishapp

SOURCES += src/PublicRoute.cpp

OTHER_FILES += qml/PublicRoute.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/PublicRoute.spec \
    rpm/PublicRoute.yaml \
    PublicRoute.desktop \
    qml/pages/MapPage.qml \
    qml/showMap.html

HEADERS +=

