-- Characters in a line --
length = (26 * 2) + 31
-- Cyclone prize value order --
prizes = {2, 2, 2, 4, 4, 4, 4, 6, 6, 6, 8, 8, 10, 100, 10, 8, 8, 6, 6, 6, 4, 4, 4, 2, 2, 2}

-- Shift array by 1 --
function offsetPrizeArray(ind)
    newArr = {}
    for i = ind, #prizes do
        table.insert(newArr, prizes[i])
    end
    for i = 1, ind-1 do
        table.insert(newArr, prizes[i])
    end
    return newArr
end

-- Print functions --
function printArray(arr)
    for i = 1, #arr do
        io.write(" " .. arr[i] .. " ")
    end
end
function printBorder()
    io.write("\n")
    io.write("\n")
    for i = 1, length do io.write("–") end
    io.write("\n")
    for i = 1, length do io.write("X") end
    io.write("\n")
    for i = 1, length do io.write("–") end
    io.write("\n")
    io.write("\n")
end

-- os.sleep(), credit: @Fluff --
if not os.sleep then
   local ok,ffi = pcall(require,"ffi")
   if ok then
      if not os.sleep then
         ffi.cdef[[
            void Sleep(int ms);
            int poll(struct pollfd *fds,unsigned long nfds,int timeout);
         ]]
         if ffi.os == "Windows" then
            os.sleep = function(sec)
               ffi.C.Sleep(sec*1000)
            end
         else
            os.sleep = function(sec)
               ffi.C.poll(nil,0,sec*1000)
            end
         end
      end
   else
      local ok,socket = pcall(require,"socket")
      if not ok then local ok,socket = pcall(require,"luasocket") end
      if ok then
         if not os.sleep then
            os.sleep = function(sec)
               socket.select(nil,nil,sec)
            end
         end
      else
         local ok,alien = pcall(require,"alien")
         if ok then
            if not os.sleep then
               if alien.platform == "windows" then
                  kernel32 = alien.load("kernel32.dll")
                  local slep = kernel32.Sleep
                  slep:types{ret="void",abi="stdcall","uint"}
                  os.sleep = function(sec)
                     slep(sec*1000)
                  end
               else
                  local pol = alien.default.poll
                  pol:types('struct', 'unsigned long', 'int')
                  os.sleep = function(sec)
                     pol(nil,0,sec*1000)
                  end
               end
            end
         elseif package.config:match("^\\") then
            os.sleep = function(sec)
               local timr = os.time()
               repeat until os.time() > timr + sec
            end
         else
            os.sleep = function(sec)
               os.execute("sleep " .. sec)
            end
         end
      end
   end
end

-- TODO: simultaneous loops to listen for stop --
i = 1
count = 1
running = true
-- For now does 4 cycles --
repeat
    if i == #prizes+1 then i = 1 end
    printBorder()
    io.write("                                          |\n")
    printArray(offsetPrizeArray(i))
    io.write("\n                                          |")
    printBorder()
    os.sleep(0.02)
    count = count + 1
    i = i + 1
until count == 106 or running == false