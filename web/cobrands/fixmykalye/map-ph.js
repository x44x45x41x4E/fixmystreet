$(function(){
    fixmystreet.area_format = { fillColor: 'white', fillOpacity: 0.75, strokeWidth: 0, strokeColor: 'black' }
    // Vector layers must be added onload as IE sucks
    if ($.browser.msie) {
        $(window).load(fms_ph_onload);
    } else {
        fms_ph_onload();
    }
});

function fms_ph_onload() {
    if ( fixmystreet.area.length == 0)
    {
        var area = new OpenLayers.Layer.Vector("KML", {
        strategies: [ new OpenLayers.Strategy.Fixed() ],
        protocol: new OpenLayers.Protocol.HTTP({
            url: "/cobrands/fixmykalye/ph.kml",
            format: new OpenLayers.Format.KML()
            })
        });

        area.styleMap.styles['default'].defaultStyle = area_format;
        fixmystreet.map.addLayer(area);
    }
    area.styleMap.styles['default'].defaultStyle = area_format;
}
