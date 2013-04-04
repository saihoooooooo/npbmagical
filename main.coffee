util = require 'util'
request = require 'request'
cheerio = require 'cheerio'
iconv = require 'iconv'
npbMmagical = require './npbmagical'

targeturl =
    c: 'http://bis.npb.or.jp/2013/stats/std_c.html'
    p: 'http://bis.npb.or.jp/2013/stats/std_p.html'

if targeturl[process.argv[2]] is undefined
    util.puts('Usage: coffee main.js [c|p]')
    process.exit(1)

request
    url: targeturl[process.argv[2]]
    encoding: null,
    (error, response, body) ->
        return null if error or response.statusCode != 200

        # Convert to UTF-8
        conv = new iconv.Iconv('sjis', 'utf8')
        $ = cheerio.load conv.convert(body).toString(),
            lowerCaseTags: true
            lowerCaseAttributeNames: true

        # gamecnt = win + lose + even
        getGamecnt = (text) ->
            array = text.match(/[0-9]/g)
            if array?
                array.reduce (prev, current) ->
                    parseInt(prev, 10) + parseInt(current, 10)
            else
                0

        $('.stdtblSubmain > tr').each (i, elem) ->
            return null if i == 0
            npbMmagical.add
                name   : $(this).find('.stdTeam').first().text()
                win    : parseInt($(this).children().eq(2).text(), 10)
                lose   : parseInt($(this).children().eq(3).text(), 10)
                even   : parseInt($(this).children().eq(4).text(), 10)
                gamecnt: [
                    getGamecnt($(this).children().eq(9).text()),
                    getGamecnt($(this).children().eq(10).text()),
                    getGamecnt($(this).children().eq(11).text()),
                    getGamecnt($(this).children().eq(12).text()),
                    getGamecnt($(this).children().eq(13).text()),
                    getGamecnt($(this).children().eq(14).text())
                ]
            null

        npbMmagical.magical()
