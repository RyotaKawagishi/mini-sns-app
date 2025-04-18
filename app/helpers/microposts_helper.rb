module MicropostsHelper

  # ユーザーIDをメンションリンクに変換する
  def mention_link(user_id)
    user = User.find_by(id: user_id)
    return "" unless user

    link_to "@#{user.name}", user_path(user), class: "mention-link"
  end


end
