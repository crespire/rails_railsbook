class Like < ApplicationRecord
  after_create :notify
  after_destroy :remove_notify

  belongs_to :likeable, polymorphic: true, counter_cache: true
  belongs_to :user, foreign_key: :liked_by, counter_cache: true

  validates :liked_by, presence: true
  validates :likeable_type, presence: true
  validates :likeable_id, presence: true
  validates :liked_by, uniqueness: { scope: %i[likeable_id likeable_type] }

  private

  def notify
    resource = likeable_type.constantize.find(likeable_id)
    message = "#{user.name} liked your #{likeable_type.downcase}."
    Notification.create(user_id: resource.user.id, trigger_type: 'Like', trigger_id: id, triggered_by_id: liked_by, message: message)
  end

  def remove_notify
    resource = likeable_type.constantize.find(likeable_id)
    return unless Notification.where(id: id, trigger_type: 'Like', trigger_id: id, user_id: resource.user.id).exists?

    Notification.destroy_by(id: id, trigger_type: 'Like', trigger_id: id, user_id: resource.user.id)
  end
end
