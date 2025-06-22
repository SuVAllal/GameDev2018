--[[
    Bird Class

    El pájaro es lo que controlamos en el juego pulsando en la barra
    espaciadora, cuando la pulsamos el pájaro volará e irá levemente 
    hacia arriba, pero acto seguido se verá afectado de nuevo por
    la gravedad. Si el pájaro golpea el suelo o una tubería (farolas
    en este caso), el juego termina.
]]

Bird = Class{}

local GRAVITY = 20

function Bird:init()
    -- carga la imagen de la paloma de memoria y asigna su ancho y alto
    self.image = love.graphics.newImage('pigeon.png')
    self.width = self.image:getWidth()
    self.height = self.image:getWidth()

    -- posicionamos la paloma en el centro de la pantalla
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- Velocidad inicial del eje Y
    self.dy = 0 -- inicialmente a 0 ya que no queremos que se caiga en cuanto aparezca
end

function Bird:update(dt)
    -- Aplicamos la gravedad a la velocidad (aplicamos la gravedad para que caiga el pájaro)
    self.dy = self.dy + GRAVITY * dt

    -- Aplicamos la velocidad a la posición del eje Y (cambiamos la posición del pájaro)
    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end