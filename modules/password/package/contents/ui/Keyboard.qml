/*
 * Copyright 2021 Wang Rui <wangrui@jingos.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.10 as QQC2

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kcm 1.2

Item{
    id:passwordVerify

    property bool isErrorShow : false
    property bool isagain : false
    property string  password
    property string  passwordagain
    property int currentIndex : 0
    property bool clickable: isagain ? passwordagain.length < 6 ? false : true 
                                                    : password.length < 6 ? false : true 
    Item{
        id:title

        anchors.top:parent.top

        Image {
            id:backLabel

            anchors {
                top: parent.top
                left: parent.left
                topMargin: 48 * appScale
                leftMargin: 14 * appScale
            }

            sourceSize.width: 22 * appScale
            sourceSize.height: 22 * appScale

            visible:passwordVerify.visible
            source: "../image/arrow_left.png"

            MouseArea {
                anchors.fill:parent

                onClicked:{
                    popView()
                }
            }
        }

        Kirigami.Label {
            anchors {
                top: parent.top
                left: backLabel.right
                topMargin: 48 * appScale
                leftMargin: 10 * appScale
            }

            height: 20 * appScale
            font.bold: true
            text: i18n("Simple Password")
            font.pixelSize: 20
        }
    }

    Item {
        id:topPart

        anchors.top: title.bottom
        anchors.left:parent.left
        anchors.right:parent.right
        anchors.topMargin: 122 * appScale
        anchors.rightMargin: 12

        width: mWidth
        height: 80 * appScale

        ColumnLayout {

            
            anchors.horizontalCenter: parent.horizontalCenter
            
            Layout.preferredHeight: topPart.height

            Kirigami.Label {
                id:tipLabel
                anchors{
                    top:parent.top
                    horizontalCenter:parent.horizontalCenter
                }

                text: !isagain ? i18n("Enter your new password") : i18n("Verify your new password")
                font.pointSize: defaultFontSize
                font.pixelSize: 14
            }

            Grid {
                id:inputGrid
                anchors{
                    top:tipLabel.top
                    horizontalCenter:parent.horizontalCenter
                    topMargin:40 * appScale
                }

                columns: 6
                rows: 1
                spacing: 13 * appScale

                Repeater {
                    id:inputRepater

                    model: passwordInput

                    delegate: Rectangle{
                        width: appScale * 11
                        height: appScale * 11

                        radius: height / 2
                        color: index < currentIndex ? "#FF3C4BE8" :"#266B6B8A"
                    }
                }
            }

            Kirigami.Label {
                id:pinWarning
                
                anchors{
                    top: inputGrid.bottom
                    horizontalCenter:parent.horizontalCenter
                    topMargin: 8 * appScale
                }

                width: 200 * appScale
                visible: isErrorShow
                wrapMode: Text.WordWrap
                text: i18n("Password did not match, please try again")
                color: "#FFE95B4E"
                font.pixelSize: 14
            }

        }

    }

    Item {
        id:bottomPart

        anchors {
            top: topPart.bottom
            left:parent.left
            right:parent.right
            bottom: passwordVerify.bottom
            rightMargin: 12
        }

        width: mWidth

        Grid {
            
            anchors.centerIn: parent
            
            columns: 3
            rows: 4
            spacing: 17 * appScale

            Repeater {
                model: numberModel

                delegate: Rectangle {
                    width: 54 * appScale
                    height: 54 * appScale

                    color:  index == 9 | index == 11 ? "transparent" : "#266B6B8A"
                    radius: 16 * appScale

                    Kirigami.Label {
                        anchors.centerIn: parent

                        text: model.display
                        font.pixelSize: 23
                    }

                    Image{
                        id:img_confirm

                        anchors.centerIn:parent

                        width:30 * appScale
                        height:30 * appScale

                        //opacity: clickable ? 1 : 0.18
                        visible:index == 11
                        source: clickable ? "../image/icon_confirm.png" : "../image/icon_not_confirm.png"
                    }

                    Image{
                        anchors.centerIn:parent

                        width:30 * appScale
                        height:30 * appScale

                        visible:index == 9
                        source:"../image/key_back.png"
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            if(model.value === -1) {
                                if (currentIndex <= 0) {
                                    return;
                                }
                                currentIndex --
                                if (isagain) {
                                    passwordagain = passwordagain.substr(0, passwordagain.length - 1)
                                } else {
                                    password = password.substr(0, password.length - 1)
                                }
                            } else  if (model.value === -2){

                                if(!clickable){
                                    return;
                                }

                                if (isagain) {
                                    checkPassword()
                                } else {
                                    currentIndex = 0
                                    isagain = true
                                }
                            } else {

                                if(isErrorShow) {
                                    isErrorShow  = false
                                }
                                if(!isagain && password.length > 5){
                                    return;
                                }
                                
                                if(isagain && passwordagain.length > 5){
                                    return;
                                }

                                if(isagain) {
                                    passwordagain = passwordagain + model.value
                                } else {
                                    password = password + model.value
                                }

                                currentIndex ++;

                                /*if(currentIndex == 5) {
                                     currentIndex = 0
                                    if(isagain) {
                                        passwordagain = passwordagain + model.value
                                        checkPassword()

                                    } else {
                                        password = password + model.value
                                        isagain = true
                                    }
                                } else {
                                    if(isErrorShow) {
                                        isErrorShow  = false
                                    }
                                    if(isagain) {
                                        passwordagain = passwordagain + model.value
                                    } else {
                                        password = password + model.value
                                    }
                                    currentIndex ++;
                                }*/
                            }
                        }
                    }
                }
            }
        }
    }

    function clearPassWordInput() {
        for(var i = 0 ; i < passwordInput.count ; i ++) {
            passwordInput.get(i).value = -1;
        }
    }

    function checkPassword() {
         console.log("checkPassword: "+password+" "+passwordagain)
        if(password == passwordagain) {
            popView()
            kcm.setPassword(password,"simple")
        } else {
            isErrorShow = true
        }
        currentIndex = 0
        password = ""
        passwordagain = ""
        isagain = false
    }

    function getPasswordText() {
        var text = "";
        for(var i = 0 ; i < passwordInput.count ; i ++){
            text += passwordInput.get(i).value;
        }
        return text;
    }

    ListModel {
        id:passwordInput

        ListElement{value:-1}
        ListElement{value:-1}
        ListElement{value:-1}
        ListElement{value:-1}
        ListElement{value:-1}
        ListElement{value:-1}
    }

    ListModel {
        id:numberModel

        ListElement{display:"1";value:1}
        ListElement{display:"2";value:2}
        ListElement{display:"3";value:3}
        ListElement{display:"4";value:4}
        ListElement{display:"5";value:5}
        ListElement{display:"6";value:6}
        ListElement{display:"7";value:7}
        ListElement{display:"8";value:8}
        ListElement{display:"9";value:9}
        ListElement{display:"";value:-1}
        ListElement{display:"0";value:0}
        ListElement{display:"";value:-2}
    }

    RegExpValidator {
        id: pinValidator

        regExp: /[0-9]+/
    }

    Keys.onPressed: {
        if(event.key >= Qt.Key_0 && event.key <= Qt.Key_9) {
            if(isErrorShow) {
                isErrorShow  = false
            }
            if(!isagain && password.length > 5){
                return;
            }
            
            if(isagain && passwordagain.length > 5){
                return;
            }

            currentIndex ++
            if(isagain) {
                passwordagain += event.key - 48
            } else {
                password += event.key - 48
            }
        } 
        if(event.key === Qt.Key_Backspace) {
            if(currentIndex > 0) {
                currentIndex --
            }
            if(isagain) {
                passwordagain = passwordagain.substr(0, passwordagain.length - 1);
            } else {
                password = password.substr(0, password.length - 1);
            }
        }
        if(event.key === Qt.Key_Return) {
            
            if(!clickable){
                return;
            }

            if (isagain) {
                checkPassword()
            } else {
                currentIndex = 0
                isagain = true
            }

            passwordVerify.focus = true     
            passwordVerify.forceActiveFocus()
        }
        event.accepted = true
    }

    Component.onCompleted: {   
        passwordVerify.focus = true     
        passwordVerify.forceActiveFocus()
    }
}
