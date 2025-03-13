import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Popup {
    id: root
    width: Math.min(toastText.implicitWidth + 48, parent.width * 0.8)  // 限制最大宽度
    height: 36
    x: (parent.width - width) / 2
    y: parent.height - height - 80
    margins: 0
    padding: 0
    
    background: Rectangle {
        color: "#333333"
        radius: 4  // 使用更小的圆角
        opacity: 0.9  // 添加一点透明度
        border.color: "#666666"
        border.width: 1
    }

    contentItem: RowLayout {
        spacing: 8
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16

        Text {
            id: toastText
            Layout.fillWidth: true
            color: "white"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight  // 文字过长时显示省略号
            wrapMode: Text.NoWrap
        }
    }

    // 添加显示和隐藏动画
    enter: Transition {
        NumberAnimation { 
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: 200
        }
    }
    
    exit: Transition {
        NumberAnimation { 
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: 200
        }
    }

    // 显示Toast提示的函数
    function show(message) {
        toastText.text = message
        open()
        toastTimer.restart()
    }

    // Toast自动关闭定时器
    Timer {
        id: toastTimer
        interval: 2000
        onTriggered: root.close()
    }
} 