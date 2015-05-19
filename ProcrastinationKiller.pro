TEMPLATE = app

QT += qml quick widgets sql

SOURCES += main.cpp \
    extensionmanager.cpp \
    alarm.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    img/textfield.png

HEADERS += \
    include/extensionmanager.h \
    include/alarm.h
