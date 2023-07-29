import "components"

import QtQuick 2.0
import QtQuick.Layouts 1.2

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

SessionManagementScreen {

    property bool showUsernamePrompt: !showUserList

    property string lastUserName

    //the y position that should be ensured visible when the on screen keyboard is visible
    property int visibleBoundary: mapFromItem(loginButton, 0, 0).y
    //onHeightChanged: visibleBoundary = mapFromItem(loginButton, 0, 0).y + loginButton.height + units.smallSpacing

    signal loginRequest(string username, string password)

    onShowUsernamePromptChanged: {
        if (!showUsernamePrompt) {
            lastUserName = ""
        }
    }

    /*
    * Login has been requested with the following username and password
    * If username field is visible, it will be taken from that, otherwise from the "name" property of the currentIndex
    */
    function startLogin() {
        var username = showUsernamePrompt ? userNameInput.text : userList.selectedUser
        var password = passwordBox.text

        //this is partly because it looks nicer
        //but more importantly it works round a Qt bug that can trigger if the app is closed with a TextField focussed
        //DAVE REPORT THE FRICKING THING AND PUT A LINK
        loginButton.forceActiveFocus();
        loginRequest(username, password);
    }
    Rectangle{
        id: helperForm
        height: parent.height
        width: parent.width
        color: "transparent"
    }

    ColumnLayout {
        id: userAndPassword
        Layout.alignment: Qt.AlignHCenter
        spacing: 6
        width: helperForm.width

        PlasmaComponents.TextField {
            id: userNameInput
            Layout.fillWidth: true
            text: lastUserName
            visible: showUsernamePrompt
            focus: showUsernamePrompt && !lastUserName //if there's a username prompt it gets focus first, otherwise password does
            placeholderText: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Username")
            horizontalAlignment: TextInput.Center
            onAccepted: passwordBox.forceActiveFocus()
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout{
            id: passwordRow
            //            Layout.fillWidth: true
            width: parent.width
            Layout.alignment: Qt.AlignHCenter
            PlasmaComponents.TextField {
                id: passwordBox
                Layout.fillWidth: true
                //                width: Layout.width * 2
                placeholderText: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Password")
                focus: !showUsernamePrompt || lastUserName
                echoMode:  TextInput.Password
                revealPasswordButtonShown: false
                LayoutMirroring.enabled: true
                onAccepted: startLogin()
                textColor: config.colorFont
                Keys.onEscapePressed: {
                    mainStack.currentItem.forceActiveFocus();
                }

                //if empty and left or right is pressed change selection in user switch
                //this cannot be in keys.onLeftPressed as then it doesn't reach the password box
                Keys.onPressed: {
                    if (event.key == Qt.Key_Left && !text) {
                        userList.decrementCurrentIndex();
                        event.accepted = true
                    }
                    if (event.key == Qt.Key_Right && !text) {
                        userList.incrementCurrentIndex();
                        event.accepted = true
                    }
                }

                Connections {
                    target: sddm
                    onLoginFailed: {
                        passwordBox.selectAll()
                        passwordBox.forceActiveFocus()
                    }
                }

                style: TextFieldStyle {
                    background: Rectangle {
                        opacity: 0
                        radius: 1
                        color: config.colorFont
                    }
                }

            }
            Rectangle{
                width:  15
                height: 15
                border.width: 1
                border.color: config.colorPrimary
                color:  passwordBox.echoMode === TextInput.Normal ? config.colorPrimary: "transparent"
                opacity: passwordBox.text.length > 0 ? 1 : 0.6
                radius: width/2
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor;
                    onClicked: {
                        if(passwordBox.echoMode === TextInput.Password)
                            passwordBox.echoMode = TextInput.Normal
                        else
                            passwordBox.echoMode = TextInput.Password
                    }
                }
            }
        }
        Rectangle{
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            height: 1
            color: config.colorFont
        }
        Rectangle{
            Layout.alignment: Qt.AlignHCenter
            width:  helperForm.width -5
            Layout.fillWidth: true
            height: passwordRow.height*2
            color: "transparent"
            Rectangle{

                id: loginButton
                anchors.topMargin: units.gridUnit
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: passwordBox.height*1.5
                border.width: 1
                border.color: config.colorPrimary
                color: "transparent"
                opacity: 1

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    color: passwordBox.text.length > 0 ? config.colorPrimary : config.colorFont
                    text: passwordBox.text.length > 0 ? "unlock" : "lock"
                    font.pointSize: 20
                    font.family: newFont.name
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor;
                    onClicked: startLogin();
                }
            }
        }
    }
}
