module Particle
use Geometry
implicit none

type :: particle3d
  type(point3d) :: p      !    Position
  type(vector3d) :: v     !    Velocity
  real(dp) :: m           !    Mass 
end type

end module
