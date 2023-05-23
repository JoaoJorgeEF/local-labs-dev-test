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
            # transitions from: :pending, to: :draft, after: :open_comments_if_no_content
        end
    
        event :approve do
            transitions from: :in_review, to: :approved
        end
    
        event :publish do
            transitions from: :approved, to: :published
        end
    
        event :archive do
            transitions to: :archived
        end

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
    # validates :body, presence: true, length: { minimum: 10 }

    # state_machine :story_status, initial: :unassigned do
    #     state :unassigned
    #     state :draft
    #     state :for_review
    #     state :in_review
    #     state :pending
    #     state :approved
    #     state :published
    #     state :archived

    #     event :set_writer_event do
    #         transition unassigned: :draft
    #     end

    #     event :request_review do
    #         transition draft: :for_review
    #     end

    #     event :start_review do
    #         transition for_review: :in_review
    #     end

    #     event :request_changes do
    #         transition in_review: :pending
    #     end

    #     event :approve do
    #         transition pending: :approved
    #     end

    #     event :publish do
    #         transition approved: :published
    #     end

    #     event :archive do
    #         transition any => :archived
    #     end

    #     after_transition any => :draft, do: :open_comments
    #     after_transition pending: :draft, do: :open_comments_if_no_content
    #     after_transition approved: :published, do: :automatically_publish
    # end

    # def open_comments
    #     self.comments_open = true
    # end

    # def close_comments
    #     selt.comments_open = false
    # end

    # def open_comments_if_no_content
    #     open_comments if content.blank?
    # end

    # def automatically_publish
    #     publish if approved?
    # end
end
