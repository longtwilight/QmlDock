import QtQuick
import QtQml
import QtQuick.Controls
import QtQuick.Window
import "./Dock/"

ApplicationWindow {
    width: 1400
    height: 800
    visible: true
    title: qsTr("QmlDock Demo")
    MyDockHome{
        id: dockHome
        myDockState: MyDockBase.DockState.Fill
        anchors.margins: 2
        Dock{
            id: dock1
            width: 600
            height: 550
            name: "dock1"
            dockHome: dockHome
            closable: false
            dockTo: dock3
            direction: Dock.Direction.Center
        }
        Dock{
            id: dock2
            width: 300
            height: 600
            name: "dock2"
            dockHome: dockHome
            splittable: false
            dockTo: dock3
            direction: Dock.Direction.Left
        }
        Dock{
            id: dock3
            myDockState: MyDockBase.DockState.Fill
            name: "dock3"
            dockHome: dockHome
        }
        Dock{
            id: dock4
            width: 400
            height: 400
            myDockState: MyDockBase.DockState.Center
            name: "dock4"
            dockHome: dockHome
            closable: false
            splittable: false
        }
    }
}
