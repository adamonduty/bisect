require 'time'

class Time
  include Bisectable

  def coerce(other)
    if Integer === other
      [other, to_i]
    else
      old_coerce
    end
  end

  def +(arg)
    to_i.+(arg)
  end

  def /(arg)
    to_i./(arg)
  end

  def <=(arg)
    to_i.<=(arg)
  end

  def >(arg)
    to_i.>(arg)
  end

  def ==(arg)
    to_i.==(arg)
  end

end
