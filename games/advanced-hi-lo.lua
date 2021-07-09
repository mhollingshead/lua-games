Engine = {}
function Engine.new (self)
    self.odds = 2
    self.chance = 1/self.odds*0.95
    self.lower_threshold = math.floor(self.chance * 10000)
    self.higher_threshold = 10000 - self.lower_threshold
end
function Engine.updateChance(self)
    self.chance = 1/self.odds*0.95
    self.lower_threshold = math.floor(self.chance * 10000)
    self.higher_threshold = 10000 - self.lower_threshold
end
function Engine.updateOdds (self, odds)
    self.odds = odds
    self.updateChance(self)
end
engine = Engine
engine.new(engine)

function randomInRange (n)
    math.randomseed(os.time())
    return math.floor(math.random(1, n))
end

Game = {running = true}
function Game.new (self, buyin)
    self.buyin = buyin
    self.balance = buyin
    self.jackpot = 0
end
function Game.bet (self, bet)
    self.balance = self.balance - bet
end
function Game.win (self, win)
    self.balance = self.balance + win
end
function Game.setJackpot (self, jackpot)
    self.jackpot = jackpot
end
function Game.printInfo (self)
    io.write("\n", "BALANCE: " .. self.balance .. " (" .. (self.balance - self.buyin) .. ")", "\n")
    io.write("ODDS: " .. engine.odds, "\n")
    io.write("CHANCE: " .. engine.chance * 100 .. "%", "\n")
end
function Game.roll (self, bet, hilo)
    self.bet(self, bet + self.jackpot)

    roll = randomInRange(10000)
    io.write("\n", "You rolled: " .. roll, "\n")

    if hilo == "HI" then
        if roll >= engine.higher_threshold then 
            self.win(self, math.floor(bet * engine.odds))
            io.write("You won " .. math.floor(bet * engine.odds) .. "!", "\n")
        end
    else
        if roll <= engine.lower_threshold then 
            self.win(self, math.floor(bet * engine.odds))
            io.write("You won " .. math.floor(bet * engine.odds) .. "!", "\n")
        end
    end

    if roll == 8888 then 
        self.win(self, self.jackpot * 10000) 
        io.write("Plus a jackpot of " .. self.jackpot * 10000 .. "!", "\n")
    end
end


-- Setup --
input = ""

io.write("Welcome to the HiLo game! What would you like to buy in for?", "\n")
io.write("(Number > 0)", "\n")
io.flush()
input = io.read()

if tonumber(input) == nil then
    repeat
        io.write("\n", "Please enter a number > 0", "\n")
        io.flush()
        input = io.read()
    until tonumber(input) > 0
end

game = Game
game.new(game, tonumber(input))


-- Game loop --
repeat
    game.printInfo(game)
    io.write("\n", "Option > ")
    io.flush()
    input = io.read():upper()

    if input == "BET" then

        io.write("\n", "How much would you like to bet?", "\n")
        io.write("(Number 1 - " .. game.balance .. ")", "\n")
        io.flush()
        input = io.read()

        if tonumber(input) == nil then
            repeat
                io.write("\n", "Please enter a number 1 - " .. game.balance, "\n")
                io.flush()
                input = io.read()
            until tonumber(input) ~= nil and tonumber(input) > 0 and tonumber(input) <= game.balance
        end

        bet = tonumber(input)

        io.write("\n", "At " .. engine.chance * 100 .. "% odds you can win " .. ((bet * engine.odds) - bet), "\n")
        io.write("To win, bet HI and roll a number higher than " .. engine.higher_threshold, "\n")
        io.write("or bet LO and roll a number lower than " .. engine.lower_threshold, "\n")
        io.write("(HI / LO)", "\n")
        io.flush()
        input = io.read():upper()

        if input ~= "HI" and input ~= "LO" then
            repeat
                io.write("\n", "Please enter HI or LO", "\n")
                io.flush()
                input = io.read():upper()
            until input == "HI" or input == "LO"
        end

        game.roll(game, bet, input)

    elseif input == "HELP" then

        io.write("\n")
        io.write("--------- COMMANDS ---------", "\n")
        io.write("    BET  bet on a hi/lo roll", "\n")
        io.write("   ODDS  change win odds", "\n")
        io.write("JACKPOT  change jackpot bet", "\n")
        io.write("   QUIT  quit game", "\n")

    elseif input == "ODDS" then

        io.write("\n", "Change bet odds", "\n")
        io.write("(Number 1.01 - 4750)", "\n")
        io.flush()
        input = io.read()

        if tonumber(input) == nil then
            repeat
                io.write("\n", "Please enter a number 1.01 - 4750", "\n")
                io.flush()
                input = io.read()
            until tonumber(input) ~= nil and tonumber(input) >= 1.01 and tonumber(input) <= 4750
        end

        engine.updateOdds(engine, tonumber(input))

    elseif input == "JACKPOT" then

        io.write("\n", "Roll an 8888 to win 10000x your jackpot bet!", "\n")
        io.write("How much extra per roll would you like to bet on the jackpot?", "\n")
        io.write("(0 - " .. game.balance .. ")", "\n")
        io.flush()
        input = io.read()

        if tonumber(input) == nil then
            repeat
                io.write("\n", "Please enter a number 0 - " .. game.balance, "\n")
                io.flush()
                input = io.read()
            until tonumber(input) ~= nil and tonumber(input) >= 0 and tonumber(input) <= game.balance
        end

        game.setJackpot(game, tonumber(input))

    elseif input == "QUIT" then
        io.write("\n", "Thanks for playing!", "\n")
        io.write("Your final balance is: " .. game.balance .. " (" .. (game.balance - game.buyin) .. ")", "\n")
        game.running = false
    else
        io.write("\n", "Unrecognized input. Type HELP for list of commands.", "\n")
    end
until game.running ~= true