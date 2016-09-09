class BodiesData

  def initialize(channel, time, recognized_body_count, bodies)
    @channel = channel
    @time    = time
    @recognized_body_count = recognized_body_count

    @bodies = []
    bodies.each do |body|
      @bodies<< Body.new(body)
    end

  end

  def dump()
    p("channel=#{@channel}, time=#{@time}, recognized_body_count=#{@recognized_body_count}")

    if @recognized_body_count >= 1
      @bodies.each do |body|
        body.joints.each do |joint|
          p("#{joint.joint_name}, X=#{joint.coordinates.x}, Y=#{joint.coordinates.y}, Z=#{joint.coordinates.z}")
        end
      end
    end

  end

  attr_reader :channel, :time, :recognized_body_count, :bodies

end

class Body

  def initialize(body)
    @joints =[]
    body["Joints"].each do |joint|
      @joints << Joint.new(joint["JointName"], joint["X"], joint["Y"], joint["Z"])
    end
  end

  attr_reader :joints

end

class Joint

  def initialize(joint_name, x, y, z)
    @joint_name = joint_name
    @coordinates = Coordinates.new(x, y, z)
  end

  attr_reader :joint_name, :coordinates

end

class Coordinates

  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end

  attr_reader :x, :y, :z

end