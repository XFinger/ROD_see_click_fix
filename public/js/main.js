var closedMarkerOptions = {
    radius: 5,             
    fillColor: "#eeeeee",  
    color: "#000000",      
    weight: 2,             
    opacity: 1,            
    fillOpacity: 0.8       
};                         
var openMarkerOptions = {  
    radius: 5,             
    fillColor: "#00F",     
    color: "#000000",      
    weight: 2,             
    opacity: 1,            
    fillOpacity: 0.8       
};                         
var ackMarkerOptions = {   
    radius: 5,             
    fillColor: "#29C107",  
    color: "#000000",      
    weight: 2,             
    opacity: 1,            
    fillOpacity: 0.8       
};

                         
var oi = open_issue;           
var ack = acknowledged_issue;
var ci = closed_issue;
var pop = "<dt>feature.properties.status</dt>"
		 + "<dt>feature.properties.summary</dt>";
var closed_iss = new L.LayerGroup();
L.geoJson(ci, {                                                      
    pointToLayer: function (feature, latlng) {                       
        return L.circleMarker(latlng, closedMarkerOptions);          
                                                                     
}, onEachFeature: function (feature, layer) {                         
        layer.bindPopup( "<dt>" + feature.properties.status + "</dt>" 
		 				+ "<dt>" + feature.properties.summary + "</dt>");                  
    }                                                                
                                                                     
}).addTo(closed_iss);                                                       

var opened_iss = new L.LayerGroup();
 L.geoJson(oi, {                                                   
    pointToLayer: function (feature, latlng) {                      
        return L.circleMarker(latlng, openMarkerOptions);            
                                                                    
}, onEachFeature: function (feature, layer) {                       
        layer.bindPopup( "<dt>" + feature.properties.status + "</dt>" 
		 				+ "<dt>" + feature.properties.summary + "</dt>");                 
    }                                                               
                                                                    
}).addTo(opened_iss);
                                                      
var acknowledged = new L.LayerGroup();
 L.geoJson(ack, {                                                   
    pointToLayer: function (feature, latlng) {                      
        return L.circleMarker(latlng, ackMarkerOptions);            
                                                                    
}, onEachFeature: function (feature, layer) {                       
        layer.bindPopup( "<dt>" + feature.properties.status + "</dt>" 
		 				+ "<dt>" + feature.properties.summary + "</dt>");                 
    }                                                               
                                                                    
}).addTo(acknowledged);
 
  var roadmap = new L.Google("Roadmap");
 
  
    var googleLayer, map; 
     map = L.map('map', {
      center: [  35.818835, -78.644590  ],
      zoom: 12,
      layers: [roadmap, acknowledged, closed_iss, opened_iss]
    }); 
 
 var baseLayers = {
      "Roadmap": roadmap,


    };                                                                 
// Overlay layers are grouped
    var groupedOverlays = {
      "Issues": {
        "Closed Issues": closed_iss,
        "Open Issues": opened_iss,
        "Acknowledged Issues": acknowledged
      }
    };

    // Use the custom grouped layer control, not "L.control.layers"
    var layerControl = L.control.groupedLayers(baseLayers, groupedOverlays);
    map.addControl(layerControl);
    
    // Remove and add a layer
    //layerControl.removeLayer(cities);
    //layerControl.addOverlay(cities, "Cities", "New Category");


