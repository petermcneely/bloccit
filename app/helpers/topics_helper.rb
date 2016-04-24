module TopicsHelper
  def user_is_authorized_for_creating_or_deleting_topics?
    current_user && current_user.admin?
  end

  def user_is_authorized_for_editing_topics?
    current_user && (current_user.admin? || current_user.moderator?)
  end
end
