import QtQuick 2.9

import "." as ByteRubComponents
import "effects/" as ByteRubEffects

Rectangle {
    color: ByteRubComponents.Style.appWindowBorderColor
    height: 1

    ByteRubEffects.ColorTransition {
        targetObj: parent
        blackColor: ByteRubComponents.Style._b_appWindowBorderColor
        whiteColor: ByteRubComponents.Style._w_appWindowBorderColor
    }
}
