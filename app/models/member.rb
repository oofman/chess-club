class Member < ApplicationRecord
    validates :name, :presence => {:presence => true, message: "Please supply a valid Name."}
    validates :email, :uniqueness => { :case_sensitive => false }
end
