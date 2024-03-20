import QtLocation 5.12


MapPolyline {
    id: idRoot
    path: idRoot.aircraftPath
    line.color: 'red'

    property var aircraftPath: []

    function reset() {
        idRoot.aircraftPath = []
    }

    function update(coordinate) {
        if (idRoot.aircraftPath.length > 750) {
            idRoot.aircraftPath.splice(0, 1)
        }

        idRoot.aircraftPath.push({
                             latitude: coordinate.latitude,
                             longitude: coordinate.longitude
                         })

        idRoot.aircraftPath = idRoot.aircraftPath
    }
}
