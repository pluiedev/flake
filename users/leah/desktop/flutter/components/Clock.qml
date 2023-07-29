/*
 *   Copyright 2016 David Edmundson <davidedmundson@kde.org>
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

import QtQuick 2.0
import QtQuick.Layouts 1.1

//import org.kde.plasma.core 2.0
import org.kde.plasma.components 2.0
import QtGraphicalEffects 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

Rectangle {

    width: parent.width*0.5
    height: parent.height
    x: parent.width*0.5
    color: "transparent"
    Label {
        id: label_mm
        text: Qt.formatTime(timeSource.data["Local"]["DateTime"])
        font.pointSize: 60
        renderType: Text.QtRendering
        anchors.top: parent.top
        anchors.right : parent.right
        anchors.rightMargin: units.gridUnit *4
        anchors.topMargin: units.gridUnit *4
        font.family: newFont.name
        color: config.colorFontSecondary
    }
    Label {
        id : label_sub
        text: Qt.formatDate(timeSource.data["Local"]["DateTime"], "ddd d MMM")
        font.pointSize: 40
        anchors.top: label_mm.bottom
        anchors.right : parent.right
        anchors.rightMargin: units.gridUnit *4
        font.family: newFont.name
        color: config.colorFontSecondary
    }

    PlasmaCore.DataSource {
        id: timeSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 1000
    }
    Row{
        anchors{
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: units.gridUnit
        }
        spacing: units.gridUnit *5


        PlasmaCore.IconItem {
            id: buttonIcon
            implicitHeight: 22
            width:  implicitHeight
            source: Qt.resolvedUrl("artwork/images/grid.svg")
            smooth: true
        }


        PlasmaCore.IconItem {
            id: buttonIcon2
            implicitHeight: 22
            width:  implicitHeight
            source:Qt.resolvedUrl("artwork/images/desktop.svg");
            smooth: true
        }

        PlasmaCore.IconItem {
            id: buttonIcon3
            implicitHeight: 22
            width:  implicitHeight
            source: Qt.resolvedUrl("artwork/images/expose.svg");
            smooth: true
        }
    }
}
