-- lua/snippets/tex.lua
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

-- VimTeX-aware mathzone detection (works when vimtex is loaded)
local function in_mathzone()
  local ok, res = pcall(function()
    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
  end)
  return ok and res
end

local function not_mathzone() return not in_mathzone() end

-- Helper to make snippet conditional
local function cond(fn)
  return { condition = fn }
end

return {
  -- begin/end env with mirrored name
  s("beg", fmt([[
\begin{{{}}}
  {}
\end{{{}}}
]], { i(1, "environment"), i(0), rep(1) }), cond(not_mathzone)),

  -- Inline math wrappers (two styles)
  s("mk", c(1, {
    fmt([[\({}\)]], { i(1) }),
    fmt([[$ {} $]], { i(1) }),
  })),

  -- Display math
  s("dm", fmt([[
\[
  {}
\]
]], { i(0) })),

  -- Fraction / sum / integral (mathzone)
  s("ff", fmt([[\frac{{{}}}{{{}}}]], { i(1), i(2) }), cond(in_mathzone)),
  s("sum", fmt([[\sum_{{{}}}^{{{}}} {}]], { i(1, "i=1"), i(2, "n"), i(0) }), cond(in_mathzone)),
  s("int", fmt([[\int_{{{}}}^{{{}}} {}\, d{}]], { i(1), i(2), i(3), i(4, "x") }), cond(in_mathzone)),

  -- Theorem-like blocks (non-mathzone)
  s("thm", fmt([[
\begin{{theorem}}[{}]
  {}
\end{{theorem}}
]], { i(1, "name"), i(0) }), cond(not_mathzone)),

  s("def", fmt([[
\begin{{definition}}[{}]
  {}
\end{{definition}}
]], { i(1, "name"), i(0) }), cond(not_mathzone)),

  s("pf", fmt([[
\begin{{proof}}
  {}
\end{{proof}}
]], { i(0) }), cond(not_mathzone)),
}
