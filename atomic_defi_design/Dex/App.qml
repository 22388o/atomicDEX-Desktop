import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import Qt.labs.platform 1.0

import Qaterial 1.0 as Qaterial

import "Screens"
import "Constants"
import "Components"
import "Dashboard"
import App 1.0
import Dex.Themes 1.0 as Dex
import "Screens/Startup" as Startup

DexRectangle
{
    id: app

    // This enumeration represents every possible visual state (commonly named "screen") of the application
    enum ScreenType
    {
        Startup,    // Wallets selection, login, create wallet, import wallet, etc.
        Dashboard   // After logged to a wallet.
    }

    property string         currentWalletName: API.app.wallet_mgr.wallet_default_name
    property bool           debug: debug_bar
    property var            notification_modal: notifications_modal
    property var            notifications_list: _currentPage === App.ScreenType.Dashboard ? loader.item.notifications_list : []
    property bool           segwit_on: false

    property var            _currentPage: App.ScreenType.Startup
    property var            _availablePages: [ _startup, dashboard ]

    property alias globalGradient: globalGradient

    // Preload Chart
    signal pairChanged(string base, string rel)


    function onDisconnect()
    {
        app.notifications_list = [];
        API.app.wallet_mgr.set_log_status(false);
        _currentPage = App.ScreenType.Startup;
    }

    Shortcut
    {
        sequence: "F11"
        onActivated: window.showNormal()
    }

    Component
    {
        id: no_connection

        NoConnection {}
    }

    NotificationsModal { id: notifications_modal }

    Component
    {
        id: _startup
        Startup.Main
        {
            _selectedWalletName: currentWalletName
            onLogged:
            {
                currentWalletName = walletName;
                _currentPage = App.ScreenType.Dashboard;
                window.logged = true
            }
        }
    }

    Component
    {
        id: dashboard

        Dashboard {}
    }

    Component
    {
        id: dialogManager
        DexDialogManager { }
    }

    Loader
    {
        id: loader
        anchors.fill: parent
        sourceComponent:
        {
            if (!API.app.internet_checker.internet_reacheable)
                return no_connection

            return _availablePages[_currentPage]
        }
    }

    // Error Modal
    ModalLoader
    {
        id: error_log_modal
        sourceComponent: LogModal {}
    }

    function showError(title, content)
    {
        if (content === undefined || content === null) return
        error_log_modal.open()
        error_log_modal.item.header = title
        error_log_modal.item.field.text = content
    }

    // Toast
    ToastManager { id: toast }

    // Update Modal
    NewUpdateModal
    {
        id: new_update_modal
        visible: false
    }

    UpdateInvalidChecksum
    {
        id: update_invalid_checksum
        visible: false
    }

    // Fatal Error Modal
    FatalErrorModal
    {
        id: fatal_error_modal
        visible: false
    }

    // Recover funds result modal
    LogModal
    {
        id: recoverFundsResultModal

        visible: false

        header: qsTr("Recover Funds Result")

        onClosed: field.text = "{}"

        Connections // Catches signals from orders_model.
        {
            target: API.app.orders_mdl

            function onRecoverFundDataChanged()
            {
                if (!API.app.orders_mdl.recover_fund_busy)
                {
                    recoverFundsResultModal.field.text = General.prettifyJSON(API.app.orders_mdl.recover_fund_data)
                    recoverFundsResultModal.open()
                }
            }
        }
    }

    Item
    {
        id: debug_control

        property var splitViewState

        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 110
        height: 20
        visible: app.debug

        Menu
        {
            id: contextMenu
            Action
            {
                text: "Display Normal"
                onTriggered:
                {
                    treeView.parent.visible = true
                    _statusView.visible = true
                    flow.parent.parent.visible = true
                    app.parent.width = app.parent.parent.width - treeView.width
                    app.parent.height = app.parent.parent.height
                    app.parent.parent.update()
                }
            }
            Action
            {
                text: "Show Full"
                onTriggered:
                {
                    app.parent.width = app.parent.parent.width - treeView.width
                    app.parent.height = app.parent.parent.height
                    treeView.parent.visible = false
                    _statusView.visible = false
                    flow.parent.parent.visible = false
                }
            }
            Action
            {
                text: "Show Minimum"
                onTriggered:
                {
                    app.parent.width = General.minimumWidth
                    app.parent.height = General.minimumHeight

                }
            }
            Action
            {
                text: "Show FullScreen"
                onTriggered: { window.showFullScreen(); }
            }
            Action
            {
                text: "Clean Cache"
                onTriggered: _statusView.children[0].contentItem.children[0].clear()
            }
        }

        Rectangle
        {
            width: parent.width
            radius: 1
            height: 20
            color: Qaterial.Colors.blueGray600
        }

        Row
        {
            anchors.centerIn: parent
            spacing: 10
            anchors.bottomMargin: 5
            DefaultText
            {
                text: "%1x%2".arg(app.width).arg(app.height)
                color: 'white'
                font.pixelSize: 13
                layer.enabled: true
                DropShadow { color: 'black' }
            }
            Qaterial.ColorIcon
            {
                source: Qaterial.Icons.tools
                iconSize: 12
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        DefaultMouseArea
        {
            anchors.fill: parent
            onClicked: contextMenu.open()
        }
    }         

    Component
    {
        id: alertComponent
        Popup
        {
            id: alertPopup
            property color backgroundColor: Qaterial.Colors.orange200
            property color foregroundColor: Qaterial.Colors.gray900
            property string title: "Test Title"
            property string subTitle: "Lorem ipsum dolor sit amet, consectetur adipis"
            property string icon: Qaterial.Icons.checkCircleOutline
            property real iconSize: 50
            property real timeout: 3000
            x:  parent.width - width - 40
            y: 40
            width: 300
            height: col.height + 25
            function show(data) {
                if ("backgroundColor" in data) {
                    alertPopup.backgroundColor = data.backgroundColor
                }

                if ("foregroundColor" in data) {
                    alertPopup.foregroundColor = data.foregroundColor
                }

                if ("title" in data) {
                    alertPopup.title = data.title
                }

                if ("subTitle" in data) {
                    alertPopup.subTitle = data.subTitle
                }

                if ("icon" in data) {
                    alertPopup.icon = data.icon
                }

                if ("timeout" in data) {
                    alertPopup.timeout = data.timeout
                }
                alertPopup.open()
                insideRect.width = 0
                alertTimer.restart()
            }

            background: Qaterial.ClipRRect
            {
                radius: 4
                DefaultRectangle
                {
                    anchors.fill: parent
                    color: alertPopup.backgroundColor
                    DefaultRectangle
                    {
                        id: insideRect
                        width: parent.width
                        height: 8
                        radius: 0
                        opacity: .5
                        color: Qt.lighter(alertPopup.backgroundColor)
                        border.width: 0
                        Behavior on width
                        {
                            NumberAnimation
                            {
                                duration: alertPopup.timeout
                            }
                        }
                    }
                }
            }
            Timer
            {
                id: alertTimer
                interval: alertPopup.timeout
                running: areaAlert.containsMouse ? false : true
                onTriggered: alertPopup.close()
            }

            RowLayout
            {
                anchors.fill: parent
                Item
                {
                    Layout.fillHeight: true 
                    width: 60
                    Qaterial.Icon
                    {
                        icon: alertPopup.icon
                        size: alertPopup.iconSize
                        anchors.centerIn: parent
                        color: alertPopup.foregroundColor
                    }
                }
                Item
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Column
                    {
                        id: col
                        width: parent.width 
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 6
                        DexLabel
                        {
                            text: alertPopup.title
                            color: alertPopup.foregroundColor
                            font: DexTypo.head6
                        }

                        DexLabel
                        {
                            text: alertPopup.subTitle
                            color: alertPopup.foregroundColor
                            font: DexTypo.subtitle1
                            wrapMode: DexLabel.Wrap
                            width: parent.width - 10
                            opacity: .6
                        }
                    }
                }
            }
            DexMouseArea
            {
                id: areaAlert
                hoverEnabled: true
                anchors.fill: parent
                onClicked: alertPopup.close()
            }
        }
    }

    function notifyCopy(title, subTitle)
    {
        app.notify({
            title: title,
            subTitle: subTitle,
            backgroundColor: Qaterial.Colors.gray400,
            foregroundColor: Qaterial.Colors.gray900,
            icon: Qaterial.Icons.contentCopy,
            iconSize: 35
        });
    }

    function notify(data)
    {
        let c = alertComponent.createObject(window);
        c.show(data);
    }

    Settings
    {
        id: atomic_settings2
        fileName: atomic_cfg_file
    }

    QtObject
    {
        id: _font
        property real fontDensity: DexTypo.fontDensity
        property string fontFamily:  DexTypo.fontFamily
    }

    Settings
    {
        id: ui_font_settings
        property alias fontDensity: _font.fontDensity
        property alias fontFamily: _font.fontFamily
    }

    function loadTheme()
    {
        atomic_settings2.sync();
        let current = atomic_settings2.value("CurrentTheme");
        Dex.CurrentTheme.loadFromFilesystem(current);
    }

    function showDialog(data)
    {
        let dialog = dialogManager.createObject(window, data)
        for (var i in data)
        {
            if(i.startsWith('on')) eval('dialog.%1.connect(data[i])'.arg(i));
        }
        dialog.open()
        return dialog
    }

    function showText(data) { return showDialog(data); }

    function getText(data)
    {
        data['getText'] = true;
        return showText(data);
    }

    Component.onCompleted: loadTheme()

    Timer
    {
        interval: 5000
        repeat: true
        running: false
        onTriggered: loadTheme()
    }

    Gradient
    {
        id: globalGradient
        GradientStop
        {
            position: .80
            color: DexTheme.contentColorTop
        }
        GradientStop
        {
            position: 1
            color: 'transparent'
        }
    }

    Shortcut
    {
        sequence: "Ctrl+R"
        onActivated: loadTheme()
    }

    color: DexTheme.surfaceColor
    radius: 0
    border.width: 0
    border.color: 'transparent'
}