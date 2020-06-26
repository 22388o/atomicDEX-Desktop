import QtQuick 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12

import "../Constants"

ColumnLayout {
    property alias title: title.text
    property alias text: text.text
    property alias value_color: text.color

    DefaultText {
        id: title
    }

    DefaultText {
        id: text
        color: Style.modalValueColor
    }
}
