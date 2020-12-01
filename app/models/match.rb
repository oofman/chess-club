class Match < ApplicationRecord

    belongs_to :user, class_name: :Member, foreign_key: :user_id
    belongs_to :challenger, class_name: :Member, foreign_key: :challenger_id
    
    validates :user_id, :presence => {:presence => true, message: "Please supply a member."}
    validates :challenger_id, :presence => {:presence => true, message: "Please supply a challenger."}
    validates :match_status, :presence => {:presence => true, message: "Please select a match status."}
    validate :check_participents

    before_create :update_match
    after_create :update_match_count, :update_rank

    private

    def check_participents
        errors.add(:user_id, "Can't play against yourself.") if user_id == challenger_id
    end

    def update_match
        user_rank = user.current_rank
        challenger_rank = challenger.current_rank
    end

    def update_match_count
        user.update(num_games: user.num_games + 1)
        challenger.update(num_games: challenger.num_games + 1)
    end

    # #Ranking:
    # # - higher rank wins = nothing
    # # - Draw = lowwer rank -1 (unless = other player rank)
    # # - Lower rank wins = lower rank half difference (16 - 10) / 2 = 3
	# #	                = higher rank +1
    def update_rank
        #set old ranks
        update(user_rank: user.current_rank, challenger_rank: challenger.current_rank)

        who_won = false
        if match_status == 'user_won' && (challenger.current_rank < user.current_rank)
            who_won = 'user'
        elsif match_status == 'challenger_won' && (user.current_rank < challenger.current_rank)
            who_won = 'challenger'
        elsif match_status == 'draw' && (user.current_rank < (challenger.current_rank - 1))
            who_won = 'challenger'
        elsif match_status == 'draw' && (challenger.current_rank < (user.current_rank - 1))
            who_won = 'user'
        end
        (match_status == 'draw') ? update_draw(who_won) : update_won(who_won) if who_won

        # set new rank after calc
        reload
        update(user_rank_new: user.current_rank, challenger_rank_new: challenger.current_rank)
    end

    def update_draw(who_won)
        update_id = (who_won == 'challenger') ? challenger_id : user_id
        user = Member.find(update_id)
        
        # Lower rank - 1
        member_update = Member.where(current_rank: (user.current_rank - 1)).first
        member_update.update(current_rank: (update_member.current_rank + 1))
        user.update(current_rank: (user.current_rank - 1))
    end

    def update_won(who_won)
        
        won_id = (who_won == 'challenger') ? challenger_id : user_id
        lost_id = (who_won == 'challenger') ? user_id : challenger_id
        won_rank = (who_won == 'challenger') ? challenger_rank : user_rank
        lost_rank = (who_won == 'challenger') ? user_rank : challenger_rank
        member_won = Member.find(won_id) # (1)
        member_lost = Member.find(lost_id)
        
        # Higher rank + 1
        member_lost_update = Member.where(current_rank: (member_lost.current_rank + 1)).first
        member_lost_update.update(current_rank: member_lost_update.current_rank - 1)
        member_lost.update(current_rank: (member_lost.current_rank + 1))
        
        # Lower rank = lower rank half difference (16 - 10) / 2 = 3
        new_rank = won_rank - ((won_rank - lost_rank).to_f / 2).ceil
        
        #update all effected ranks
        update_members = Member.where("current_rank >= ? AND current_rank < ?",new_rank,won_rank).all
        update_members.each do |update_member|
            update_member.update(current_rank: (update_member.current_rank + 1))
        end
        
        #update winning rank # (2)
        member_won.update(current_rank: new_rank)
        # reduce query count from 2 to 1 (get & set)
        # sql = "UPDATE members SET current_rank = #{new_rank} WHERE id = #{won_id} LIMIT 1"
        # ActiveRecord::Base.connection.select_all(sql)
    end

end
