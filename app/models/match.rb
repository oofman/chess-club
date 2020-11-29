class Match < ApplicationRecord

    belongs_to :user, class_name: :Member, foreign_key: :user_id
    belongs_to :challenger, class_name: :Member, foreign_key: :challenger_id
    
    validates :user_id, :presence => {:presence => true, message: "Please supply a member."}
    validates :challenger_id, :presence => {:presence => true, message: "Please supply a challenger."}
    validates :match_status, :presence => {:presence => true, message: "Please select a match status."}
    
    before_create :update_match
    after_create :update_match_count

    private

    def update_match
        self.user_rank = self.user.current_rank
        self.challenger_rank = self.challenger.current_rank
    end

    def update_match_count
        self.user.update(num_games: self.user.num_games+1)
        self.challenger.update(num_games: self.challenger.num_games+1)
    end
end
