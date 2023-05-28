import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml
import QtQuick.Controls.Material

MyDockBase{
    id: root
    contentItem: view
    bottomPadding: myTab.height-3
    objectName: "MyTabView"
    default property alias children: view.children//声明的元素默认以myView为parent

    StackLayout{
        id:view
        z:2
        objectName: "MyTabView.Data"
        currentIndex: myTab.currentIndex
    }

    TabBar {
        id:myTab
        z:1
        objectName: "MyTabView.Bar"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right:parent.right
        height: 40
        spacing: 0
        Repeater{
            model: view.children
            TabButton{
                height: parent.height
                text: modelData.name
            }
        }
    }

    function switchToIndex(index){
        myTab.currentIndex = index
    }
}
