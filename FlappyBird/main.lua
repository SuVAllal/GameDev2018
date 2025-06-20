--[[
    GD50 2018
    Flappy Bird Remake

    Un juego para móvil hecho por Dong Nguyen que se hizo viral en 2013
    y que utiliza una mecánica de juego muy simple pero eficaz, esquivar
    tuberías indefinidamente con solo tocar la pantalla, haciendo que el
    avatar del pájaro bata las alas y se mueva ligeramente hacia arriba.
    Ilustra una de las generaciones procedimentales más básicas de niveles
    de juego al hacer que las tuberías sobresalgan del suelo o cielo en
    cantidades variables, actuando como una carrera de obstáculos generada
    indefinidamente para el jugador.
]]

-- librería para la resolución virtual
push = require 'push'

-- dimensiones físicas de la pantalla
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- dimensiones virtuales de la pantalla
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- imágenes que cargamos de memoria para más adelante dibujarlas en la pantalla
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

-- Función que carga al empezar el juego
function love.load()
    -- Quitamos el blur por defecto
    love.graphics.setDefaultFilter('nearest', 'nearest')
    -- Título de la ventana
    love.window.setTitle('Flappy Pigeon')

    -- inicializamos la resolución virtual
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

-- función para cambiar el tamaño de la pantalla (teniendo en cuenta la resolución virtual)
function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    -- de esta forma push renderiza la resolución virtual
    push:start()

    -- dibujamos el fondo empezando por la esquina superior izquierda (0, 0)
    love.graphics.draw(background, 0, 0) -- recibe el elemento a dibujar y su posición

    -- dibujamos el suelo encima del fondo, y en la esquina inferior izquierda
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16) -- (-16) es la altura de la imagen, sino estaría "escondida"

    push:finish()
end



