class Category < ActiveRecord::Base
  has_and_belongs_to_many :products, :uniq => true

  validates :name, :presence => true, :allow_blank => false, :uniqueness => true

  has_ancestry

  def to_label
    name
  end


  # setting as main roots
  # all nodes with parent equal to '#'
  def parent_id=(v)
    v = nil if v == '#'
    super(v)
  end

  class << self

    def nav_label
      self.model_name.human.pluralize.titleize
    end

  end
end
