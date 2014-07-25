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
    var area = new OpenLayers.Layer.Vector("KML", {
        strategies: [ new OpenLayers.Strategy.Fixed() ],
        protocol: new OpenLayers.Protocol.HTTP({
            url: "/cobrands/fixmykalye/ph.kml",
            format: new OpenLayers.Format.KML()
        })
    });

    // var qc = new OpenLayers.Layer.Vector("KML", {
    //     strategies: [ new OpenLayers.Strategy.Fixed() ],
    //     protocol: new OpenLayers.Protocol.HTTP({
    //         url: "/cobrands/fixmykalye/qc.kml",
    //         format: new OpenLayers.Format.KML()
    //     })
    // });

    // var mnl = new OpenLayers.Layer.Vector("KML", {
    //     strategies: [ new OpenLayers.Strategy.Fixed() ],
    //     protocol: new OpenLayers.Protocol.HTTP({
    //         url: "/cobrands/fixmykalye/mnnl.kml",
    //         format: new OpenLayers.Format.KML()
    //     })
    // });

    area.styleMap.styles['default'].defaultStyle = fixmystreet.area_format;

    // if ( window.location.href == "http://128.199.175.9/reports/Manila+City+Council" ) {
    //     fixmystreet.map.addLayer(mnl)
    // } else if ( window.location.href == "http://128.199.175.9/reports/Quezon+City+Council" ) {
    //     fixmystreet.map.addLayer(qc)
    // } else {
    //     fixmystreet.map.addLayer(area);
    // }

    if ( fixmystreet.area.length > 0)
    {
        var area = new OpenLayers.Layer.Vector("KML", {
            strategies: [ new OpenLayers.Strategy.Fixed() ],
            protocol: new OpenLayers.Protocol.HTTP({
                url: "/mapit/area/" + fixmystreet.area[i] + ".kml?simplify_tolerance=0.0001",
                format: new OpenLayers.Format.KML()
            })
        });
    }

    fixmystreet.map.addLayer(area);

    //area.events.register('loadend', null, function(a,b,c) {
    //    area.styleMap.styles['default'].defaultStyle = fixmystreet.area_format;
    //});
}
