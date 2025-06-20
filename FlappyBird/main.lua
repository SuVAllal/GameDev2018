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

-- librería OOP
Class = require 'class'

-- importamos la clase Bird
require 'Bird'

-- dimensiones físicas de la pantalla
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- dimensiones virtuales de la pantalla
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- imágenes que cargamos de memoria para más adelante dibujarlas en la pantalla
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

-- punto de inicio del movimiento de las imágenes
local backgroundScroll = 0
local groundScroll = 0

-- velocidad a la que se mueven las imágenes
local BACKGROUND_SCROLL_SPEED = 30 -- el paisaje está más lejo, se mueve más lento
local GROUND_SCROLL_SPEED = 60 -- el suelo está más cerca, se mueve más rápido

-- punto en el que el bucle del fondo vuelve a 0 (para no mover la imagen infinitamente y quedarnos sin ella)
local BACKGROUND_LOOPING_POINT = 413

-- creamos una instancia de la clase Bird
local bird = Bird()

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

function love.update(dt)
    -- movimiento del fondo (velocidad * dt), vuelve a 0 tras llegar
    -- al looping point
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT
    
    -- movimiento del suelo (velocidad * dt), vuelve a 0 tras pasar
    -- el límite del ancho de la pantalla
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % VIRTUAL_WIDTH
end

function love.draw()
    -- de esta forma push renderiza la resolución virtual
    push:start()

    -- dibujamos las imágenes a la izquierda de su looping point, 
    -- en algún punto volverán al punto 0 lo que lo hará ver
    -- como un scrolling infinito. Escoger el looping point es clave,
    -- pues la ilusión del bucle depende de ello

    -- dibujamos el fondo empezando por la esquina superior izquierda
    love.graphics.draw(background, -backgroundScroll, 0) -- recibe el elemento a dibujar y su posición

    -- dibujamos el suelo encima del fondo, y en la esquina inferior izquierda
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16) -- (-16) es la altura de la imagen, sino estaría "escondida"

    -- renderizamos el pájaro usando su propia lógica
    bird:render()

    push:finish()
end



