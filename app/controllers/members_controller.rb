class MembersController < ApplicationController
    def index
        @members = Member.order("current_rank").all
    end

    def new
        # if we should save the posted form
        if request.post?

            @member = Member.new(member_params)
            if @member.save
                redirect_to action: 'index'
            end
        else
            # default add form (get request)
            @member = Member.new
        end
    end

    def delete
        member = Member.find(params[:id])
        member.destroy
        redirect_to action: 'index'
    end

    def edit
        # locate existing article
        @member = Member.find(params[:id])
        
        # if we should save the posted form
        if request.post?
            if @member.update(member_params)
                redirect_to action: 'index'
            end
        end
    end

    private

    def member_params
        # params allowed to be saved by .save() command
        params.require(:member).permit(
            :name,
            :email,
            :dob,
            :current_rank
        )
    end
end
