--[[
    Pong Game

    Programado originalmente por Atari en 1972. Cuenta con dos
    paletas, controladas por los jugadores, con el objetivo de
    conseguir pasar la pelota más allá del borde de su oponente.
    El primero en llegar a 10 puntos gana.
]]

-- push es una librería que nos permitirá dibujar nuestro juego con una
-- resolución virtual, en lugar de usar la resolución basada en el tamaño
-- de nuestra ventana, usada para aportar una estética más retro
-- 
-- https://github.com/Ulydev/push
push = require 'push'


-- la librería 'class' nos permitirá representar cualquier objeto en
-- nuestro juego como código, en vez de usar muchas variables y métodos
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- clase 'Paddle', guarda la posición y las dimensiones para cada paleta
-- y la lógica para renderizarlas
require 'Paddle'

-- clase 'Ball', ídem que la clase 'Paddle' pero para la pelota de juego
require 'Ball'


-- Usaremos esta resolución virtual, pero nuestro juego se ejecutará
-- en una ventana con la resolución real que declaramos abajo
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Variables globales, tamaño de la ventana
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

PADDLE_SPEED = 200 -- Velocidad a la que se moverán las paletas, multiplicada por dt


-- Función usada para inicializar el juego, establece qué pasa nada más empezar
function love.load()
    -- Utiliza el filtro nearest en la ampliación y reducción de escala
    -- para evitar que el texto y los gráficos se vean borrosos
    -- (prueba a eliminar esta función para ver la diferencia!)
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- generamos una semilla aleatoria basada en la hora actual
    math.randomseed(os.time())

    -- Usamos una fuente más retro con tamaño 8
    smallFont = love.graphics.newFont('font.ttf', 8)

    -- Establecemos la fuente como la fuente activa de LOVE2D
    love.graphics.setFont(smallFont)

    -- Inicializa nuestra resolución virtual, que se renderizará dentro
    -- de nuestra ventana real sin importar sus dimensiones, reemplaza a
    -- nuestra llamada love.window.setMode
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- inicializamos las paletas de los jugadores, las hacemos globales
    -- para que otras funciones y módulos puedan usarlas
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    -- colocamos la pelota en el centro de la pantalla
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- estado del juego, usado para las distinas partes del juego (beginning,
    -- menus, main game, high score list, etc.), lo usaremos para determinar
    -- el comportamiento del juego al renderizar y al producirse cambios
    gameState = 'start'
end


-- Se ejecuta en cada frame, pasando 'dt' (nuestra delta en segundos
-- desde el último frame), algo calculado por LOVE
function love.update(dt)
    -- movimiento del jugador 1
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- movimiento del jugador 2
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- actualizamos la pelota basándonos en la velocidad SOLO si estamos 
    -- en el estado 'jugando', la velocidad es independiente del framerate
    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end


-- Gestiona las teclas del teclado, se pasa la tecla como parámetro
function love.keypressed(key)
    -- Las teclas pueden accederse bajo su nombre string
    if key == 'escape' then
        -- Función que cierra la aplicación
        love.event.quit()
    -- si presionamos enter durante el estado start, pasaremos al estado play
    -- la pelota se moverá en direcciones aleatorias
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            -- reseteamos la posición de la pelota
            ball:reset()
        end
    end
end


-- Función usada para dibujar en la pantalla
function love.draw()
    -- Todo a lo que llamemos dentro de 'start' y 'end' se renderiza
    -- en resolución virtual

    -- renderizamos con la resolución virtual
    push:apply('start')

    -- Pintamos el fondo de la pantalla de un color
    love.graphics.clear(255/255, 105/255, 180/255, 255/255)

    -- dibujamos diferentes cosas según el estado del juego
    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf("Let's Play!", 0, 20, VIRTUAL_WIDTH, 'center')
    end

    -- renderizamos las paletas
    player1:render()
    player2:render()

    -- renderizamos la pelota
    ball:render()

    -- termina de renderizar en resolución virtual
    push:apply('end')
end