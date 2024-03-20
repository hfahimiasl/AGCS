import QtQuick 2.0


QtObject {
    property color background: '#eeeeee'
    property color backgroundLight: '#ffffff'
    property color backgroundDark: '#d6d6d8'
    property color primary: '#1eb980'
    property color primaryDark: '#045d56'
    property color orange: '#ff6859'
    property color yellow: '#ffcf44'
    property color purple: '#b15dff'
    property color blue: '#72deff'
    property color text: '#33333d'
    property color textDark: '#27272f'

    function setTheme(type) {
        if (type === 'LIGHT') {
            background = '#eeeeee'
            backgroundLight = '#ffffff'
            backgroundDark = '#d6d6d8'
            primary = '#1eb980'
            primaryDark = '#045d56'
            orange = '#ff6859'
            yellow = '#ffcf44'
            purple = '#b15dff'
            blue = '#72deff'
            text = '#33333d'
            textDark = '#27272f'

        } else if (type === 'DARK') {
            background = '#33333d'
            backgroundLight = '#373740'
            backgroundDark = '#27272f'
            primary = '#1eb980'
            primaryDark = '#045d56'
            orange = '#ff6859'
            yellow = '#ffcf44'
            purple = '#b15dff'
            blue = '#72deff'
            text = '#ffffff'
            textDark = '#9f9fa3'
        }
    }
}
