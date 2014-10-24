object @open_issues

node(:type) { "Feature" }

node :properties do |p|
{	status: p.status,
	 summary: p.summary, 
	 issue_id: p.issue_id, 
	 address: p.address}
end

node :time do |t|
{	created_at: t.created_at, 
	updated_at: t.updated_at,
	acknowledged_at: t.acknowledged_at,
	closed_at: t.closed_at
	}
end
node :geometry do |s|
  {  type:    "Point",
  coordinates: [s.lng, s.lat]
    }
end

 



