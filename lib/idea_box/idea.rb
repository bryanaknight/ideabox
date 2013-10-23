class Idea
  include Comparable
  attr_reader :title, :description, :rank, :id, :tags
  attr_accessor :created_at, :updated_at, :group

  def initialize(attributes = {})
    @title = attributes["title"]
    @description = attributes["description"]
    @rank = attributes["rank"] || 0
    @id = attributes["id"]
    @tags = attributes["tags"]
    @created_at = attributes["created_at"] ||= Time.now
    @updated_at = attributes["updated_at"] ||= Time.now
    @group = attributes["group"] ||= "Groupless"
  end

  def save
    IdeaStore.create(to_h)
  end

  def to_h
    {
      "title" => title,
      "description" => description,
      "rank" => rank,
      "tags" => tags,
      "updated_at" => updated_at,
      "created_at" => created_at,
      "group" => group
    }
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> rank
  end

  def created_at_day(date)
    date.strftime("%m/%d/%Y")
  end

end
