class Class
  def subclasses
    result = []
    ObjectSpace.each_object(singleton_class) do |k|
      result << k if k.superclass == self
    end

    result
  end
end
