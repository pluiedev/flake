/*
 *   Copyright 2014 David Edmundson <davidedmundson@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.2
import QtQuick.Controls 2.0

//ListView {

ComboBox {
    id: view
    readonly property string selectedUser: currentIndex != -1 ? view.currentText : ""
    readonly property int userItemWidth:  view.width
    readonly property int userItemHeight: view.height
    activeFocusOnTab : true
    /*
     * Signals that a user was explicitly selected
     */
    signal userSelected;

    textRole: "name"
    font.capitalization: Font.Capitalize

    delegate: UserDelegate {
        avatarPath: model.icon || ""
        iconSource: model.iconName || "user-identity"
        name: {
            var displayName = model.realName || model.name

            if (model.vtNumber === undefined || model.vtNumber < 0) {
                return displayName
            }
            if (!model.session) {
                return i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "Nobody logged in on that session", "Unused")
            }
            var location = ""
            if (model.isTty) {
                location = i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "User logged in on console number", "TTY %1", model.vtNumber)
            } else if (model.displayNumber) {
                location = i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "User logged in on console (X display number)", "on TTY %1 (Display %2)", model.vtNumber, model.displayNumber)
            }

            if (location) {
                return i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "Username (location)", "%1 (%2)", displayName, location)
            }

            return displayName
        }

        userName: { return model.name}
        width:  userItemWidth
        height: userItemHeight
        isCurrent: view.currentIndex == index

        onClicked: {
            view.currentIndex = index
            view.userSelected()
            view.popup.close()
        }

    }
    popup: Popup {
        width: view.width < 200 ? 200 :view.width
        implicitHeight: contentItem.implicitHeight
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: view.popup.visible ? view.delegateModel : null
            currentIndex: view.highlightedIndex
            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            border.color: config.colorSecondary
            border.width: 1
            radius: 4
            color: config.colorMenu
        }
        enter: Transition {
            NumberAnimation { property: "scale"; from: 0.9; to: 1; duration: 200; easing {type: Easing.OutBack; overshoot: 10}}
        }
    }
    Keys.onEscapePressed: view.userSelected()
    Keys.onEnterPressed: view.userSelected()
    Keys.onReturnPressed: view.userSelected()
}
