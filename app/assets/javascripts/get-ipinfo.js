var GetIpInfo = function(ipAddr) {
    var info = null;
    var infoUrl = "https://ipinfo.io/" + ipAddr;
    $.ajax({
        url: infoUrl,
        type: 'GET',
        dataType: 'json',
        async: false,
        success: function(data) {
            info = data;
        }
    });
    return info;
};

// Convenience functions
var GetCoord = function(ipAddr) {
    return GetIpInfo(ipAddr).loc;
};

var GetCity = function(ipAddr) {
    return GetIpInfo(ipAddr).city;
};

var GetCountry = function(ipAddr) {
    return GetIpInfo(ipAddr).country;
};

var GetHostname = function(ipAddr) {
    return GetIpInfo(ipAddr).hostname;
};

var GetOrg = function(ipAddr) {
    return GetIpInfo(ipAddr).org;
};

var GetPhone = function(ipAddr) {
    return GetIpInfo(ipAddr).phone;
};

var GetPostal = function(ipAddr) {
    return GetIpInfo(ipAddr).postal;
};

var GetRegion = function(ipAddr) {
    return GetIpInfo(ipAddr).region;
};