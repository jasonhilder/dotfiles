local present1, autopairs = pcall(require, "nvim-autopairs")
local present2, autopairs_cmp = pcall(require, "nvim-autopairs.completion.cmp")

if not (present1 or present2) then
    local cmp = require('cmp')
    cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
    return
end

autopairs.setup()
