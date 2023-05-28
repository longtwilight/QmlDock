import QtQuick
import QtQuick.Controls

MyDockBase{
    objectName: "MyDockBase"
    default property alias content: view.data//声明的元素默认以myView为parent
    property alias orientation:view.orientation

    property alias item1: item11
    property alias item2: item22

    SplitView{
        id:view
        anchors.fill: parent
        clip: true
        objectName: "MySplit"
        handle: Rectangle{
            color: "transparent"
            implicitHeight: orientation === Qt.Horizontal ? view.height : 3
            implicitWidth: orientation === Qt.Horizontal ? 3 : view.width
        }

        Item{
            id:item11
            objectName: "MySplit.item11"
            SplitView.fillHeight: true
            SplitView.fillWidth: true
            SplitView.minimumWidth: 100
            SplitView.minimumHeight: 100
            property Item otherItem: item22
        }

        Item{
            id:item22
            objectName: "MySplit.item12"
            SplitView.fillHeight: true
            SplitView.fillWidth: true
            SplitView.minimumWidth: 100
            SplitView.minimumHeight: 100
            property Item otherItem: item11
        }
    }

    //修改应用宽高时splitview不会自动更新子集的大小，需要手动更新
    onWidthChanged: {
        if(width <= 0){
            return
        }
        let len = item11.width + item22.width
        item11.SplitView.preferredWidth = item11.width / len * width
        item22.SplitView.preferredWidth = (item22.width - 1.5) / len * width
    }
    onHeightChanged: {
        if(height <= 0){
            return
        }
        let len = item11.height + item22.height
        item11.SplitView.preferredHeight = item11.height / len * height
        item22.SplitView.preferredHeight = (item22.height - 1.5) / len * height
    }
}
