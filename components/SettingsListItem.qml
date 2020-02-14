import QtQuick 2.9
import QtQuick.Layouts 1.1

import "../components" as ByteRubComponents

ColumnLayout {
    property alias buttonText: button.text
    property alias description: description.text
    property alias title: title.text
    signal clicked()

    id: settingsListItem
    Layout.fillWidth: true
    spacing: 0

    Rectangle {
        // divider
        Layout.preferredHeight: 1
        Layout.fillWidth: true
        Layout.bottomMargin: 8
        color: ByteRubComponents.Style.dividerColor
        opacity: ByteRubComponents.Style.dividerOpacity
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 0

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 0

            ByteRubComponents.TextPlain {
                id: title
                Layout.fillWidth: true
                Layout.preferredHeight: 20
                Layout.topMargin: 8
                color: ByteRubComponents.Style.defaultFontColor
                opacity: ByteRubComponents.Style.blackTheme ? 1.0 : 0.8
                font.bold: true
                font.family: ByteRubComponents.Style.fontRegular.name
                font.pixelSize: 16
            }

            ByteRubComponents.TextPlainArea {
                id: description
                color: ByteRubComponents.Style.dimmedFontColor
                colorBlackTheme: ByteRubComponents.Style._b_dimmedFontColor
                colorWhiteTheme: ByteRubComponents.Style._w_dimmedFontColor
                Layout.fillWidth: true
                horizontalAlignment: TextInput.AlignLeft
            }
        }

        ByteRubComponents.StandardButton {
            id: button
            small: true
            onClicked: {
                settingsListItem.clicked()
            }
            width: 135
        }
    }
}
