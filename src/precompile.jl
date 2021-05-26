function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    precompile(Tuple{typeof(ComoniconTargetExpr.emit_expr), ComoniconTypes.Entry})
    precompile(Tuple{typeof(ComoniconTargetExpr.emit_parse_value), ComoniconTypes.LeafCommand, Type, Expr})
    precompile(Tuple{typeof(ComoniconTargetExpr.emit_parse_value), ComoniconTypes.Option, Type, Symbol})

    precompile(Tuple{typeof(ExproniconLite.codegen_ast), Expr})
    precompile(Tuple{typeof(ExproniconLite.is_function), Int})
    precompile(Tuple{typeof(ExproniconLite.xcall), Expr, QuoteNode, Symbol, Int})
    precompile(Tuple{typeof(ExproniconLite.xcall), Expr, QuoteNode, Type, Int})
end
