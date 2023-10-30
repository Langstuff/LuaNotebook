local cell_mt = {}
cell_mt.__index = cell_mt

local setmetatable = setmetatable
local getmetatable = getmetatable


---@class lnb.Cell table
---@field code string
---@field name string
---@field language string

---@param name string Cell name (used for debugging purposes mostly)
---@param code string code to load
---@return lnb.Cell
local function new_cell(name, language, code)
  local obj = {
    name = name,
    language = language,
    code = code,
    result = nil,
    data = nil,
  }
  setmetatable(obj, cell_mt)
  return obj
end

function cell_mt:execute()
  local env = _ENV
  -- local env = setmetatable({}, {
  --   __index = function(self, k)
  --     local v = rawget(_G, k)
  --     if v ~= nil then
  --       return v
  --     end
  --     local upper_context = getmetatable(self)
  --     if upper_context then
  --       return upper_context:get(k)
  --     end
  --     return nil
  --   end,
  --   __newindex = function(self, k, v)
  --     if rawget(_G, k) then
  --       print("Attempt to overwrite global variable '" .. k .. "'")
  --       return
  --     end
  --     self._context:set(k, v)
  --   end,
  -- })
  local loaded, err = load(self.code, self.name, "t", env)
  if not loaded then
    return nil, err
  end
  return loaded()
end

-- local test = 1

-- if test then
--   local cell1 = new_cell("Cell 1", "lua", [=[
--     print = function()
--     end
--     print('Hello World!')
--   ]=])
--   cell1:execute()
-- end

return {
  new = new_cell
}
