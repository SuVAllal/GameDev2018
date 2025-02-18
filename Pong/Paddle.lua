--[[
    -- Paddle Class --

    Representa la paleta/raqueta, se mueve arriba o abajo.
    Usada para devolver la pelota al oponente.
]]

Paddle = Class{}


--[[
    La función 'init' en nuestra clase solo se llama una vez, cuando el
    objeto se crea por primera vez. Usada para establecer todas las variables
    en la clase y tenerlas preparadas para usar.

    La paleta necesita una X y una Y para posicionarse, al igual que un
    alto y un ancho para sus dimensiones.

    NOTA: 'self' es una referencia a *THIS* objeto, referenciando al objeto
    instanciado en el momento en el que se llama a esta función. Diferentes
    objetos pueden tener su propia x, y, width y height, estos solo sirven
    como contenedores de información. Es decir, los objetos son similares
    a los structs en C.
]] 
function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0 -- inicializamos la velocidad a 0 ya que inicialmente no nos movemos
end


function Paddle:update(dt)
    -- math.max asegura que cuando pulsemos ARRIBA la posición Y del
    -- jugador sea siempre mayor que 0, el movimiento calculado es
    -- simplemente la velocidad de la paleta calculada en versiones
    -- anteriores
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    -- de forma similar, esta vez usamos math.min para asegurarnos de que
    -- no sobrepasamos la parte baja de la pantalla (teniendo en cuenta
    -- el tamaño de la paleta)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end


--[[
    Función para ser llamada por la función 'love.draw' del main.
    Usa la función 'rectangle' de LÖVE2D, la cual recibe un modo de dibujo
    como primer argumento, la posición y dimensiones del rectángulo.
    Para cambiar el color, debemos llamar a 'love.graphics.setColor'.
    En la nueva versión de LÖVE2D puedes incluso dibujar rectángulos
    redondeados!
]]
function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end