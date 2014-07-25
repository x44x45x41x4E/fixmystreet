$(function(){
    fixmystreet.area_format = { fillColor: 'white', fillOpacity: 0.75, strokeWidth: 1 strokeColor: 'black' }
    // Vector layers must be added onload as IE sucks
    if ($.browser.msie) {
        $(window).load(fms_ph_onload);
    } else {
        fms_ph_onload();
    }
});

function fms_ph_onload() {
    var extent = new OpenLayers.Bounds(120.9,14.55,0 120.9,14.78,0 121.2,14.78,0 121.2,14.55,0 120.9,14.55,0);
    var area = new OpenLayers.Layer.Vector("KML", {
        strategies: [ new OpenLayers.Strategy.Fixed() ],
        protocol: new OpenLayers.Protocol.HTTP({
            url: "/cobrands/phexample/ph.kml",
            format: new OpenLayers.Format.KML()
        })
    });
    area.styleMap.styles['default'].defaultStyle = fixmystreet.area_format;
    fixmystreet.map.addLayer(area);
    fixmystreet.map.setOptions({restrictedExtent: extent})
    //area.events.register('loadend', null, function(a,b,c) {
    //    area.styleMap.styles['default'].defaultStyle = fixmystreet.area_format;
    //});
}
