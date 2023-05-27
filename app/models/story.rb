class Story < ApplicationRecord
    include AASM

    has_many :comments
    belongs_to :organization
    belongs_to :writer, class_name: 'User', optional: true
    belongs_to :reviewer, class_name: 'User', optional: true

    validates :headline, presence: true

    aasm :column => 'story_status' do
        state :unassigned, initial: true
        state :draft
        state :for_review
        state :in_review
        state :pending
        state :approved
        state :published
        state :archived

        event :set_writer do
            transitions from: :unassigned, to: :draft
        end

        event :request_review do
            transitions from: :draft, to: :for_review
        end
    
        event :start_review do
            transitions from: :for_review, to: :in_review
        end
    
        event :request_changes do
            transitions from: :in_review, to: :pending
        end

        event :back_to_draft do
            transitions from: :pending, to: :draft
        end
    
        event :approve do
            transitions from: :in_review, to: :approved
        end
    
        event :publish do
            transitions from: :approved, to: :published
        end
    
        event :archive do
            transitions from: :approved, to: :archived
        end

    end

    def unassigned?
        story_status == "unassigned"
    end

    def draft?
        story_status == "draft"
    end

    def for_review?
        story_status == "for_review"
    end

    def in_review?
        story_status == "in_review"
    end

    def pending?
        story_status == "pending"
    end

    def approved?
        story_status == "approved"
    end

    def published?
        story_status == "published"
    end

    def archived?
        story_status == "archived"
    end

    def has_body?
        !body.blank?
    end
end
