local ls = require("luasnip")
local s, i, t = ls.snippet, ls.insert_node, ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

-- Math context: true if cursor is inside $ ... $
local in_math = function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before = line:sub(1, col)
  local count = select(2, before:gsub("%s", ""))
  return count % 2 == 1
end

local not_math = function() return not in_math() end

local auto = function(trig, node, opts)
  opts = opts or {}
  return s(
    vim.tbl_extend("force", { trig = trig, snippetType = "autosnippet" }, opts),
    node
  )
end

local math_auto = function(trig, node)
  return auto(trig, node, { condition = in_math })
end

local prose_auto = function(trig, node)
  return auto(trig, node, { condition = not_math })
end

return {
  -- Math
  prose_auto("mk", fmt("${}$", { i(1) })), -- inline
  prose_auto("dm", fmt([[
  $
    {}
  $
  ]], { i(1) })), -- block

  math_auto("//", fmt("frac({}, {})", { i(1), i(2) })),
  math_auto("fr", fmt("frac({}, {})", { i(1, "a"), i(2, "b") })),

  s("sr", fmt("sqrt({})", { i(1) })),
  s("hat", fmt("hat({})", { i(1) })),
  s("bar", fmt("overline({})", { i(1) })),
  s("vec", fmt("arrow({})", { i(1) })),
  s("norm", fmt("||{}||", { i(1) })),

  s("sum", fmt("sum_({} = {})^({}) {}", { i(1, "k"), i(2, "0"), i(3, "n"), i(4) })),
  s("prod", fmt("product_({} = {})^({}) {}", { i(1, "k"), i(2, "0"), i(3, "n"), i(4) })),
  s("lim", fmt("lim_({} -> {}) {}", { i(1, "n"), i(2, "infinity"), i(3) })),
  s("int", fmt("integral_({})^({}) {} dif {}", { i(1, "a"), i(2, "b"), i(3), i(4, "x") })),
  s("mat", fmt("mat(\n  {};\n  {}\n)", { i(1), i(2) })),

  -- ctheorems environments
  s("thm", fmt("#theorem(title: \"{}\")[\n  {}\n]", { i(1, ""), i(2) })),
  s("lem", fmt("#lemma(title: \"{}\")[\n  {}\n]", { i(1, ""), i(2) })),
  s("def", fmt("#definition(title: \"{}\")[\n  {}\n]", { i(1, ""), i(2) })),
  s("cor", fmt("#corollary(title: \"{}\")[\n  {}\n]", { i(1, ""), i(2) })),
  s("prop", fmt("#proposition(title: \"{}\")[\n  {}\n]", { i(1, ""), i(2) })),
  s("pf", fmt("#proof[\n  {}\n]", { i(1) })),
  s("rem", fmt("#remark[\n  {}\n]", { i(1) })),
  s("ex", fmt("#example(title: \"{}\")[\n  {}\n]", { i(1, ""), i(2) })),

  -- algo
  s("alg", fmt('#algorithm(\n  caption: algorithm-caption[{}],\n)[\n  {}\n]', { i(1, "Name"), i(2) })),
  s("fn", fmt("#function({})[{}][{}]", { i(1, "name"), i(2, "args"), i(3, "body") })),

  -- Structure
  s("sec", fmt("= {}", { i(1) })),
  s("ssec", fmt("== {}", { i(1) })),
  s("sssec", fmt("=== {}", { i(1) })),
  s("fig", fmt('#figure(\n  {},\n  caption: [{}],\n) <{}>', { i(1), i(2), i(3, "label") })),
  s("link", fmt('#link("{}")[{}]', { i(1), i(2) })),
  s("ref", fmt("@{}", { i(1) })),

  -- Logic / CS symbols
  s("=>", t("=>")),
  s("<=>", t("<=>")),
  s("AA", t("forall")), -- inside math: forall
  s("EE", t("exists")),
  s("inn", t("in")),
  s("nin", t("in.not")),
  s("sub", t("subset")),
  s("sup", t("supset")),
  s("cc", t("subset.eq")),
  s("nnn", t("inter")), -- intersection
  s("uuu", t("union")),

}
