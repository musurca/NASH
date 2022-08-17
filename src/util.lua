--[[
----------------------------------------------
NASH
util.lua
----------------------------------------------

General utility functions for working with CMO
scenarios.

----------------------------------------------
]]--

function BooleanToString(val)
    if val then
        return Localize("YES")
    end
    return Localize("NO")
end

--[[
iterates through table, calling func(e) on each e in table
]]--
function ForEachDo(table, func)
    for i=1,#table do
        func(table[i])
    end
end

--[[
iterates through table, calling func(e) on each e in table,
breaking out if func(e) returns false
]]--
function ForEachDo_Break(table, func)
    for i=1,#table do
        if func(table[i]) == false then
            break
        end
    end
end

--[[
true if value is present in table, false otherwise
]]--
function IsIn(value, t)
    for _, v in pairs(t) do
        if value == v then
            return true
        end
    end
    return false
end

--[[
If a number is only a single digit, this function
adds a zero to the left side. Also converts to a string.
e.g. 
PadDigits(4) == "04"
PadDigits(12) == "12"
]]--
function PadDigits(num)
    local numStr = tostring(num)
    if #numStr == 1 then
        numStr = '0'..numStr
    end
    return numStr
end

-- Strip leading and trailing whitespace
function RStrip(str)
    str = string.gsub(str, "^%s*", "")
    return string.gsub(str, "%s*$", "")
end

--[[
Formats a string by inserting array elements.
e.g.
Format("%1 %2 %3", {"ten", "little", "indians"}) == "ten little indians"
]]--
function Format(str, arg)
    for i=1, #arg do
        str = string.gsub(
            str, 
            "[%%]["..i.."]", 
            tostring(arg[i])
        )
    end
    return str
end

--[[
Splits a string into a table, dividing into tokens
separated by whitespace (or else a custom separator).
]]--
function String_Split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

--[[
Presents the user with a simple message box that requires
no input.
]]--
function Input_OK(question)
    ScenEdit_MsgBox(question, 0)
end

--[[
Presents the user with an input box that expects a Yes
or No answer. Returns true if Yes, false if No.

The box persists until the user answers the question 
(in other words, clicking the 'X' to close the window 
will simply bring the window back up).
]]--
function Input_YesNo(question)
    local answer_table = {['Yes']=true, ['No']=false}
    while true do
        local ans = ScenEdit_MsgBox(question, 4)
        if ans ~= 'Cancel' then
            return answer_table[ans]
        end
    end
    return false
end

--[[
Presents the user with an input box that expects a numeric
input. The box persists until the user provides a valid
number.
]]--
function Input_Number(question)
    while true do
        local val = ScenEdit_InputBox(question)
        if val then
            val = tonumber(val)
            if val then
                return val
            end
        else
            return nil
        end
    end
end

--[[
Presents the user with an input box that expects a numeric
input. If the user enters nothing, the default value is used.
]]--
function Input_Number_Default(question, default)
    local val = ScenEdit_InputBox(question)
    if val then
        val = tonumber(val)
        if val then
            return val
        end
    end

    return default
end

--[[
Presents the user with an input box that expects a string.
]]--
function Input_String(question)
    local val = ScenEdit_InputBox(question)
    if val then
        return tostring(val)
    end
    return ""
end

function SideGUIDByName(name)
    for k, side in ipairs(VP_GetSides()) do
        if side.name == name then
            return side.guid
        end
    end
    return nil
end

--[[
Stores a boolean value persistently.
]]--
function StoreBoolean(id, val)
    if val then
        ScenEdit_SetKeyValue(id, 'Yes')
    else
        ScenEdit_SetKeyValue(id, 'No')
    end
end

--[[
Retrieves a stored boolean value. 
Returns false if empty.
]]--
function GetBoolean(id)
    local val = ScenEdit_GetKeyValue(id)
    if val then
        if val == 'Yes' then
            return true
        end
    end
    return false
end

--[[
Stores a string persistently.
(All persistent storage is string-based,
but we include this for type consistency.)
]]--
function StoreString(id, val)
    ScenEdit_SetKeyValue(id, val)
end

--[[
Retrieves a stored string.
]]--
function GetString(id)
    return ScenEdit_GetKeyValue(id)
end

--[[
Stores a numeric value persistently.
]]--
function StoreNumber(id, val)
    ScenEdit_SetKeyValue(id, tostring(val))
end

--[[
Retrieves a stored numeric value. 
Returns 0 if empty.
]]--
function GetNumber(id)
    local val = tonumber(ScenEdit_GetKeyValue(id))
    if val then
        return val
    end
    return 0
end

--[[
Stores an array of strings persistently. 
]]--
function StoreStringArray(id, arr)
    local arraylength = id.."_LENGTH"
    StoreNumber(arraylength, #arr)
    for i=1,#arr do
        StoreString(id.."_"..i, tostring(arr[i]))
    end
end

--[[
Retrieves a stored array of strings. 
]]--
function GetStringArray(id)
    local arr = {}
    local arraylength = GetNumber(id.."_LENGTH")
    for i=1,arraylength do
        table.insert(arr, GetString(id.."_"..i))
    end
    return arr
end

--[[
    Appends a string to an array of strings.
]]--
function AppendStringArray(id, str)
    local arraylength = GetNumber(id.."_LENGTH")
    arraylength = arraylength + 1
    StoreString(id.."_"..arraylength, tostring(str))
    StoreNumber(id.."_LENGTH", arraylength)
end

--[[
    Clears an array of strings.
]]--
function ClearStringArray(id)
    local arraylength = GetNumber(id.."_LENGTH")
    for i=1,arraylength do
        ScenEdit_ClearKeyValue(id.."_"..i)
    end
    StoreNumber(id.."_LENGTH", 0)
end

--[[
Stores an array of numbers persistently. 
]]--
function StoreNumberArray(id, arr)
    local arraylength = id.."_LENGTH"
    StoreNumber(arraylength, #arr)
    for i=1,#arr do
        StoreNumber(id.."_"..i, arr[i])
    end
end

--[[
Retrieves a stored array of numbers. 
]]--
function GetNumberArray(id)
    local arr = {}
    local arraylength = GetNumber(id.."_LENGTH")
    for i=1,arraylength do
        table.insert(arr, GetNumber(id.."_"..i))
    end
    return arr
end


function Util_DumpFields(obj)
    for k,v in pairs(obj.fields) do
        if string.find(k,'property_') ~= nil then
            local t = string.find(v," , ") -- location of first ,
            print("\r\n[object] = " .. string.sub(v,2,t-1) ) -- property name
            print( obj[string.sub(v,2,t-1)] ) -- value of property
        end
    end
end

function clip(x, a, b)
    return math.max(a, math.min(x, b))
end

--[[!! LEAVE TWO CARRIAGE RETURNS AFTER SOURCE FILE !!]]--

