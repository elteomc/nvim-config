local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s('thm', {
    t('theorem '),
    i(1, 'theorem_name'),
    t({ '', '    (' }),
    i(2, 'h : hypothesis'),
    t({ ') :', '    ' }),
    i(3, 'conclusion'),
    t({ ' := by', '  ' }),
    i(0),
  }),

  s('lem', {
    t('lemma '),
    i(1, 'lemma_name'),
    t({ ' :', '    ' }),
    i(2, 'statement'),
    t({ ' := by', '  ' }),
    i(0),
  }),

  s('def', {
    t('def '),
    i(1, 'name'),
    t(' ('),
    i(2, 'x : α'),
    t(') : '),
    i(3, 'β'),
    t({ ' :=', '  ' }),
    i(0),
  }),

  s('have', {
    t('have '),
    i(1, 'h'),
    t(' : '),
    i(2, 'proposition'),
    t({ ' := by', '  ' }),
    i(0),
  }),

  s('calc', {
    t({ 'calc', '  ' }),
    i(1, 'lhs'),
    t(' = '),
    i(2, 'intermediate'),
    t({ ' := by', '    ' }),
    i(3),
    t({ '', '  _ = ' }),
    i(4, 'rhs'),
    t({ ' := by', '    ' }),
    i(0),
  }),

  s('rcases', {
    t('rcases '),
    i(1, 'h'),
    t(' with ⟨'),
    i(2, 'h₁'),
    t(', '),
    i(3, 'h₂'),
    t('⟩'),
  }),

  s('obtain', {
    t('obtain ⟨'),
    i(1, 'h₁'),
    t(', '),
    i(2, 'h₂'),
    t('⟩ := '),
    i(0, 'h'),
  }),

  s('fun', {
    t('fun '),
    i(1, 'x'),
    t(' => '),
    i(0),
  }),

  s('ex', {
    t('example '),
    i(1, '(h : hypothesis)'),
    t(' : '),
    i(2, 'statement'),
    t({ ' := by', '  ' }),
    i(0),
  }),

  s('ind', {
    t('induction '),
    i(1, 'n'),
    t({ ' with', '  | zero =>', '    ' }),
    i(2),
    t({ '', '  | succ n ih =>', '    ' }),
    i(0),
  }),

  s('cases', {
    t('cases '),
    i(1, 'h'),
    t({ ' with', '  | ' }),
    i(2, 'case₁'),
    t(' => '),
    i(3),
    t({ '', '  | ' }),
    i(4, 'case₂'),
    t(' => '),
    i(0),
  }),

  s('simpa', {
    t('simpa using '),
    i(0, 'h'),
  }),
}
