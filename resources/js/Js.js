function map(x, in1, in2, out1, out2) {
    let min = in1 < in2 ? in1 : in2;
    let max = in1 > in2 ? in1 : in2;
    x = x < min ? min : (x > max ? max : x);
    let maped = (x - in1) * (out2 - out1) / (in2 - in1) + out1;
    return maped;
}

function decimalFormatter(value, decimal) {
    return ((value * (10 ** decimal)) | 0) / (10 ** decimal);
}

function geometryDistance(lat1, lon1, lat2, lon2) {
    // Earth radius in meters
    let Re = 6371000;
    let lat = [lat1 * Math.PI / 180, lat2 * Math.PI / 180];
    let lon = [lon1 * Math.PI / 180, lon2 * Math.PI / 180];
    return Math.asin(Math.sqrt(Math.pow(Math.sin((lat[1] - lat[0]) / 2), 2) + Math.cos(lat[0]) * Math.cos(lat[1]) * Math.pow(Math.sin((lon[1] - lon[0]) / 2), 2))) * 2 * Re;
}
