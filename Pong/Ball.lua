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
    self.dx = math.random(-50, 50)
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