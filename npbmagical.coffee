ALL_GAME_CNT = 144
ONE_TEAM_GAME_CNT = 24

class Team
    constructor: (params = {}) ->
        @name     = params.name || ''
        @win      = params.win || 0
        @lose     = params.lose || 0
        @even     = params.even || 0
        @rest     = ALL_GAME_CNT - @win - @lose - @even
        @denom    = ALL_GAME_CNT - @even
        @winnable = @win + @rest
        @rate     = @winnable / @denom
        @gamecnt  = params.gamecnt || [0, 0, 0, 0, 0, 0]
        @magic    = null

class NpbMagical
    constructor: ->
        @teams = []
    add: (params) ->
        @teams.push new Team params
        @
    magical: ->
        for teamA, i in @teams
            # Search of a team targeted for magic
            maxRate = 0
            for teamX, j in @teams
                if i isnt j && maxRate < teamX.rate
                    maxRate = teamX.rate
                    teamB = teamX
                    gamecnt = teamA.gamecnt[j]

            # calculate
            fill = if teamA.rate isnt teamB.rate then 1 else 0
            magic = Math.floor(teamA.denom / teamB.denom * teamB.winnable) - teamA.win + fill
            teamA.magic = magic

            # Lighting or hiding
            if teamA.rest - (ONE_TEAM_GAME_CNT - gamecnt) >= teamA.magic
                console.log teamA.name + ' \\' + teamA.magic + '/'
            else
                console.log teamA.name + ' (' + teamA.magic + ')'
        null

module.exports = new NpbMagical()
