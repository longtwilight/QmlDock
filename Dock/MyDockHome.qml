import QtQuick
import QtQuick.Controls

MyDockBase {
    id:myDockHome
    anchors.margins: 2
    showDockArea: childShowDockArea | dropRec.containsDrag
    myDockState: MyDockBase.DockState.Fill
    property var myItem: myView
    property bool childShowDockArea: false

    MyDockBase{
        id: myView
        anchors.fill: parent
        objectName: "DockHomeContent"
        myDockState: MyDockBase.DockState.Fill
    }

    Rectangle{
        id:dropRec
        z:9999
        anchors.fill: parent
        anchors.margins: 25
        color:"transparent"
        property bool containsDrag: leftDockReceive.containsDrag|
                                    rightDockReceive.containsDrag|
                                    topDockReceive.containsDrag|
                                    bottomDockReceive.containsDrag

        DropArea{
            id:leftDockReceive
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: parent.height*0.3
            Loader{
                anchors.fill: parent
                sourceComponent: recvRec
            }
            onDropped: function (drop){
                dockLeftBy(drop.source);
            }
        }
        DropArea{
            id:rightDockReceive
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: parent.height*0.3
            z:10000
            Loader{
                anchors.fill: parent
                sourceComponent: recvRec
            }
            onDropped:function(drop) {
                dockRightBy(drop.source)
            }
        }
        DropArea{
            id:topDockReceive
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width*0.3
            height: 40
            z:10000
            Loader{
                anchors.fill: parent
                sourceComponent: recvRec
            }
            onDropped:function(drop) {
                dockTopBy(drop.source)
            }
        }
        DropArea{
            id:bottomDockReceive
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width*0.3
            height: 40
            z:10000
            Loader{
                anchors.fill: parent
                sourceComponent: recvRec
            }

            onDropped:function(drop) {
                dockBottomBy(drop.source)
            }
        }
    }
    function dockLeftBy(it){
        let source = myItem;
        let myParent = source.parent;
        let split = Qt.createComponent("MySplit.qml").createObject(myParent, {myDockState: MyDockBase.DockState.Fill, "orientation":Qt.Horizontal});
        let preWidth = source.width/(source.width+it.width)
        split.item1.SplitView.preferredWidth = preWidth*it.width
        split.item2.SplitView.preferredWidth = preWidth*source.width
        source.myDockState = it.myDockState = MyDockBase.DockState.Split
        source.parent = split.item2;
        it.parent = split.item1;
        myItem = split
    }

    function dockRightBy(it){
        let source = myItem;
        let myParent = source.parent;
        let split = Qt.createComponent("MySplit.qml").createObject(myParent, {myDockState: MyDockBase.DockState.Fill, "orientation":Qt.Horizontal});
        let preWidth = source.width/(source.width+it.width)
        split.item2.SplitView.preferredWidth = preWidth*it.width
        split.item1.SplitView.preferredWidth = preWidth*source.width
        source.myDockState = it.myDockState = MyDockBase.DockState.Split;
        source.parent = split.item1;
        it.parent = split.item2;
        myItem = split
    }

    function dockTopBy(it){
        let source = myItem;
        let myParent = source.parent;
        let split = Qt.createComponent("MySplit.qml").createObject(myParent, {myDockState: MyDockBase.DockState.Fill, "orientation":Qt.Vertical});
        let preHeight = source.height/(source.height+it.height)
        split.item1.SplitView.preferredHeight = preHeight*it.height
        split.item2.SplitView.preferredHeight = preHeight*source.height
        source.myDockState = it.myDockState = MyDockBase.DockState.Split;
        source.parent = split.item2;
        it.parent = split.item1;
        myItem = split
    }

    function dockBottomBy(it){
        let source = myItem;
        let myParent = source.parent;
        let split = Qt.createComponent("MySplit.qml").createObject(myParent, {myDockState: MyDockBase.DockState.Fill, "orientation":Qt.Vertical});
        let preHeight = source.height/(source.height+it.height)
        split.item2.SplitView.preferredHeight = preHeight*it.height
        split.item1.SplitView.preferredHeight = preHeight*source.height
        source.myDockState = it.myDockState = MyDockBase.DockState.Split;
        source.parent = split.item1;
        it.parent = split.item2;
        myItem = split
    }
}
