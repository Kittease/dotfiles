local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
  s(
    "rafce",
    fmt(
      [[
interface []Props {
  []
}

const [] = ({ [] }: []Props) => {
  return <div>[]</div>;
};

export default [];
]],
      {
        i(1, "Component"),
        i(2),
        rep(1),
        i(3),
        rep(1),
        rep(1),
        rep(1),
      },
      { delimiters = "[]" }
    )
  ),
}
