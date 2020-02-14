import QtQuick 2.9
import QtQuick.Controls 2.0

import "." as ByteRubComponents

TextArea {
    id: textArea
    property bool themeTransition: true
    property string colorWhiteTheme: ""
    property string colorBlackTheme: ""
    color: ByteRubComponents.Style.defaultFontColor
    font.family: ByteRubComponents.Style.fontRegular.name
    font.pixelSize: 14
    selectByMouse: false
    wrapMode: Text.WordWrap;
    textMargin: 0
    leftPadding: 0
    topPadding: 0
    readOnly: true
    textFormat: TextEdit.PlainText

    states: [
        State {
            name: "black";
            when: textArea.themeTransition && ByteRubComponents.Style.blackTheme
            PropertyChanges {
                target: textArea
                color: {
                    return textArea.colorBlackTheme ? textArea.colorBlackTheme : ByteRubComponents.Style._b_defaultFontColor
                }
            }
        }, State {
            name: "white";
            when: textArea.themeTransition && !ByteRubComponents.Style.blackTheme
            PropertyChanges {
                target: textArea
                color: {
                    return textArea.colorWhiteTheme ? textArea.colorWhiteTheme : ByteRubComponents.Style._w_defaultFontColor
                }
            }
        }
    ]

    transitions: Transition {
        enabled: appWindow.themeTransition
        ColorAnimation { properties: "color"; easing.type: Easing.InOutQuad; duration: 750 }
    }
}
