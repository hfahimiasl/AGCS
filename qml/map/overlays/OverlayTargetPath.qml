import QtLocation 5.12


MapPolyline {
    id: idRoot
    line.color: '#61f312'

    function update(start, end) {
        idRoot.path = [
                    {
                        latitude: start.latitude,
                        longitude: start.longitude
                    },
                    {
                        latitude: end.latitude,
                        longitude: end.longitude
                    }
                ]
    }
}
