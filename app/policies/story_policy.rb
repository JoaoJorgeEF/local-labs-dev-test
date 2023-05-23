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
end
