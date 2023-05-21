class Story < ApplicationRecord
    belongs_to :writer, class_name: 'User'
    belongs_to :reviewer, class_name: 'User'

    state_machine :status, initial: :unassigned do
        state :unassigned
        state :draft
        state :for_review
        state :in_review
        state :pending
        state :approved
        state :published
        state :archived

        event :set_writer do
            transition unassigned: :draft, if: :chief_editor?
        end

        event :request_review do
            transition draft: :for_review, if: :writer?
        end

        event :start_review do
            transition for_review: :in_review, if: :reviewer?
        end

        event :request_changes do
            transition in_review: :pending, if: :reviewer?
        end

        event :approve do
            transition pending: :approved, if: :reviewer?
        end

        event :publish do
            transition approved: :published, if: :chief_editor?
        end

        event :archive do
            transition any => :archived, if: :chief_editor?
        end

        after_transition any => :draft, do: :automatically_open_comments
        after_transition pending: :draft, do: :automatically_open_comments_if_no_content
        after_transition approved: :published, do: :automatically_publish

        private

        def chief_editor?
            current_user.chief_editor?
        end

        def writer?
            current_user == writer
        end
    
        def reviewer?
            current_user == reviewer
        end

        def automatically_open_comments
            self.comments_open = true
        end
    
        def automatically_open_comments_if_no_content
            automatically_open_comments if content.blank?
        end
    
        def automatically_publish
            publish if approved?
        end
    end
end
