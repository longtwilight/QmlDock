import QtQuick
import QtQuick.Controls

Item {
    id: root
    anchors.fill: parent
    z:10000
    property var control: parent
    property int direction

    enum Direction{
        None = 0,
        Top = 1,
        Right = 2,
        Bottom = 4,
        Left = 8,
        All = 15
    }

    //右上角
    MouseArea {
        id:mouseRightTop
        implicitWidth: 3
        implicitHeight: 3
        anchors.top: root.top
        anchors.right: root.right
        hoverEnabled: true
        enabled: (parent.direction & 3) == 3
        property int lastX: 0
        property int lastY: 0
        onContainsMouseChanged: {
            cursorShape = Qt.SizeBDiagCursor;
        }
        onPressed: {
            lastX = mouseX;
            lastY = mouseY;
        }
        onPositionChanged: {
            if(pressed){
                let xOffset = mouseX - lastX
                let yOffset = mouseY - lastY
                //向左拖动时，xOffset为负数
                if (control.width + xOffset > 0)
                    control.width += xOffset;
                if (control.height - yOffset > 0)
                    control.height -= yOffset;
                if (control.y + yOffset < control.y + control.height)
                    control.y += yOffset;
            }
        }
    }

    //右边
    MouseArea {
        implicitWidth: 3
        anchors.top: mouseRightTop.bottom
        anchors.right: root.right
        anchors.bottom:mouseRightBottom.top
        hoverEnabled: true
        enabled: (parent.direction & 2) == 2
        property int lastX: 0
        property int lastY: 0
        onContainsMouseChanged: {
            cursorShape = Qt.SizeHorCursor;
        }
        onPressed: {
            lastX = mouseX;
            lastY = mouseY;
        }
        onPositionChanged: {
            if(pressed){
                let xOffset = mouseX - lastX
                let yOffset = mouseY - lastY
                if (control.width + xOffset > 0)
                    control.width += xOffset;
            }
        }
    }

    //右下角
    MouseArea {
        id:mouseRightBottom
        implicitWidth: 3
        implicitHeight: 3
        anchors.right: root.right
        anchors.bottom: root.bottom
        hoverEnabled: true
        enabled: (parent.direction & 6) == 6
        property int lastX: 0
        property int lastY: 0
        onContainsMouseChanged: {
            cursorShape = Qt.SizeFDiagCursor;
        }
        onPressed: {
            lastX = mouseX;
            lastY = mouseY;
        }
        onPositionChanged: {
            if(pressed){
                let xOffset = mouseX - lastX
                let yOffset = mouseY - lastY
                if (control.width + xOffset > 0)
                    control.width += xOffset;
                if (control.height + yOffset > 0)
                    control.height += yOffset;
            }
        }
    }

    //下边
    MouseArea {
        implicitHeight: 3
        anchors.left:mouseLeftBottom.right
        anchors.right: mouseRightBottom.left
        anchors.bottom: root.bottom
        hoverEnabled: true
        enabled: (parent.direction & 4) == 4
        property int lastX: 0
        property int lastY: 0
        onContainsMouseChanged: {
            cursorShape = Qt.SizeVerCursor;
        }
        onPressed: {
            lastX = mouseX;
            lastY = mouseY;
        }
        onPositionChanged: {
            if(pressed){
                let xOffset = mouseX - lastX
                let yOffset = mouseY - lastY
                if (control.height + yOffset > 0)
                    control.height += yOffset;
            }
        }
    }

    //左下角
    MouseArea {
        id:mouseLeftBottom
        implicitWidth: 3
        implicitHeight: 3
        anchors.left: root.left
        anchors.bottom: root.bottom
        hoverEnabled: true
        enabled: (parent.direction & 12) == 12
        property int lastX: 0
        property int lastY: 0
        onContainsMouseChanged: {
            cursorShape = Qt.SizeBDiagCursor;
        }
        onPressed: {
            lastX = mouseX;
            lastY = mouseY;
        }
        onPositionChanged: {
            if(pressed){
                let xOffset = mouseX - lastX
                let yOffset = mouseY - lastY
                if (control.x + xOffset < control.x + control.width)
                    control.x += xOffset;
                if (control.width - xOffset > 0)
                    control.width-= xOffset;
                if (control.height + yOffset > 0)
                    control.height += yOffset;
            }
        }
    }

    //左
    MouseArea {
        implicitWidth: 3
        anchors.top:mouseLeftTop.bottom
        anchors.bottom: mouseLeftBottom.top
        anchors.left: root.left
        hoverEnabled: true
        enabled: (parent.direction & 8) == 8
        property int lastX: 0
        property int lastY: 0
        onContainsMouseChanged: {
            cursorShape = Qt.SizeHorCursor;
        }
        onPressed: {
            lastX = mouseX;
            lastY = mouseY;
        }
        onPositionChanged: {
            if(pressed){
                let xOffset = mouseX - lastX
                let yOffset = mouseY - lastY
                if (control.x + xOffset < control.x + control.width)
                    control.x += xOffset;
                if (control.width - xOffset > 0)
                    control.width-= xOffset;
            }
        }
    }

    //左上
    MouseArea {
        id:mouseLeftTop
        implicitWidth: 3
        implicitHeight: 3
        anchors.left: root.left
        anchors.top: root.top
        hoverEnabled: true
        enabled: (parent.direction & 9) == 9
        property int lastX: 0
        property int lastY: 0
        onContainsMouseChanged: {
            cursorShape = Qt.SizeFDiagCursor;
        }
        onPressed: {
            lastX = mouseX;
            lastY = mouseY;
        }
        onPositionChanged: {
            if(pressed){
                let xOffset = mouseX - lastX
                let yOffset = mouseY - lastY
                //不要简化这个判断条件，化简之后不容易看懂. Qml引擎会自动简化
                if (control.x + xOffset < control.x + control.width)
                    control.x += xOffset;
                if (control.y + yOffset < control.y + control.height)
                    control.y += yOffset;
                if (control.width - xOffset > 0)
                    control.width-= xOffset;
                if (control.height -yOffset > 0)
                    control.height -= yOffset;
            }
        }
    }

    //上
    MouseArea {
        implicitHeight: 3
        anchors.left: mouseLeftTop.right
        anchors.right: mouseRightTop.left
        anchors.top: root.top
        hoverEnabled: true
        enabled: (parent.direction & 1) == 1
        property int lastX: 0
        property int lastY: 0
        onContainsMouseChanged: {
            cursorShape = Qt.SizeVerCursor;
        }
        onPressed: {
            lastX = mouseX;
            lastY = mouseY;
        }
        onPositionChanged: {
            if(pressed){
                let xOffset = mouseX - lastX
                let yOffset = mouseY - lastY
                if (control.y + yOffset < control.y + control.height)
                    control.y += yOffset;
                if (control.height - yOffset > 0)
                    control.height -= yOffset;
            }
        }
    }
}
