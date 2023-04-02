--[[
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>
]]

GridConfig = {
  X = "-0.5>1.5/0.25",
  Y = "0>1/0.2;0.5",
}

pattern="([0-9%.%-]+)>([0-9%.%-]+)/([0-9%.%-]+)"
errmsg="Failed to parse:"
function getGridLines(config)
  local gridLines = {}
  for item in config:gmatch("[^;]+") do
    if item:find(">") ~= nil then -- interval
      local sFrom = item:gsub(pattern, "%1")
      local from = tonumber(sFrom)
      local sTo = item:gsub(pattern, "%2")
      local to = tonumber(sTo)
      local sInterval = item:gsub(pattern, "%3")
      local interval = tonumber(sInterval)

      if not (from==nil or to==nil or interval == nil) then
        for i = from, to, interval do
          table.insert(gridLines, i)
        end
      else
        notifyWarning(errmsg .. item);
      end
    else -- single item
      local value = tonumber(item)
      if value ~= nil then
       table.insert(gridLines, value)
      else
        notifyWarning(errmsg .. item);
      end

    end
  end
  table.sort(gridLines)
  return gridLines
end

-- parse XY

local xLines = getGridLines(GridConfig.X)
local yLines = getGridLines(GridConfig.Y)

local xMin = xLines[1]
local xMax = xLines[#xLines]

local yMin = yLines[1]
if yMin > -0.2 then
  yMin = -0.2
end
local yMax = yLines[#yLines]

Grid.setCollider(xMin, xMax, yMin, yMax)

-- draw lines

for _,x in ipairs(xLines) do
  Grid.DrawLine(x, x, yMin, yMax)
end

for _,y in ipairs(yLines) do
  Grid.DrawLine(xMin, xMax, y, y)
end
