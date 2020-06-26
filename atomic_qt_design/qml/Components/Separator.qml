import QtQuick 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12

import QtGraphicalEffects 1.0
import "../Constants"

Item {
    height: 1
    width: 150

    // Gradient
    LinearGradient {
        anchors.fill: parent
        start: Qt.point(0, 0)
        end: Qt.point(parent.width, 0)
        gradient: Gradient {
            GradientStop { position: 0.0; color: Style.colorGradientLine1 }
            GradientStop { position: 0.5; color: Style.colorGradientLine2 }
            GradientStop { position: 1.0; color: Style.colorGradientLine1 }
        }
    }
}
