class Product < ActiveRecord::Base
  has_and_belongs_to_many :categories, :uniq => true
  validates :name, :presence => true, :allow_nil => false, :allow_blank => false, :uniqueness => true
  attr_accessor :categories_tags

  def to_label
    name
  end

  def categories_tags
    categories.to_a.map(&:id).join(',')
  end

  def categories_tags=(values = [])
    self.category_ids = values.split(',')
  end

  class << self

    def nav_label
      self.model_name.human.pluralize.titleize
    end

  end

end
