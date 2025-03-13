import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import com.example.singletons
import com.example.global

ApplicationWindow {
    id: root
    visible: true
    width: 360
    height: 640
    title: "注册"
    color: "transparent"  // 设置窗口背景为透明
    flags: Qt.Window | Qt.FramelessWindowHint  // 无边框模式

    // 添加窗口拖动功能
    MouseArea {
        anchors.fill: parent
        property point clickPos: "1,1"
        
        onPressed: {
            clickPos = Qt.point(mouse.x, mouse.y)
        }
        
        onPositionChanged: {
            var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
            root.x += delta.x
            root.y += delta.y
        }
    }

    // 定义常用颜色和样式
    readonly property color primaryColor: "#2196F3"
    readonly property color textColor: "#333333"
    readonly property int animationDuration: 200
    readonly property real defaultRadius: 8

    // 验证码倒计时
    property int countdown: 0
    Timer {
        id: countdownTimer
        interval: 1000
        repeat: true
        onTriggered: {
            if (countdown > 0) {
                countdown--
            } else {
                stop()
                verifyCodeBtn.enabled = true
            }
        }
    }

    // 主容器（作为窗口主体）
    Rectangle {
        id: container
        anchors.fill: parent  // 填充整个窗口
        color: "white"
        radius: 10  // 窗口圆角

        // 添加阴影效果
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            color: "#80000000"
            radius: 10
            samples: 20
            horizontalOffset: 0
            verticalOffset: 0
        }

        // 内容区域
        ColumnLayout {
            anchors {
                fill: parent
                margins: 20
            }
            spacing: 16

            // 标题栏（可拖动区域）
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                MouseArea {
                    Layout.fillWidth: true
                    height: 32
                    property point clickPos: "1,1"
                    
                    onPressed: {
                        clickPos = Qt.point(mouse.x, mouse.y)
                    }
                    
                    onPositionChanged: {
                        var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                        root.x += delta.x
                        root.y += delta.y
                    }

                    RowLayout {
                        anchors.fill: parent
                        spacing: 8

                        // 返回按钮
                        Rectangle {
                            width: 32
                            height: 32
                            radius: width / 2
                            color: "#f5f5f5"
                            
                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/src/images/back.png"
                                width: 20
                                height: 20
                                fillMode: Image.PreserveAspectFit
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    var component = Qt.createComponent("Login.qml")
                                    if (component.status === Component.Ready) {
                                        var loginWindow = component.createObject(null)
                                        root.close()
                                    }
                                }
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            text: "注册账号"
                            font {
                                pixelSize: 20
                                weight: Font.Medium
                                family: "Microsoft YaHei"
                            }
                            color: textColor
                        }
                    }
                }
            }

            // 邮箱输入
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: "邮箱地址"
                    font.pixelSize: 14
                    color: "#666666"
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 45
                    radius: defaultRadius
                    color: "#f5f5f5"
                    // 修改边框颜色逻辑
                    border.color: {
                        if (emailField.text.length === 0) return "transparent"
                        if (emailField.activeFocus) return primaryColor
                        return emailField.acceptableInput ? "transparent" : "#FF0000"
                    }
                    border.width: 1

                    TextField {
                        id: emailField
                        anchors.fill: parent
                        placeholderText: "请输入邮箱地址"
                        font.pixelSize: 16
                        color: textColor
                        background: null
                        leftPadding: 15
                        selectByMouse: true

                        validator: RegularExpressionValidator {
                            regularExpression: /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
                        }
                    }
                }

                // 添加邮箱错误提示
                Text {
                    text: "请输入正确的邮箱格式"
                    color: "#FF0000"
                    font.pixelSize: 12
                    visible: emailField.text.length > 0 && !emailField.acceptableInput
                }
            }

            // 密码输入
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: "密码"
                    font.pixelSize: 14
                    color: "#666666"
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 45
                    radius: defaultRadius
                    color: "#f5f5f5"
                    // 修改边框颜色逻辑
                    border.color: {
                        if (passwordField.text.length === 0) return "transparent"
                        if (passwordField.activeFocus) return primaryColor
                        return passwordField.text.length >= 8 ? "transparent" : "#FF0000"
                    }
                    border.width: 1

                    TextField {
                        id: passwordField
                        anchors.fill: parent
                        placeholderText: "请输入密码（至少8位）"
                        font.pixelSize: 16
                        color: textColor
                        background: null
                        leftPadding: 15
                        echoMode: TextField.Password
                        selectByMouse: true

                        validator: RegularExpressionValidator {
                            regularExpression: /.{8,}/
                        }
                    }
                }

                // 添加密码长度错误提示
                Text {
                    text: "密码长度不能少于8位"
                    color: "#FF0000"
                    font.pixelSize: 12
                    visible: passwordField.text.length > 0 && passwordField.text.length < 8
                }
            }

            // 确认密码
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: "确认密码"
                    font.pixelSize: 14
                    color: "#666666"
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 45
                    radius: defaultRadius
                    color: "#f5f5f5"
                    // 修改边框颜色逻辑
                    border.color: {
                        if (confirmPasswordField.text.length === 0) return "transparent"
                        if (confirmPasswordField.activeFocus) return primaryColor
                        return passwordField.text === confirmPasswordField.text ? "transparent" : "#FF0000"
                    }
                    border.width: 1

                    TextField {
                        id: confirmPasswordField
                        anchors.fill: parent
                        placeholderText: "请再次输入密码"
                        font.pixelSize: 16
                        color: textColor
                        background: null
                        leftPadding: 15
                        echoMode: TextField.Password
                        selectByMouse: true
                    }
                }

                Text {
                    id: passwordError
                    text: "两次输入的密码不一致"
                    color: "#FF0000"
                    font.pixelSize: 12
                    visible: confirmPasswordField.text.length > 0 &&
                            passwordField.text !== confirmPasswordField.text
                }
            }

            // 验证码输入区域
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: "验证码"
                    font.pixelSize: 14
                    color: "#666666"
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                        Layout.fillWidth: true
                        height: 45
                        radius: defaultRadius
                        color: "#f5f5f5"
                        border.color: verifyCodeField.activeFocus ? primaryColor : "transparent"
                        border.width: 1

                        TextField {
                            id: verifyCodeField
                            anchors.fill: parent
                            placeholderText: "请输入验证码"
                            font.pixelSize: 16
                            color: textColor
                            background: null
                            leftPadding: 15
                            selectByMouse: true
                            validator: RegularExpressionValidator {
                                regularExpression: /^\d{6}$/
                            }
                        }
                    }

                    Button {
                        id: verifyCodeBtn
                        Layout.preferredWidth: 120
                        Layout.preferredHeight: 45
                        // 修改启用条件：邮箱格式正确 且 密码符合要求 且 两次密码一致 且 不在倒计时中
                        enabled: emailField.acceptableInput &&
                                passwordField.acceptableInput &&
                                passwordField.text === confirmPasswordField.text &&
                                passwordField.text.length >= 8 &&
                                countdown === 0

                        contentItem: Text {
                            text: countdown > 0 ? `重新发送(${countdown}s)` : "获取验证码"
                            font.pixelSize: 14
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        background: Rectangle {
                            radius: defaultRadius
                            color: parent.enabled ? (parent.pressed ? Qt.darker(primaryColor, 1.1) : primaryColor) : "#CCCCCC"

                            Behavior on color {
                                ColorAnimation {
                                    duration: animationDuration
                                }
                            }
                        }

                        onClicked: {
                            if (enabled) {
                                var json_obj = {}
                                json_obj["email"] = emailField.text
                                HttpMgr.PostHttpReq(
                                    "http://192.168.56.101:8080/get_varifycode",
                                    json_obj,
                                    Global.ID_GET_VARIFY_CODE,
                                    Global.REGISTERMOD
                                )
                                countdown = 60
                                countdownTimer.start()
                            }
                        }
                    }
                }
            }

            // 注册按钮
            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 45
                text: "注册"
                font {
                    pixelSize: 16
                    weight: Font.Medium
                }

                background: Rectangle {
                    radius: defaultRadius
                    color: parent.pressed ? Qt.darker(primaryColor, 1.1) : primaryColor

                    Behavior on color {
                        ColorAnimation {
                            duration: animationDuration
                        }
                    }
                }

                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    if (!emailField.acceptableInput) {
                        showToast("请输入正确的邮箱格式")
                        return
                    }
                    if (passwordField.text.length < 8) {
                        showToast("密码长度不能少于8位")
                        return
                    }
                    if (passwordField.text !== confirmPasswordField.text) {
                        showToast("两次输入的密码不一致")
                        return
                    }
                    if (!verifyCodeField.acceptableInput) {
                        showToast("请输入正确的验证码")
                        return
                    }

                    var registerData = {
                        "email": emailField.text,
                        "password": passwordField.text,
                        "verify_code": verifyCodeField.text
                    }
                    HttpMgr.PostHttpReq("http://localhost:8080/register", 
                                      registerData, 
                                      Global.ReqId.ID_REG_USER,
                                      Global.Modules.REGISTERMOD)
                }
            }

            // 登录链接和返回按钮
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4

                Text {
                    text: "已有账号？"
                    font.pixelSize: 14
                    color: "#666666"
                }

                Text {
                    text: "立即登录"
                    font.pixelSize: 14
                    color: primaryColor
                    font.underline: true

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            var component = Qt.createComponent("Login.qml")
                            if (component.status === Component.Ready) {
                                var loginWindow = component.createObject(null, {
                                    "email": emailField.text,
                                    "password": passwordField.text
                                })
                                root.close()
                            }
                        }
                    }
                }

                Text {
                    text: "|"
                    font.pixelSize: 14
                    color: "#CCCCCC"
                }


            }
        }
    }

    // 替换旧的Toast实现
    Toast {
        id: toast
    }

    // 修改showToast函数
    function showToast(message) {
        toast.show(message)
    }

    // 监听HTTP请求完成信号
    Connections {
        target: HttpMgr
        function onSig_reg_mod_finish(id, res, err) {
            if (err === Global.ErrorCodes.NoError) {
                showToast("注册成功")
                // 注册成功后跳转到登录页面
                var component = Qt.createComponent("Login.qml")
                if (component.status === Component.Ready) {
                    var loginWindow = component.createObject(null)
                    root.close()
                }
            } else {
                showToast("注册失败：" + res)
            }
        }
    }
}
