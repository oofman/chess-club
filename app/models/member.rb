class Member < ApplicationRecord
    has_many :matches, foreign_key: :user_id
    has_many :matches_challenger, class_name: :Match, foreign_key: :challenger_id

    validates :name, :presence => {:presence => true, message: "Please supply a valid Name."}
    validates :email, :uniqueness => { :case_sensitive => false }

    before_create :set_rank

    private

    def set_rank
        self.current_rank = Member.count + 1
    end
    
end
