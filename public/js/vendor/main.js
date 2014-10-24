
var amMarkerOptions = {   
    radius: 5,             
    fillColor: "#eeeeee",  
    color: "#000000",      
    weight: 2,             
    opacity: 1,            
    fillOpacity: 0.8       
};
                         
//var oi = open_issue;           
//var ack = acknowledged_issue;
//var ci = closed_issue;
var am  = all_marks;


var all_m = new L.LayerGroup();
L.geoJson(am, {                                                      
    pointToLayer: function (feature, latlng) {                       
        return L.circleMarker(latlng, amMarkerOptions);          
                                                                     
}, onEachFeature: function (feature, layer) {                         
        layer.bindPopup( "<dt>" + feature.properties.status + "</dt>" 
		 				+ "<dt>" + feature.properties.summary + "</dt>");                  
    }                                                                
                                                                     
}).addTo(all_m);                                                       

  var roadmap = new L.Google("Roadmap");
 
  
    var googleLayer, map; 
     map = L.map('map', {
      center: [  35.818835, -78.644590  ],
      zoom: 12,
      layers: [roadmap, all_m]
    }); 
 
 var baseLayers = {
      "Roadmap": roadmap,


    };                                                                 
// Overlay layers are grouped       
    var groupedOverlays = {
         "Issues": {

         "All Issues": all_m
      }
    };

    // Use the custom grouped layer control, not "L.control.layers"
    var layerControl = L.control.groupedLayers(baseLayers, groupedOverlays);
    map.addControl(layerControl);
    
    
    // Remove and add a layer
    //layerControl.removeLayer(cities);
    //layerControl.addOverlay(cities, "Cities", "New Category");
    var testlayer = L.geoJson(am);
var sliderControl = L.control.sliderControl({position: "topright", layer: testlayer});
// Add the slider to the map
map.addControl(sliderControl);

// Start the slider
sliderControl.startSlider();






