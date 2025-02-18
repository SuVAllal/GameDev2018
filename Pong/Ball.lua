--[[
    -- Ball Class --

    Representa una pelota que estará rebotando entre las paletas y
    paredes del juego hasta que sobrepase los límites de la pantalla,
    marcando un punto para el oponente.
]]

-- creamos una instancia de 'class' llamada Ball y definimos funciones
-- que pertenecen a esta clase
Ball = Class{}


-- Constructor o función inicializadora:
function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- variables para gestionar la velocidad en el eje X e Y, ya que
    -- la pelota se puede mover en dos dimensiones
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(2) == 1 and math.random(-80, -100) or math.random(80, 100)
end


--[[
    Espera una paleta como parámetro y devuelve true o false dependiendo
    de si los rectángulos se solapan
]]
function Ball:collides(paddle)
    -- primero, miramos si la esquina izquierda de la pelota está más allá de la 
    -- esquina derecha de la paleta
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false -- entonces no colisiona
    end

    -- después miramos si la esquina inferior de la pelota está más arriba que la esquina
    -- superior de la paleta
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false -- entonces no colisiona
    end

    -- si no se cumple alguna de las anteriores, entonces están colisionando
    return true
end


--[[
    Coloca la pelota en el centro de la pantalla con una velocidad
    aleatoria para ambos ejes.
]]
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50, 50)
end


--[[
    Función para mover la pelota según su velocidad, posición y deltaTime
]]
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end