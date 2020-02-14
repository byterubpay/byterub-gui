import QtQuick 2.9

import "../components" as ByteRubComponents

TextEdit {
    color: ByteRubComponents.Style.defaultFontColor
    font.family: ByteRubComponents.Style.fontRegular.name
    selectionColor: ByteRubComponents.Style.textSelectionColor
    wrapMode: Text.Wrap
    readOnly: true
    selectByMouse: true
    // Workaround for https://bugreports.qt.io/browse/QTBUG-50587
    onFocusChanged: {
        if(focus === false)
            deselect()
    }
}
