module Linkable
    extend ActiveSupport::Concern

    included do
        has_many :outgoing_links, as: :origin, dependent: :destroy, class_name: "Link"
        has_many :incoming_links, as: :linkable, dependent: :destroy, class_name: "Link"

        # this is kind of horrible but im not sure how to write the associations
        # to join the two directions into one association. maybe its ok, i might need them separate somewhere
        has_many :outgoing_campaigns, through: :outgoing_links, source: :linkable, source_type: "Campaign"
        has_many :incoming_campaigns, through: :incoming_links, source: :origin, source_type: "Campaign"
        
        has_many :outgoing_locations, through: :outgoing_links, source: :linkable, source_type: "Location"
        has_many :incoming_locations, through: :incoming_links, source: :origin, source_type: "Location"
        
        has_many :outgoing_quests, through: :outgoing_links, source: :linkable, source_type: "Quest"
        has_many :incoming_quests, through: :incoming_links, source: :origin, source_type: "Quest"
        
        has_many :outgoing_notes, through: :outgoing_links, source: :linkable, source_type: "Note"
        has_many :incoming_notes, through: :incoming_links, source: :origin, source_type: "Note"
    end

    def links
        outgoing_links.or(incoming_links)
    end

    def related(type)
        self.send("outgoing_" + type) + self.send("incoming_" + type)
    end
end
