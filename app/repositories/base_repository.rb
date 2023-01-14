class BaseRepository < ROM::Repository::Root
  commands :create, update: :by_pk, delete: :by_pk

  def by_id(id)
    root.by_pk(id).one
  end

  def all
    root.to_a
  end
end

