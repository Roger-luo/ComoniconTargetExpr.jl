module ComoniconTargetExpr

using ExproniconLite
using ComoniconTypes
using ComoniconOptions

export emit_expr

include("emit.jl")
include("precompile.jl")
_precompile_()

end
