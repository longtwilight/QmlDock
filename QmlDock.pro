QT += quick

SOURCES += \
        main.cpp

resources.files = main.qml \
    Dock/
resources.prefix = /$${TARGET}
RESOURCES += resources

TRANSLATIONS += \
    QmlDock_zh_CN.ts
CONFIG += lrelease
CONFIG += embed_translations

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    Dock/Dock.qml \
    Dock/MyBorder.qml \
    Dock/MyDockBase.qml \
    Dock/MyDockHome.qml \
    Dock/MyDockWindow.qml \
    Dock/MySplit.qml \
    Dock/MyTabView.qml
