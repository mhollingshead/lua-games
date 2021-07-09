max = 13
chips = 100
last = 0

function randomInRange (n)
    math.randomseed(os.time())
    return math.floor(math.random(1, n))
end

function higherLower (n)
    if n > last then return "HIGHER than"
    elseif n < last then return "LOWER than"
    else return "EQUAL to" end
end

input = ""
current = randomInRange(max)

io.write("You have " .. chips .. " chips.", "\n")

repeat 
    last = current
    current = randomInRange(max)
    bet = 0

    repeat
        io.write("What would you like to wager? (Number 1 - " .. chips .. " || QUIT)", "\n")
        io.write()
        io.flush()
        input = io.read()
    until input:upper() == "QUIT" or (tonumber(input) >= 1 and tonumber(input) <= chips)

    if input:upper() ~= "QUIT" then
        bet = tonumber(input)

        repeat
            io.write("\n", "Will the next number be HIGHER than, LOWER than, or EQUAL to " .. last .. "?", "\n")
            io.write("(HIGHER / LOWER / EQUAL / QUIT)", "\n")
            io.flush()
            input = io.read()
        until input:upper() == "HIGHER" or input:upper() == "LOWER" or input:upper() == "EQUAL"
        
        io.write("\n", current .. " is " .. higherLower(current) .. " " .. last .. "!", "\n")

        correct = "CORRECT"

        if input:upper() ~= "QUIT" then
            if higherLower(current) == "HIGHER than" then
                if input:upper() == "HIGHER" then chips = chips + bet
                else 
                    chips = chips - bet 
                    correct = "INCORRECT"
                end
            elseif higherLower(current) == "LOWER than" then
                if input:upper() == "LOWER" then chips = chips + bet
                else 
                    chips = chips - bet 
                    correct = "INCORRECT"
                end
            else
                if input:upper() == "EQUAL" then chips = chips + (bet * 2)
                else 
                    chips = chips - bet 
                    correct = "INCORRECT"
                end
            end
            io.write("\n", "You were " .. correct .. "! You now have " .. chips .. " chips.", "\n")
        end
    end

until input:upper() == "QUIT" or chips == 0

if chips ~= 0 then io.write("\n", "Thanks for playing! You finished with " .. chips .. " chips!", "\n")
else io.write("\n", "You're out of chips!", "\n") end