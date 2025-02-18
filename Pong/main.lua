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
push = require 'push'

-- Usaremos esta resolución virtual, pero nuestro juego se ejecutará
-- en una ventana con la resolución real que declaramos abajo
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Variables globales, tamaño de la ventana
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

PADDLE_SPEED = 200 -- Velocidad a la que se moverán las raquetas, multiplicada por dt

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

    -- Usamos la misma fuente pero con un tamaño mayor para las puntuaciones
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- Establecemos la fuente como la fuente activa de LOVE2D
    love.graphics.setFont(smallFont)

    -- Inicializa nuestra resolución virtual, que se renderizará dentro
    -- de nuestra ventana real sin importar sus dimensiones, reemplaza a
    -- nuestra llamada love.window.setMode
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- Variables para la puntuación de cada jugador, usadas para mostrarlas
    -- por pantalla y saber quién va ganando
    player1Score = 0
    player2Score = 0

    -- Posición de las raquetas en el eje Y (solo se pueden mover arriba o abajo)
    -- Las colocamos en la misma posición que cuando las creamos
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50

    -- variables para la velocidad (delta y, delta x) y posición de la pelota cuando empieza el juego
    -- colocamos la pelota inicialmente en el centro, pero guardaremos su posición
    -- en variables, porque esta se va a ir modificando
    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    -- math.random nos devuelve un numero aleatorio dentro del rango de los números que se le manden
    -- la velocidad de la pelota también va a ir variando para complicar el juego
    ballDX = math.random(2) == 1 and 100 or -100 -- si el número es 1, se mueve hacia la derecha (100), si es 2, se mueve hacia la izquierda (-100)
    ballDY = math.random(-50, 50) -- se mueve hacia arriba o hacia abajo con una velocidad aleatoria

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
        -- nos movemos en negativo ya que el eje Y crece hacia abajo ( (-) + (-) = -, sube)
        -- limitamos la posición usando math.max para evitar que se salga la
        -- paleta de la pantalla, pues como el eje Y crece hacia abajo el 0 es el límite superior de la pantalla
        player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        -- nos movemos en positivo para bajar
        -- math.min nos devuelve el menor de dos valores: la parte de abajo de la pantalla
        -- menos la altura de la paleta, y la posición deseada por el jugador, para asegurarnos
        -- de no salir de los límites de la pantalla
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end

    -- movimiento del jugador 2
    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

    -- actualizamos la posición de la pelota SOLO si estamos en el estado 'jugando',
    -- la velocidad es independiente del framerate
    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end
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

            -- la pelota empieza en el medio de la pantalla
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            -- le damos un valor aleatorio a la velocidad
            ballDX = math.random(2) == 1 and 100 or -100 -- esto en C sería: if(math.random(2) == 1) ? 100 : -100
            ballDY = math.random(-50, 50) * 1.5
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
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- Texto de bienvenida en la parte de arriba de la pantalla
    love.graphics.printf(
        'Hello Pong!',           -- texto a renderizar
        0,                       -- starting X (0 ya que vamos a centrarlo respecto al ancho)
        20,                      -- starting Y (en la parte de arriba de la pantalla, el tamaño por defecto de la pantalla en LOVE es 12)
        VIRTUAL_WIDTH,           -- numero de pixeles en los que centrarse (lo centramos en toda la pantalla)
        'center')                -- modo de alineación, puede ser 'center', 'left' o 'right'

    -- Dibujamos las puntuaciones a la izquierda y derecha de la pantalla
    -- Debemos cambiar de fuente antes de pintar o LOVE cogerá la última
    -- establecida, que es la de 8 píxeles
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- Las raquetas son simples rectángulos que dibujamos en la pantalla
    -- en ciertas posiciones, al igual que la pelota
    love.graphics.rectangle('fill', 10, player1Y, 5, 20) -- Raquet izquierda
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20) -- Raqueta derecha
    love.graphics.rectangle('fill', ballX, ballY, 4, 4) -- Pelota en el centro

    -- termina de renderizar en resolución virtual
    push:apply('end')
end