import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml
import QtQuick.Shapes
import QtQuick.Controls.Material

MyDockBase{
    id:root
    width: 300
    height: 200
    objectName: "MyDock"
    Drag.active: mouseDrag.drag.active
    Drag.supportedActions: Qt.MoveAction
    showDockArea: showControl.containsDrag | dropRec.containsDrag
    contentItem: myView
    background:
        Shape{
            id:backgroundRec
            anchors.fill: parent
            smooth: true
            antialiasing: true
            layer.enabled: true
            layer.samples: 8
            ShapePath{
                fillGradient: LinearGradient{
                    x1: 0
                    y1: titleRec.height * 2
                    x2: backgroundRec.width
                    y2: 0
                    GradientStop {position: 0; color: scope.activeFocus ? focusDarkBackColor : darkBackColor}
                    GradientStop {position: 1; color: scope.activeFocus ? focusLightBackColor : lightBackColor}
                }
                dashPattern: [1,5]
                startX: 5
                startY: 0
                PathLine{
                    x: backgroundRec.width - 5
                    y: 0
                }
                PathArc{
                    x: backgroundRec.width
                    y: 5
                    radiusX: 5
                    radiusY: 5
                }

                PathLine{
                    x: backgroundRec.width
                    y: backgroundRec.height - 5
                }
                PathArc{
                    x: backgroundRec.width - 5
                    y: backgroundRec.height
                    radiusX: 5
                    radiusY: 5
                }

                PathLine{
                    x: 5
                    y: backgroundRec.height
                }

                PathArc{
                    x: 0
                    y: backgroundRec.height - 5
                    radiusX: 5
                    radiusY: 5
                }

                PathLine{
                    x: 0
                    y: 5
                }
                PathArc{
                    x: 5
                    y: 0
                    radiusX: 5
                    radiusY: 5
                }
            }
        }

    enum Direction{
        Center,
        Left,
        Top,
        Right,
        Bottom
    }

    default property alias content: myView.data//声明的元素默认以myView为parent
    property var dockHome: root.parent//顶层父节点，用于浮动时将其parent置为顶层容器
    property bool available: false//是否初始化完成
    property string name: "未定义标题"//窗体显示的标题
    property MyTabView myTab//用于窗体处于tab停靠状态时记录所属tab
    property bool closable: true//是否可以被关闭
    property bool splittable: true//是否允许从主窗体分出来成为独立窗体
    property bool splited: false//是否从主窗体分出来成为独立窗体
    property var dockTo//停靠目标，用于静态声明中想要停靠别的窗体时使用
    property var direction: Dock.Direction.Center//停靠方向
    property bool hide: false//是否隐藏，自带的visible会受到StackLayout等控件的影响被修改，因此多封装一层
    property alias contentBackColor: myView.color//内容区背景颜色
    property alias dockFocus: scope.activeFocus//当前是否有焦点

    //可拖动的范围
    property alias dragMinX: mouseDrag.drag.minimumX
    property alias dragMaxX: mouseDrag.drag.maximumX
    property alias dragMinY: mouseDrag.drag.minimumY
    property alias dragMaxY: mouseDrag.drag.maximumY

    property color textColor: "#FFFFFF"//文字颜色
    property color darkBackColor: "#191d56"//渐变暗色
    property color lightBackColor: "#424bce"//渐变亮色
    property color focusDarkBackColor: "#191d56"//焦点渐变暗色
    property color focusLightBackColor: "#f5cc84"//焦点渐变亮色

    signal dockClosed

    Component.onCompleted:{
        dragMinX = 0
        dragMaxX = dockHome.width
        dragMinY = 0
        dragMaxY = dockHome.height - titleRec.height
        if(dockTo){
            doDockTo(dockTo, direction)
        }
        available = true
    }

    Binding {
        target: root
        property: "visible"
        value: !hide
    }

    //自身drop区域可见状态告知DockHome控件
    Binding {
        target: dockHome
        property: "childShowDockArea"
        value: showControl.containsDrag | dropRec.containsDrag
    }

    FocusScope{
        id:scope
        anchors.fill: parent
        onActiveFocusChanged: function(activeFocus){
            if(activeFocus){
                root.z = 10000
            }
            else{
                root.z = 1
            }
        }

        //标题栏
        Rectangle{
            id:titleRec
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 28
            color: "transparent"
            Label{
                text: name
                anchors.right: row_buttons.left
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: 6
                verticalAlignment: Text.AlignVCenter
                color: textColor
                font.pixelSize: 13
                font.bold: true
                elide: Text.ElideRight
                MouseArea{
                    id:mouseDrag
                    anchors.fill: parent
                    drag.target: root

                    onPressed: {
                        scope.forceActiveFocus()
                    }

                    onReleased: {
                        root.Drag.drop();
                    }

                    onPositionChanged: {
                        if(!pressed){
                            return;
                        }
                        releaseDock();
                    }
                }
            }
            Row{
                id:row_buttons
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: 3
                layoutDirection: Qt.RightToLeft
                spacing: 5
                RoundButton{
                    id:closeButton
                    anchors.verticalCenter: parent.verticalCenter
                    width: 32
                    height: 32
                    radius: 4
                    visible: closable & !splited
                    text: "\u2715"
                    font.pixelSize: 24
                    topPadding: 15
                    Material.background: "transparent"
                    Material.foreground: textColor
                    onClicked: {
                        dockClosed();
                    }
                }
                RoundButton{
                    anchors.verticalCenter: parent.verticalCenter
                    width: 32
                    height: 32
                    radius: 4
                    visible: splittable
                    text: splited ? "\u25A3":"\u29C9"
                    font.pixelSize: 20
                    bottomPadding: 13
                    Material.background: "transparent"
                    Material.foreground: textColor
                    onClicked: {
                        if(splited){
                            returnToDockHome(false)
                        }
                        else{
                            splitToWindow()
                        }
                    }
                }
            }
        }
        Rectangle{
            id:myView
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: titleRec.visible?titleRec.bottom:parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 2
            clip: true
            radius: 3
            objectName: "MyDock.ContentItem"

            DropArea{
                id:showControl
                anchors.fill: parent
            }

            Rectangle{
                id: dropRec
                width: 90
                height: 90
                z: 10000
                anchors.centerIn: parent
                color: "transparent"
                visible: showDockArea
                property bool containsDrag: leftDockReceive.containsDrag|
                                            rightDockReceive.containsDrag|
                                            topDockReceive.containsDrag|
                                            bottomDockReceive.containsDrag|
                                            centerDockReceive.containsDrag
                DropArea{
                    id:leftDockReceive
                    anchors.left: parent.left
                    anchors.top: topDockReceive.bottom
                    anchors.bottom: bottomDockReceive.top
                    width: 30
                    height: 30
                    Loader{
                        anchors.fill: parent
                        sourceComponent: recvRec
                    }
                    onDropped: function (drop){
                        drop.source.dockLeft(root);
                    }
                }
                DropArea{
                    id:rightDockReceive
                    anchors.right: parent.right
                    anchors.top: topDockReceive.bottom
                    anchors.bottom: bottomDockReceive.top
                    width: 30
                    height: 30
                    z:10000
                    Loader{
                        anchors.fill: parent
                        sourceComponent: recvRec
                    }
                    onDropped:function(drop) {
                        drop.source.dockRight(root)
                    }
                }
                DropArea{
                    id:topDockReceive
                    anchors.left: leftDockReceive.right
                    anchors.top: parent.top
                    anchors.right: rightDockReceive.left
                    width: 30
                    height: 30
                    z:10000
                    Loader{
                        anchors.fill: parent
                        sourceComponent: recvRec
                    }
                    onDropped:function(drop) {
                        drop.source.dockTop(root)
                    }
                }
                DropArea{
                    id:bottomDockReceive
                    anchors.left: leftDockReceive.right
                    anchors.bottom: parent.bottom
                    anchors.right: rightDockReceive.left
                    width: 30
                    height: 30
                    z:10000
                    Loader{
                        anchors.fill: parent
                        sourceComponent: recvRec
                    }

                    onDropped:function(drop) {
                        drop.source.dockBottom(root)
                    }
                }
                DropArea{
                    id:centerDockReceive
                    anchors.left: leftDockReceive.right
                    anchors.bottom: bottomDockReceive.top
                    anchors.right: rightDockReceive.left
                    anchors.top: topDockReceive.bottom
                    width: 30
                    height: 30
                    z:10000
                    Loader{
                        anchors.fill: parent
                        sourceComponent: recvRec
                    }
                    onDropped:function(drop) {
                        drop.source.dockCenter(root)
                    }
                }
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    myView.focus = true
                    scope.forceActiveFocus()
                }
            }
        }
    }

    onHideChanged: {
        if(hide && splited){
            returnToDockHome(false);
        }
    }

    function focusDock(){
        scope.forceActiveFocus()
    }

    function releaseDock(){
        if(root.myDockState === MyDockBase.DockState.Float){
            return;
        }
        let state = root.myDockState;
        root.myDockState = MyDockBase.DockState.Float
        root.anchors.fill = undefined
        var tmp;
        var otherItem;
        switch(state){
        case MyDockBase.DockState.Split:
            tmp = root.parent.parent.parent.parent;//定位到MySplit控件根节点
            otherItem = root.parent.otherItem.children[0];//分隔栏必定有兄弟元素
            otherItem.parent = tmp.parent;
            otherItem.myDockState = tmp.myDockState;
            otherItem.width = tmp.width;
            otherItem.height = tmp.height;
            root.parent = dockHome;
            if(otherItem.parent === dockHome){
                dockHome.myItem = otherItem;
                //tmp.destroy();
            }
            //tmp.destroy();//qt5的bug，若销毁该控件会导致otherItem被删除
            break;
        case MyDockBase.DockState.Tab:
            root.parent = dockHome;
            tmp = root.myTab;
            if(tmp.contentItem.children.length<=1){
                otherItem = tmp.contentItem.children[0];
                otherItem.parent = tmp.parent;
                otherItem.myDockState = tmp.myDockState;
                otherItem.myTab = null;
                tmp.destroy()
            }
            root.myTab = null;
            break;
        case MyDockBase.DockState.FillDock:
            tmp = root.parent.parent.parent;
            root.parent = tmp.parent;
            root.myDockState = tmp.myDockState;
            root.myTab = tmp.myTab;
            tmp.destroy();
            break;
        case MyDockBase.DockState.Center:
            break;
        default:
            console.log("未配置该类型的移除操作",state);
            break;
        }
    }

    function doDockTo(target,direction){
        switch(direction){
        case Dock.Direction.Center:
            dockCenter(target)
            break;
        case Dock.Direction.Left:
            dockLeft(target)
            break;
        case Dock.Direction.Top:
            dockTop(target)
            break;
        case Dock.Direction.Right:
            dockRight(target)
            break;
        case Dock.Direction.Bottom:
            dockBottom(target)
            break;
        }
    }

    function dockLeft(target){
        let it = root;
        let myParent;
        let source;
        let dockState;
        if(target.myDockState === MyDockBase.DockState.Float){
            var com = Qt.createComponent("Dock.qml").createObject(target.parent,
                                                                  {"x":target.x, "y":target.y, "width":target.width, "height":target.height, "dockHome":target.dockHome});
            com.name = it.name + " & " + target.name
            com.closable = false
            myParent = com.contentItem;
            source = target;
            dockState = MyDockBase.DockState.FillDock
        }
        else if(target.myDockState === MyDockBase.DockState.Tab){
            myParent = target.myTab.parent;
            source = target.myTab;
            dockState = target.myTab.myDockState;
        }
        else{
            if(target.parent === target.dockHome){
                myParent = target.dockHome.myItem
            }
            else{
                myParent = target.parent;
            }
            source = target;
            dockState = target.myDockState;
        }
        let preWidth = source.width/(source.width+it.width)
        let split = Qt.createComponent("MySplit.qml").createObject(myParent,{
                                                                       "x":source.x, "y":source.y,
                                                                       "width":source.width, "height":source.height,
                                                                       "orientation":Qt.Horizontal,
                                                                       "item1.SplitView.preferredWidth": preWidth*it.width,
                                                                       "item2.SplitView.preferredWidth": preWidth*source.width,
                                                                       "myDockState": dockState});
        source.myDockState = it.myDockState = MyDockBase.DockState.Split
        source.parent = split.item2;
        it.parent = split.item1;
    }

    function dockRight(target){
        let it = root;
        let myParent;
        let source;
        let dockState;
        if(target.myDockState === MyDockBase.DockState.Float){
            var com = Qt.createComponent("Dock.qml").createObject(target.parent,
                                                                  {"x":target.x, "y":target.y, "width":target.width, "height":target.height, "dockHome":target.dockHome});
            com.name = target.name + " & " + it.name
            com.closable = false
            com.myDockState = target.myDockState
            myParent = com.contentItem;
            source = target;
            dockState = MyDockBase.DockState.FillDock;
        }
        else if(target.myDockState === MyDockBase.DockState.Tab){
            myParent = target.myTab.parent;
            source = target.myTab;
            dockState = target.myTab.myDockState;
        }
        else{
            if(target.parent === target.dockHome){
                myParent = target.dockHome.myItem
            }
            else{
                myParent = target.parent;
            }
            source = target;
            dockState = target.myDockState;
        }
        let preWidth = source.width/(source.width+it.width)
        let split = Qt.createComponent("MySplit.qml").createObject(myParent,{
                                                                       "x":source.x, "y":source.y,
                                                                       "width":source.width, "height":source.height,
                                                                       "orientation":Qt.Horizontal,
                                                                       "item2.SplitView.preferredWidth": preWidth*it.width,
                                                                       "item1.SplitView.preferredWidth": preWidth*source.width,
                                                                       "myDockState": dockState});
        source.myDockState = it.myDockState = MyDockBase.DockState.Split;
        source.parent = split.item1;
        it.parent = split.item2;
    }

    function dockTop(target){
        let it = root;
        let myParent;
        let source;
        let dockState;
        if(target.myDockState === MyDockBase.DockState.Float){
            var com = Qt.createComponent("Dock.qml").createObject(target.parent,
                                                                  {"x":target.x, "y":target.y, "width":target.width, "height":target.height, "dockHome":target.dockHome});
            com.name = it.name + " & " + target.name
            com.closable = false
            myParent = com.contentItem;
            source = target;
            dockState = MyDockBase.DockState.FillDock;
        }
        else if(target.myDockState === MyDockBase.DockState.Tab){
            myParent = target.myTab.parent;
            source = target.myTab;
            dockState = target.myTab.myDockState;
        }
        else{
            if(target.parent === target.dockHome){
                myParent = target.dockHome.myItem
            }
            else{
                myParent = target.parent;
            }
            source = target;
            dockState = target.myDockState;
        }
        let preHeight = source.height/(source.height+it.height)
        let split = Qt.createComponent("MySplit.qml").createObject(myParent, {
                                                                       "x":source.x, "y":source.y,
                                                                       "width":source.width, "height":source.height,
                                                                       "orientation": Qt.Vertical,
                                                                       "item1.SplitView.preferredHeight": preHeight*it.height,
                                                                       "item2.SplitView.preferredHeight": preHeight*source.height,
                                                                       "myDockState": dockState});
        source.myDockState = it.myDockState = MyDockBase.DockState.Split;
        source.parent = split.item2;
        it.parent = split.item1;
    }

    function dockBottom(target){
        let it = root;
        let myParent;
        let source;
        let dockState;
        if(target.myDockState === MyDockBase.DockState.Float){
            var com = Qt.createComponent("Dock.qml").createObject(target.parent,
                                                                  {"x":target.x, "y":target.y, "width":target.width, "height":target.height, "dockHome":target.dockHome});
            com.name = target.name + " & " + it.name
            com.closable = false
            myParent = com.contentItem;
            source = target;
            dockState = MyDockBase.DockState.FillDock;
        }
        else if(target.myDockState === MyDockBase.DockState.Tab){
            myParent = target.myTab.parent;
            source = target.myTab;
            dockState = target.myTab.myDockState;
        }
        else{
            if(target.parent === target.dockHome){
                myParent = target.dockHome.myItem
            }
            else{
                myParent = target.parent;
            }
            source = target;
            dockState = target.myDockState;
        }
        let preHeight = source.height/(source.height+it.height)
        let split = Qt.createComponent("MySplit.qml").createObject(myParent, {
                                                                       "x":source.x, "y":source.y,
                                                                       "width":source.width, "height":source.height,
                                                                       "orientation": Qt.Vertical,
                                                                       "item2.SplitView.preferredHeight": preHeight*it.height,
                                                                       "item1.SplitView.preferredHeight": preHeight*source.height,
                                                                       "myDockState": dockState});
        source.myDockState = it.myDockState = MyDockBase.DockState.Split;
        source.parent = split.item1;
        it.parent = split.item2;
    }

    function dockCenter(target){
        let it = root;
        let theParent;
        let theTab;
        switch(target.myDockState){
        case MyDockBase.DockState.Float:
        case MyDockBase.DockState.Center:
        {
            var com = Qt.createComponent("Dock.qml").createObject(target.parent,
                                            {"x":target.x, "y":target.y, "width":target.width, "height":target.height, "dockHome":target.dockHome, "showDockArea":false, myDockState:MyDockBase.DockState.Float});
            com.name = target.name + " & " + it.name
            com.closable = false
            var tab = Qt.createComponent("MyTabView.qml").createObject(com.contentItem,{myDockState:MyDockBase.DockState.FillDock});
            target.myDockState = MyDockBase.DockState.Tab
            theParent = target.parent = tab.contentItem;
            theTab = target.myTab = tab;
            break;
        }
        case MyDockBase.DockState.Tab:
            theParent = target.myTab.contentItem;
            theTab = target.myTab;
            break;
        default:
        {
            if(target.parent === target.dockHome){
                theParent = target.dockHome.myItem
            }
            else{
                theParent = target.parent;
            }
            var tabView = Qt.createComponent("MyTabView.qml").createObject(theParent,{width:target.width, height:target.height, myDockState:target.myDockState});
            target.myDockState = MyDockBase.DockState.Tab
            theTab = target.myTab = tabView;
            theParent = target.parent = tabView.contentItem;
        }
        }
        it.parent = theParent;
        it.myDockState = MyDockBase.DockState.Tab;
        it.myTab = theTab;
    }

    function splitToWindow(){
        releaseDock()
        var theWindow = Qt.createComponent("MyDockWindow.qml").createObject(root.dockHome, {"width":root.width, "height":root.height});
        root.myDockState = MyDockBase.DockState.Fill
        root.parent = theWindow.myView
        root.splited = true
        theWindow.title = root.name
        theWindow.show()
    }

    function returnToDockHome(activeClose){
        let theWindow = root.parent
        root.myDockState = MyDockBase.DockState.Float
        root.width = theWindow.width
        root.height = theWindow.height
        root.parent = root.dockHome
        root.splited = false
        if(activeClose){
            root.hide = true
        }
        else{
            theWindow.closeWindow()
        }
    }
}
