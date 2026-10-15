-- Quarto's grid listing hard-codes card titles as <h5>, so /work/ read
-- h1 -> h5 (skipped levels; site audit 2026-10-15). This filter, applied only
-- to work/index.qmd, rewrites the card-title tags to <h2>. It acts on the raw
-- HTML Pandoc sees, so it is independent of Quarto's listing-template API.
local OPEN = '<h5 class="no%-anchor card%-title listing%-title">'
local OPEN_H2 = '<h2 class="no-anchor card-title listing-title">'

local in_title = false

local function rewrite(text)
  local out, n = text:gsub(OPEN, OPEN_H2)
  if n > 0 then in_title = true end
  if in_title and out:find('</h5>', 1, true) then
    out = out:gsub('</h5>', '</h2>', 1)
    in_title = false
  end
  return out
end

function RawInline(el)
  if el.format == 'html' then
    local t = rewrite(el.text)
    if t ~= el.text then return pandoc.RawInline('html', t) end
  end
end

function RawBlock(el)
  if el.format == 'html' then
    local t = rewrite(el.text)
    if t ~= el.text then return pandoc.RawBlock('html', t) end
  end
end
