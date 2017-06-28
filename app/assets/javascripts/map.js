var BingMapsKey = "AqNj2Azka9Dpb8astw8aJlB5yEu10JZ1Wy-Jpij0Q4Ciy0EjsE4NyPNmPbkXvAA4";
var googleKey = "AIzaSyDbF0XQVbSm9l0iTEKKIOyAAx_nFiwZsLE";

var map, geocoder, marker, markers;


function showMap(coordinates, iconPath, divID) {
    var mapOptions = {
        center: { lat: coordinates.lat, lng: coordinates.lng},
        zoom: 18,
        scrollwheel: true,
        gestureHandling: 'greedy', panControl: true
    };
    if(!divID){
        map = new google.maps.Map(document.getElementById('mapDiv'), mapOptions);
    }else{
        map = new google.maps.Map(document.getElementById(divID), mapOptions);
    }
    addPin(mapOptions.center, iconPath);
}

function SetupMapForNewListing()
{
    // Initialize the map
    var mapOptions = {
        center: { lat: -25.29497130137078, lng: -57.6228308863517},
        zoom: 18,
        scrollwheel: true,
        gestureHandling: 'greedy', panControl: true
    };

    map = new google.maps.Map($('.map.address-picker')[0], mapOptions);
    geocoder = new google.maps.Geocoder();

    google.maps.event.addListener(map, 'click', handleNewClick);
}

function SetupMapForListing(center)
{
    var mapOptions = {
        center: { lat: center.lat, lng: center.lng},
        zoom: 12,
        scrollwheel: true,
        gestureHandling: 'greedy', panControl: true
    };
    map = new google.maps.Map($('.map')[0], mapOptions);
}


function SetupMapForListings(center) {
    var mapOptions = {
        center: { lat: center.lat, lng: center.lng},
        zoom: 12,
        scrollwheel: true,
        gestureHandling: 'greedy', panControl: true
    };

    map = new google.maps.Map($('.map.address-picker')[0], mapOptions);

    //google.maps.event.addListener(map, 'click', handleClick);
}

function SetupMapForSavedListing(div,center) {
    var mapOptions = {
        center: { lat: center.lat, lng: center.lng},
        zoom: 12,
        disableDefaultUI:true,
        scrollwheel: true,
        gestureHandling: 'greedy', panControl: true
    };

    map = new google.maps.Map($(div)[0], mapOptions);
    var latlng = new google.maps.LatLng(center.lat, center.lng);
    var marker = new google.maps.Marker({
        position: latlng,
        map: map,
        title: ''
    });


}

// Zooms the map to current location
function ZoomIn(args) {
    map.setView({
        zoom: 18,
        center: args.center
    });

    var pin = map.entities.get(map.entities.getLength()-1);
    map.entities.push(pin);
}

function handleNewClick(event) {

    if (marker !== undefined) {
        marker.setMap(null);
    }
    marker = new google.maps.Marker({
        position: event.latLng,
        map: map
    });
    map.panTo(event.latLng);

    geocode({ 'latLng': event.latLng });

}

function SetMapLocation(loc)
{
    var options = map.getOptions();
    var pin = map.entities.get(map.entities.getLength()-1);
    pin.setLocation(loc);
    options.center = loc;
    map.setView(options);
}

function addPin(location, iconPath)
{
    var latlng = new google.maps.LatLng(location.lat, location.lng);
    var marker = new google.maps.Marker({
        position: latlng,
        map: map,
        icon: {url: iconPath, scaledSize: new google.maps.Size(70, 70)},
        title: ''
    });
    return marker;
}

function pinClicked(e) {
    console.log(e);
}

function MakeGeocodeRequest(query)
{
    var geocoder = new google.maps.Geocoder();
    geocoder.geocode( { 'address': query}, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            map.setCenter(results[0].geometry.location);
            if (marker !== undefined) {
                marker.setMap(null);
            }
            marker = new google.maps.Marker({
                position: results[0].geometry.location,
                map: map
            });
            $('#listing_latitude').val(results[0].geometry.location.lat);
            $('#listing_longitude').val(results[0].geometry.location.lng);
            SetMapLocation(results[0].geometry.location);

        } else {

        }
    });

}

function geocode(request) {
    var query = '';
    if (request.latLng) {
        query = request.latLng.toUrlValue();
    } else {
        query = request.address;
    }

    var country = $('#listing_country').val();

    if (country) {
        request.country = country;
    }

    var hash = getPermalink(query);
    hashFragment = '#' + escape(hash);
    window.location.hash = escape(hash);
    geocoder.geocode(request, ReverseGeocodeCallback);
}

function getPermalink(query) {
    var hash = 'q=' + query;
    var country =  $('#listing_country').val();

    if (country) {
        hash += '&country=' + country;
    }

    return hash
}

function ReverseGeocodeCallback(result)
{
    var pyState = $("select.py-states");
    var usState = $("select.us-states");

    // Do something with the result
    if (result && result.length > 0)
    {
        var resource = result[0];
        var address = resource.address_components;
        var road = parseAddress(address, "route");
        if(road == 'Unnamed Road'){
            road = I18n.t('unnamed_road');
        }

        var country = parseAddressShort(address, "country");

        $('#listing_address1').val(road + ' ' + parseAddress(address, "street_number") );

        $('#listing_city').val(parseAddress(address, "locality"));
        var local_conversion = {};
        if(country == 'PY'){
            local_conversion['Departamento de Itapúa'] = 'Itapúa';
            local_conversion['Asunción'] = 'Asunción (Capital)';
            local_conversion['Departamento de Concepción'] = 'Concepción';
            local_conversion['San Pedro'] = 'San Pedro';
            local_conversion['Cordillera'] = 'Cordillera';
            local_conversion['Departamento de Caazapá'] = 'Caazapá';
            local_conversion['Departamento de Guairá'] = 'Guairá';
            local_conversion['Departamento de Caaguazú'] = 'Caaguazú';
            local_conversion['Departamento de Misiones'] = 'Misiones';
            local_conversion['Departamento de Paraguarí'] = 'Paraguarí';
            local_conversion['Departamento de Alto Paraná'] = 'Alto Paraná';
            local_conversion['Departamento Central'] = 'Central';
            local_conversion['Departamento de Ñeembucú'] = 'Ñeembucú';
            local_conversion['Amambay'] = 'Amambay';
            local_conversion['Canindeyú'] = 'Canindeyú';
            local_conversion['Presidente Hayes'] = 'Presidente Hayes';
            local_conversion['Departamento de Alto Paraguay'] = 'Alto Paraguay';
            local_conversion['Departamento de Boquerón'] = 'Boquerón';
            usState.attr('disabled', true).hide();
            pyState.attr('disabled', false).show();
            var departmentFromMap = parseAddress(address, "administrative_area_level_1");
            var conversion = local_conversion[departmentFromMap];
            console.log(conversion);
            pyState.val(conversion);
            console.log(pyState.length);
        }else{
            pyState.attr('disabled', true).hide();
            usState.attr('disabled', false).show();
            var departmentFromMap = parseAddress(address, "administrative_area_level_1");
            console.log(departmentFromMap);
            usState.val(departmentFromMap);
        }
        $('#listing_country').val(country);

        $('#listing_state').change();
        $('#listing_latitude').val(resource.geometry.location.lat());
        $('#listing_longitude').val(resource.geometry.location.lng());
    }
}

function parseAddress(address, address_type)
{
    var result = "";
    $.each(address, function() {

        if (this.types[0] == address_type)
        {
            result = this.long_name;
            return result;
        }
    });
    return result;
}

function parseAddressShort(address, address_type)
{
    var result = "";
    $.each(address, function() {

        if (this.types[0] == address_type)
        {
            result = this.short_name;
            return result;
        }
    });
    return result;
}

function searchModuleLoaded()
{
    console.log("loaded")
}

function errCallback(request)
{

    alert("An error occurred.");
}

