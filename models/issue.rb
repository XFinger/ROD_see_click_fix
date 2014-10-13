class Issue < ActiveRecord::Base

  scope :is_open , -> { where(status: 'Open') }
  scope :is_ack , -> { where(status: 'Acknowledged') }
  scope :is_closed , -> { where(status: 'Closed') }
  scope :is_archived , -> { where(status: 'Archived') }
  scope :is_on, lambda {|updated| where(:updated_at => updated)}
  
end