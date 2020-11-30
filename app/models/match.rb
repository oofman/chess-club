class Match < ApplicationRecord

    belongs_to :user, class_name: :Member, foreign_key: :user_id
    belongs_to :challenger, class_name: :Member, foreign_key: :challenger_id
    
    validates :user_id, :presence => {:presence => true, message: "Please supply a member."}
    validates :challenger_id, :presence => {:presence => true, message: "Please supply a challenger."}
    validates :match_status, :presence => {:presence => true, message: "Please select a match status."}
    validate :check_participents

    before_create :update_match
    after_create :update_match_count,:update_rank

    private

    def check_participents
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
    ## - Draw = lowwer rank -1 (unless = other player rank)
    # - Lower rank wins = lower rank half difference (16 - 10) / 2 = 3
	#	                = higher rank +1
    def update_rank
        #set old ranks
        self.update(user_rank: self.user.current_rank, challenger_rank: self.challenger.current_rank)

        case self.match_status
        when 'user_won'
            #lower rank won 3 < 5-1
            if self.challenger.current_rank < (self.user.current_rank - 1)
                #update user rank
                update_won(self, 'user')
            end
        when 'challenger_won'
            #lower rank won 3 < 5-1
            if self.user.current_rank < (self.challenger.current_rank - 1)
                #update challenger rank
                update_won(self, 'challenger')
            end
        when 'draw'
            #update lower rank
            if self.user.current_rank < (self.challenger.current_rank - 1)
                #update challenger
                update_draw(self, 'challenger')
            #update lower rank
            elsif self.challenger.current_rank < (self.user.current_rank - 1)
                #update user
                update_draw(self, 'user')
            end
        end

        # set new rank after calc
        self.update(user_rank_new: self.user.current_rank, challenger_rank_new: self.challenger.current_rank)
    end

    def update_draw(match, type)
        update_id = (type == 'challenger') ? match.challenger_id : match.user_id
        user = Member.find(update_id)
        
        # Lower rank - 1
        member_update = Member.where(current_rank: (user.current_rank - 1)).first
        member_update.update(current_rank: (update_member.current_rank+1))
        user.update(current_rank: (user.current_rank - 1))
    end

    def update_won(match, type)

        won_id = (type == 'challenger') ? match.challenger_id : match.user_id
        lost_id = (type == 'challenger') ? match.user_id : match.challenger_id
        won_rank = (type == 'challenger') ? match.challenger_rank : match.user_rank
        lost_rank = (type == 'challenger') ? match.user_rank : match.challenger_rank
        member_won = Member.find(won_id)
        member_lost = Member.find(lost_id)

        # Higher rank + 1
        member_lost_update = Member.where(current_rank: (member_lost.current_rank + 1)).first
        member_lost_update.update(current_rank: member_lost_update.current_rank - 1)
        member_lost.update(current_rank: (member_lost.current_rank + 1))

        # Lower rank = lower rank half difference (16 - 10) / 2 = 3
        new_rank = ((won_rank - lost_rank) / 2)
        #update all effected ranks
        update_members = Member.where("current_rank >= ? AND current_rank < ?",new_rank,won_rank).all
        update_members.each do |update_member|
            update_member.update(current_rank: (update_member.current_rank+1))
        end
        
        member_won.update(current_rank: new_rank)
    end

end
