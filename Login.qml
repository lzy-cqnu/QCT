import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects  // 为Qt6更新导入语句
import com.example.singletons
import com.example.global

ApplicationWindow {
    id: root
    visible: true
    width: 360
    height: 640
    title: "登录"
    color: "#f5f5f5"

    // 添加属性来接收参数
    property string email: ""
    property string password: ""

    // 定义常用颜色和样式
    readonly property color primaryColor: "#2196F3"
    readonly property color textColor: "#333333"
    readonly property int animationDuration: 200
    readonly property real defaultRadius: 8

    Rectangle {
        id: container
        width: parent.width * 0.9
        height: parent.height * 0.7
        anchors.centerIn: parent
        color: "white"
        radius: defaultRadius
        border.color: "#E0E0E0"
        border.width: 1

        ColumnLayout {
            anchors {
                fill: parent
                margins: 20
            }
            spacing: 20

            // Logo占位
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 80
                height: 80
                radius: width / 2
                color: primaryColor
                
                Image {
                    anchors.centerIn: parent
                    source: "qrc:/src/images/logo.png"
                    width: parent.width * 0.6
                    height: width
                    fillMode: Image.PreserveAspectFit
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "欢迎回来"
                font {
                    pixelSize: 24
                    weight: Font.Medium
                    family: "Microsoft YaHei"
                }
                color: textColor
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
                    border.color: emailField.activeFocus ? primaryColor : "transparent"
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
                        text: root.email  // 设置邮箱

                        validator: RegularExpressionValidator {
                            regularExpression: /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
                        }
                    }
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
                    border.color: passwordField.activeFocus ? primaryColor : "transparent"
                    border.width: 1

                    TextField {
                        id: passwordField
                        anchors.fill: parent
                        placeholderText: "请输入密码"
                        font.pixelSize: 16
                        color: textColor
                        background: null
                        leftPadding: 15
                        echoMode: TextField.Password
                        selectByMouse: true
                        text: root.password  // 设置密码
                    }
                }
            }

            // 登录按钮
            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 45
                text: "登录"
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
                    
                    // TODO: 实现登录逻辑
                    var loginData = {
                        "email": emailField.text,
                        "password": passwordField.text
                    }
                    HttpMgr.PostHttpReq("http://localhost:8080/login", 
                                      loginData, 
                                      Global.ReqId.Login,
                                      Global.Modules.LOGIN_MODULE)
                }
            }

            // 注册链接
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4

                Text {
                    text: "还没有账号？"
                    font.pixelSize: 14
                    color: "#666666"
                }

                Text {
                    text: "立即注册"
                    font.pixelSize: 14
                    color: primaryColor
                    font.underline: true

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            console.log("Attempting to load Main.qml...")
                            var component = Qt.createComponent("Main.qml")
                            console.log("Component status:", component.status)
                            
                            if (component.status === Component.Ready) {
                                console.log("Component is ready, creating object...")
                                var registerWindow = component.createObject(null)
                                root.close()
                            } else if (component.status === Component.Error) {
                                console.error("Error loading Main.qml:", component.errorString())
                                showToast("页面加载失败: " + component.errorString())
                            } else {
                                console.log("Component is loading, waiting for status change...")
                                component.statusChanged.connect(function() {
                                    console.log("Component status changed to:", component.status)
                                    if (component.status === Component.Ready) {
                                        console.log("Component is now ready, creating object...")
                                        var registerWindow = component.createObject(null)
                                        root.close()
                                    } else if (component.status === Component.Error) {
                                        console.error("Error loading Main.qml:", component.errorString())
                                        showToast("页面加载失败: " + component.errorString())
                                    }
                                })
                            }
                        }
                    }
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
        function onSig_http_finish(id, res, err, mod) {
            if (mod === Global.Modules.LOGIN_MODULE) {
                if (err === Global.ErrorCodes.NoError) {
                    showToast("登录成功")
                    // TODO: 跳转到主页面
                } else {
                    showToast("登录失败：" + res)
                }
            }
        }
    }
}
