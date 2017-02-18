class User < ActiveRecord::Base
    has_many :teachables, dependent: :destroy
    has_many :proficiencies, through: :teachables, source: :language
end
