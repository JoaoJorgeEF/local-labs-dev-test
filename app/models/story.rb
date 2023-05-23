class Story < ApplicationRecord
    attr_accessor :story_status

    has_many :comments
    belongs_to :organization
    belongs_to :writer, class_name: 'User', optional: true
    belongs_to :reviewer, class_name: 'User', optional: true

    validates :headline, presence: true
    # validates :body, presence: true, length: { minimum: 10 }

    state_machine :story_status, initial: :unassigned do
        state :unassigned
        state :draft
        state :for_review
        state :in_review
        state :pending
        state :approved
        state :published
        state :archived

        event :set_writer_event do
            transition unassigned: :draft
        end

        event :request_review do
            transition draft: :for_review
        end

        event :start_review do
            transition for_review: :in_review
        end

        event :request_changes do
            transition in_review: :pending
        end

        event :approve do
            transition pending: :approved
        end

        event :publish do
            transition approved: :published
        end

        event :archive do
            transition any => :archived
        end

        after_transition any => :draft, do: :open_comments
        after_transition pending: :draft, do: :open_comments_if_no_content
        after_transition approved: :published, do: :automatically_publish
    end

    def open_comments
        self.comments_open = true
    end

    def close_comments
        selt.comments_open = false
    end

    def open_comments_if_no_content
        open_comments if content.blank?
    end

    def automatically_publish
        publish if approved?
    end
end
