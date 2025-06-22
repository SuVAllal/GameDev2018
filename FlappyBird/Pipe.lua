--[[
    Pipe Class

    Representa las tuberías (farolas en este caso) que se generan de forma
    aleatoria en nuestro juego, actúando como obstáculos. Las tuberías sobresalen
    de forma aleatoria de arriba o abajo de la pantalla. Cuando el jugador
    choca con alguna de ellas, el juego termina. En vez de que el pájaro se
    esté moviendo horizontalmente por la pantalla, las tuberías se moverán
    por la pantalla para dar la ilusión de movimiento para el jugador.
]]

Pipe = Class{}

-- como solo queremos cargar la imagen una vez, no para cada instancia, 
-- (pues va a haber varias, no solo una como el pájaro) lo definimos 
-- externamente para tener solo una copia de ese elemento
local PIPE_IMAGE = love.graphics.newImage('lamp.png')

local PIPE_SCROLL = -60 -- negativo para que vaya a la izquierda

function Pipe:init()
    self.x = VIRTUAL_WIDTH -- para que empiecen a salir por la derecha

    -- establecemos el eje Y a un valor aleatorio por debajo de la mitad de la pantalla
    self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 60)

    self.width = PIPE_IMAGE:getWidth()
end

-- función para que se mueva la tubería
function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end