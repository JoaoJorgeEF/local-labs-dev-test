class Story < ApplicationRecord
    belongs_to :writer, class_name: 'User'
    belongs_to :reviewer, class_name: 'User'
end
