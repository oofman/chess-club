class MatchesController < ApplicationController
    def index
        @matches = Match.order("created_at").all
        @status_options = {'User Won'=>'user_won','Challenget Won'=>'challenger_won','Was a draw'=>'draw'}.invert
    end

    def new
        # if we should save the posted form
        if request.post?
            
            @match = Match.new(match_params)
            
            if @match.save
                redirect_to action: 'index'
            end
        else
            # default add form (get request)
            @match = Match.new
            @members = Member.all
            @status_options = {'User Won'=>'user_won','Challenget Won'=>'challenger_won','Was a draw'=>'draw'}
        end
    end

    def delete
        match = Match.find(params[:id])
        match.destroy
        redirect_to action: 'index'
    end

    private

    def match_params
        # params allowed to be saved by .save() command
        params.require(:match).permit(
            :user_id,
            :user_rank,
            :user_rank_new,
            :challenger_id,
            :channelger_rank,
            :channelger_rank_new,
            :match_status
        )
    end
end
