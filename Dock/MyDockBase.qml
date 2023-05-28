import QtQuick
import QtQuick.Controls

Control {
    id:myDockBase
    property bool showDockArea: false
    property var myDockState: MyDockBase.DockState.Float
    property color dockAreaBorderColor: "#e57e25"
    property color dockAreaColor: "#feeee1"
    property Component recvRec:Component{
        Rectangle{
            anchors.fill: parent
            anchors.margins: 2
            border.width: 2
            border.color: dockAreaBorderColor
            color: dockAreaColor
            opacity: 0.5
            visible: showDockArea
        }
    }

    enum DockState{
        Fill,
        Center,
        Top,
        Left,
        Right,
        Bottom,
        Float,
        Tab,
        Split,
        FillDock
    }

    states: [
        State{
            name: "Fill"
            when:myDockState === MyDockBase.DockState.Fill || myDockState === MyDockBase.DockState.Split || myDockState === MyDockBase.DockState.FillDock
            AnchorChanges {
                target: myDockBase
                anchors.left: myDockBase ? myDockBase.parent.left : undefined
                anchors.top: myDockBase ? myDockBase.parent.top : undefined
                anchors.right: myDockBase ? myDockBase.parent.right : undefined
                anchors.bottom: myDockBase ? myDockBase.parent.bottom : undefined
            }
        },
        State {
            name: "Float"
            when:myDockState === MyDockBase.DockState.Float || myDockState === MyDockBase.DockState.Tab
            AnchorChanges {
               target: myDockBase
               anchors.left:undefined
               anchors.top:undefined
               anchors.right:undefined
               anchors.bottom:undefined
            }
        },
        State {
            name: "Left"
            when:myDockState === MyDockBase.DockState.Left
            AnchorChanges {
               target: myDockBase
               anchors.left:myDockBase.parent.left
               anchors.top:myDockBase.parent.top
               anchors.right:undefined
               anchors.bottom:myDockBase.parent.bottom
            }
        },
        State {
            name: "Top"
            when:myDockState === MyDockBase.DockState.Top
            AnchorChanges {
               target: myDockBase
               anchors.left:myDockBase.parent.left
               anchors.top:myDockBase.parent.top
               anchors.right:myDockBase.parent.right
               anchors.bottom:undefined
            }
        },
        State {
            name: "Right"
            when:myDockState === MyDockBase.DockState.Right
            AnchorChanges {
               target: myDockBase
               anchors.left:undefined
               anchors.top:myDockBase.parent.top
               anchors.right:myDockBase.parent.right
               anchors.bottom:myDockBase.parent.bottom
            }
        },
        State {
            name: "Bottom"
            when:myDockState === MyDockBase.DockState.Bottom
            AnchorChanges {
               target: myDockBase
               anchors.left:myDockBase.parent.left
               anchors.top:undefined
               anchors.right:myDockBase.parent.right
               anchors.bottom:myDockBase.parent.bottom
            }
        },
        State {
            name: "Center"
            when: myDockState === MyDockBase.DockState.Center
            AnchorChanges{
                target: myDockBase
                anchors.verticalCenter: myDockBase.parent.verticalCenter
                anchors.horizontalCenter: myDockBase.parent.horizontalCenter
            }
        }
    ]

    MyBorder{
        control:myDockBase
        direction: {
            switch(myDockState){
            case MyDockBase.DockState.Fill:
            case MyDockBase.DockState.Tab:
            case MyDockBase.DockState.Split:
            case MyDockBase.DockState.FillDock:
                return MyBorder.Direction.None;
            case MyDockBase.DockState.Top:
                return MyBorder.Direction.Bottom;
            case MyDockBase.DockState.Left:
                return MyBorder.Direction.Right;
            case MyDockBase.DockState.Right:
                return MyBorder.Direction.Left;
            case MyDockBase.DockState.Bottom:
                return MyBorder.Direction.Top;
            case MyDockBase.DockState.Float:
            case MyDockBase.DockState.Center:
                return MyBorder.Direction.All;
            default:
                return MyBorder.Direction.All;
            }
        }
    }
}
