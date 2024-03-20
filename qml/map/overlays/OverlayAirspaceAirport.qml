import QtLocation 5.12
import QtPositioning 5.12


MapItemView {
    delegate: MapCircle {
        center: QtPositioning.coordinate(model.latitude, model.longitude)
        radius: 5000
        opacity: 0.2
        color: 'red'
        border.width: 1
        border.color: 'black'

        // TODO: show model.name, model.id, model.iata and ...
    }
}
