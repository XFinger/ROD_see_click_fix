object @closed_issues

node(:type) { "Feature" }

node :properties do |p|
{status: p.status, updated_at: p.updated_at, summary: p.summary, popupContent: [p.status, p.summary ]}
end

node :geometry do |s|
  {  type:    "Point",
  coordinates: [s.lng, s.lat]
    }
end

 



