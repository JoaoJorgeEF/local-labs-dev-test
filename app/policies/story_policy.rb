class StoryPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def chief_editor?
    user.chief_editor?
  end

  def write?
    user.id == record.writer.id
  end

  def can_comment?(record_as_param)
    user.chief_editor? || user.id == record_as_param.writer_id || user.id == record_as_param.reviewer_id
  end
end
