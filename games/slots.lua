running = true
balance = 500
lines = 3

reels = {{"O", "7", "X", "#", "@", "&", "O", "X", "&", "#", "O", "X", "&", "O", "7"}, {"O", "&", "7", "@", "X", "#", "O", "X", "&", "O", "X", "#", "&", "O", "&"}, {"O", "#", "&", "X", "7", "@", "X", "O", "#", "X", "&", "@", "X", "O", "#"}}
key = {{"O", "X", "&", "#", "@", "7"}, {6, 8, 10, 15, 50, 300}}
screen = {{"|", "|", "|"}, {"|", "|", "|"}, {"|", "|", "|"}}

function resetScreen()
    for i = 1, 3 do
        for j = 1, 3 do
            screen[i][j] = "|"
        end
    end
end

function printScreen()
    if lines == 1 then
        io.write("\n")
        for i = 1, 3 do
            if i == 2 then
                io.write("- " .. screen[1][i] .. " " .. screen[2][i] .. " " .. screen[3][i] .. " -\n")
            else
                io.write("  " .. screen[1][i] .. " " .. screen[2][i] .. " " .. screen[3][i] .. "  \n")
            end
        end
        io.write("\n")
    elseif lines == 2 then
        io.write("\n")
        for i = 1, 3 do
            io.write("- " .. screen[1][i] .. " " .. screen[2][i] .. " " .. screen[3][i] .. " -\n")
        end
        io.write("\n")
    else
        io.write("•       •\n")
        for i = 1, 3 do
            io.write("- " .. screen[1][i] .. " " .. screen[2][i] .. " " .. screen[3][i] .. " -\n")
        end
        io.write("•       •\n")
    end
end

function randomIndex()
    math.randomseed(os.time())
    return math.floor(math.random(1, 13))
end

function stopColumn(index)
    position = randomIndex()
    screen[index][1] = reels[index][position]
    screen[index][2] = reels[index][position+1]
    screen[index][3] = reels[index][position+2]
end

function getWinValue(symbol)
    for i = 1, 6 do
        if key[1][i] == symbol then return key[2][i] end
    end
end

function checkWin()
    if screen[1][2] == screen[2][2] and screen[1][2] == screen[3][2] then
        profit = getWinValue(screen[1][2])
        io.write("\n", "You win " .. profit .. "!", "\n")
        balance = balance + profit
    end
    if lines > 1 then
        if screen[1][1] == screen[2][1] and screen[1][1] == screen[3][1] then
            profit = getWinValue(screen[1][1])
            io.write("\n", "You win " .. profit .. "!", "\n")
            balance = balance + profit
        end
        if screen[1][3] == screen[2][3] and screen[1][3] == screen[3][3] then
            profit = getWinValue(screen[1][3])
            io.write("\n", "You win " .. profit .. "!", "\n")
            balance = balance + profit
        end
    end
    if lines > 2 then
        if screen[1][1] == screen[2][2] and screen[1][1] == screen[3][3] then
            profit = getWinValue(screen[1][1])
            io.write("\n", "You win " .. profit .. "!", "\n")
            balance = balance + profit
        end
        if screen[1][3] == screen[2][2] and screen[1][3] == screen[3][1] then
            profit = getWinValue(screen[1][3])
            io.write("\n", "You win " .. profit .. "!", "\n")
            balance = balance + profit
        end
    end
end

repeat
    io.write("\n", "Balance: " .. balance, "\n")

    io.write("How many lines? (1/2/3)", "\n")
    io.flush()
    lines = io.read()
    if tonumber(lines) == nil or tonumber(lines) > 3 or tonumber(lines) < 1 then
        repeat
            io.write("\n", "Please enter 1, 2, or 3", "\n")
            io.flush()
            lines = io.read()
        until tonumber(input) == 1 or tonumber(lines) == 2 or tonumber(lines) == 3
    end
    lines = tonumber(lines)
    balance = balance - lines

    io.write("\n")
    resetScreen()
    printScreen()

    io.write("\n", "Press ENTER to stop column", "\n")
    io.flush()
    io.read()
    stopColumn(1)
    printScreen()

    io.write("\n", "Press ENTER to stop column", "\n")
    io.flush()
    io.read()
    stopColumn(2)
    printScreen()

    io.write("\n", "Press ENTER to stop column", "\n")
    io.flush()
    io.read()
    stopColumn(3)
    printScreen()

    checkWin()
    io.write("\n", "Play again? (y/n)", "\n")
    io.flush()
    ans = io.read()
    if ans:upper() == "N" then running = false end
until running == false