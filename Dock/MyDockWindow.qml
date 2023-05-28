import QtQuick
import QtQuick.Window
import QtQuick.Controls

ApplicationWindow{
    id: root
    property alias myView: view;
    property bool activeClose: true;//是否主动关闭

    Item{
        id:view;
        anchors.fill: parent;
        //dock组件访问不到root的方法，所以需要在此声明以便dock能够访问
        function closeWindow(){
            activeClose = false;
            root.close();
        }
    }
    onClosing: {
        if(activeClose){
            view.children[0].returnToDockHome(activeClose);
        }
    }
}
