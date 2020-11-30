class Match < ApplicationRecord

    belongs_to :user, class_name: :Member, foreign_key: :user_id
    belongs_to :challenger, class_name: :Member, foreign_key: :challenger_id
    
    validates :user_id, :presence => {:presence => true, message: "Please supply a member."}
    validates :challenger_id, :presence => {:presence => true, message: "Please supply a challenger."}
    validates :match_status, :presence => {:presence => true, message: "Please select a match status."}
    validates :check_participents

    before_create :update_match
    after_create :update_match_count

    private

    def check_email_and_password
        errors.add(:user_id, "Can't play against yourself.") if user_id == challenger_id
    end

    def update_match
        self.user_rank = self.user.current_rank
        self.challenger_rank = self.challenger.current_rank
    end

    def update_match_count
        self.user.update(num_games: self.user.num_games+1)
        self.challenger.update(num_games: self.challenger.num_games+1)
    end

    # #Ranking:
    ## - higher rank wins = nothing
    # - Draw = lowwer rank -1 (unless = other player rank)
    # - Lower rank wins = lower rank half difference (16 - 10) / 2 = 3
	#	                = higher rank +1
    def update_rank(match)
        case match.match_status
        when 'user_won'
            #lower rank won 3 < 5-1
            if match.challenger.rank < (match.user.rank - 1)
                #update user rank

            end
        when 'challenger_won'
            #lower rank won 3 < 5-1
            if match.user.rank < (match.challenger.rank - 1)
                #update challenger rank

            end
        when 'draw'
            #update lower rank
            if match.user.rank < (match.challenger.rank - 1)
                #update challenger

            #update lower rank
            elsif match.challenger.rank < (match.user.rank - 1)
                #update user

            end
        end

    end
end
