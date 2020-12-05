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
        self.user_rank = user.current_rank
        self.challenger_rank = challenger.current_rank
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
        ActiveRecord::Base.transaction do

            #set old ranks
            update(user_rank: user.current_rank, challenger_rank: challenger.current_rank)

            # Filtering out edge case
            case match_status
            when 'user_won'
                who_won = challenger.current_rank < user.current_rank ? 'user' : false
            when 'challenger_won'
                who_won = (user.current_rank < challenger.current_rank) ? 'challenger' : false
            when 'draw'
                if (challenger.current_rank < (user.current_rank - 1))
                    who_won = 'user'
                elsif (user.current_rank < (challenger.current_rank - 1))
                    who_won = 'challenger'
                else
                    who_won = false
                end
            end
            (match_status == 'draw') ? update_draw(who_won) : update_won(who_won) if who_won

            # set new rank after calc
            reload
            update(user_rank_new: user.current_rank, challenger_rank_new: challenger.current_rank)
        end

        return
    end

    def update_draw(who_won)
        won_rank = (who_won == 'challenger') ? challenger_rank : user_rank
        won_id = (who_won == 'challenger') ? challenger_id : user_id
        
        # Lower rank - 1
        sql = "UPDATE members SET current_rank = #{won_rank} WHERE current_rank = #{(won_rank - 1)} LIMIT 1"
        ActiveRecord::Base.connection.execute(sql)
        sql = "UPDATE members SET current_rank = #{(won_rank - 1)} WHERE id = #{won_id} LIMIT 1"
        ActiveRecord::Base.connection.execute(sql)
    end

    def update_won(who_won)
        won_id = (who_won == 'challenger') ? challenger_id : user_id
        lost_id = (who_won == 'challenger') ? user_id : challenger_id
        won_rank = (who_won == 'challenger') ? challenger_rank : user_rank
        lost_rank = (who_won == 'challenger') ? user_rank : challenger_rank
        
        # Higher rank + 1 (single switch)
        sql = "UPDATE members SET current_rank = #{lost_rank} WHERE current_rank = #{(lost_rank + 1)} LIMIT 1"
        ActiveRecord::Base.connection.execute(sql)
        sql = "UPDATE members SET current_rank = #{(lost_rank + 1)} WHERE id = #{lost_id} LIMIT 1"
        ActiveRecord::Base.connection.execute(sql)
        
        # Lower rank = lower rank half difference (16 - 10) / 2 = 3
        new_rank = won_rank - ((won_rank - lost_rank).to_f / 2).ceil
        
        # Shift everyone involved
        sql = "UPDATE members SET current_rank = (current_rank+1) WHERE current_rank >= #{new_rank} AND current_rank < #{won_rank}"
        ActiveRecord::Base.connection.execute(sql)
        
        # Update winning rank
        sql = "UPDATE members SET current_rank = #{new_rank} WHERE id = #{won_id} LIMIT 1"
        ActiveRecord::Base.connection.execute(sql)
    end

end
