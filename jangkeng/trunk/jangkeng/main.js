"use strict";

/// run all matches
function run_all()
{
    /// calculate scores from pair of hand strings.
    function calc_scores( hands )
    {
        if ( 0 <= hands[0].indexOf("invalid") ) {
            return [ - Infinity, 0];
        } else if ( 0 <= hands[1].indexOf("invalid") ) {
            return [0, - Infinity];
        }
        var r = [0, 0];
        var score_table = {
            GC: 17,
            CP: 10,
            PG: 10 
        };
        for ( var i = 0 ; i < hands[0].length ; ++i ) {
            r[0] += score_table[ hands[0][i] + hands[1][i] ] || 0;
            r[1] += score_table[ hands[1][i] + hands[0][i] ] || 0;
        }
        return r;
    }

    function sign(x) {
        return (0 < x) - (x < 0);
    }

    function add_point( ix, r )
    {
        var $point = $("#table1point_" + ix);
        var cur = parseInt( $point.text(), 10 );
        $point.text( cur + [ 0, 10001, 30010 ][r + 1] );
    }

    function split_10(s)
    {
        var r = "";
        for ( var i = 0 ; i < 10 ; ++i ) {
            if ( i ) {
                r += " ";
            }
            r += s.substr(i * 10, 10);
        }
        return r;
    }

    function log_info( args, scores, hands )
    {
        return [
        args[0].fn + " : " + scores[0] + " /  " + args[1].fn + " : " + scores[1],
        split_10(hands[0]),
        split_10(hands[1])
        ].join("<br/>");
    }

    function update_table2( table, a, b, score, diff )
    {
        var $td = $("#table" + table + "cell" + a + "_" + b);
        $td.text( score );
        $td.removeClass();
        $td.addClass( ["lose", "even", "win"][diff + 1] );
    }
    
    function update_table1( a, b, score, diff )
    {
        update_table2(1, a, b, score, diff);
        add_point( a, diff );
    }

    function show_result( args, hands, tick )
    {
        var scores = calc_scores( hands );
        $("#log").append( "<hr noshade>" );
        var self = "";
        if (args[0].self || args[1].self) {
            self = "self";
        }
        $("#log").append( "<div class='" + self + "'>" + log_info(args, scores, hands ) + "</div>" );

        var diff = sign(scores[0] - scores[1]);
        update_table1( args[0].ix, args[1].ix, scores[0], diff );
        update_table1( args[1].ix, args[0].ix, scores[1], - diff );
    }

    function sort_result() {
        var n = srces.length;
        var order = [];

        for ( var x = 0 ; x < n ; ++x ) {
            order.push(x);
        }
        order.sort(function(a, b){
            var x = $("#table1point_" + a).text();
            var y = $("#table1point_" + b).text();
            return y - x;
        });
        for ( var i = 0 ; i < n ; ++i ) {
            $("#table2name" + i).text($("#table1name" + order[i]).text());
            $("#table2point_" + i).text($("#table1point_" + order[i]).text());
            for ( var j = 0 ; j < n ; ++j ) {
                if ( i != j ) {
                    var scores = [
                        $("#table1cell" + order[i] + "_" + order[j]).text(),
                        $("#table1cell" + order[j] + "_" + order[i]).text()
                        ];
                    var diff = sign(scores[0] - scores[1]);
                    
                    update_table2( 2, i, j, scores[0], diff );
                    update_table2( 2, j, i, scores[1], - diff );
                }
            }
        }
        $("#table1").css("display", "none");
        $("#table2").css("display", "block");
    }


    function play( args ) {
        var t0 = ( new Date() ).getTime();
        function curTick() {
            return ( new Date() ).getTime() - t0;
        }
        var players = [
        new Worker("players/" + args[0].fn),
        new Worker("players/" + args[1].fn )
        ];
        var hands = ["", ""];
        function nextHands() {
            for ( var i = 0 ; i < 2 ; ++i ) {
                players[i].postMessage(hands[i] + "," + hands[1 - i]);
            }
        }
        function addEventListener(i, p) {
            p.addEventListener('message', function(e) {
                var valid = {
                    G: 1,
                    C: 1,
                    P: 1
                }
                [e.data];
                hands[i] += valid ? e.data : ("[[invalid hand : " + e.data + "]]" );
                if ( hands[0].length == hands[1].length || ! valid) {
                    if ( hands[1].length < 100 && valid) {
                        nextHands();
                    } else {
                        show_result( args, hands, curTick() );
                        players[0].terminate();
                        players[1].terminate();
                        run -= 1;
                        if (run == 0) {
                            sort_result();
                        }
                        return;
                    }
                }
            }, false);
        }
        for ( var i = 0 ; i < 2 ; ++i ) {
            addEventListener(i, players[i]);
        }
        nextHands();
    }
    function append_head(srces)
    {
        var head = "";
        for ( var b = 0 ; b < srces.length ; ++b ) {
            head += "<th>" + (b + 1) + "</th>";
            if ( b%5 == 4 ) {
                head += "<td class='gap'></td>";
            }
        }
        $("#table1").append("<tr class='head'><th>#</th><th>name</th><th>point</th>" + head + "</tr>");
        $("#table2").append("<tr class='head'><th>#</th><th>name</th><th>point</th>" + head + "</tr>");
    }
    function build_table(srces)
    {
        append_head(srces);
        for ( var a = 0 ; a < srces.length ; ++a ) {
            var s = ["", "", ""];
            for (var t = 1 ; t < 3 ; ++t ) {
                for ( var b = 0 ; b < srces.length ; ++b ) {
                    s[t] += "<td id='table" + t + "cell" + a + "_" + b + "'>&nbsp;</td>";
                    if ( b%5 == 4 ) {
                        s[t] += "<td class='gap'></td>";
                    }
                }
            }
            if ( a%10 === 5 ) {
                $("#table1").append("<tr class='gap'><td/></tr>");
                $("#table2").append("<tr class='gap'><td/></tr>");
            } else if ( a%10 === 0 && a ) {
                append_head(srces);
            }
            var name = srces[a].substring( 0, srces[a].length-3 );
            $("#table1").append("<tr><td>" + (a + 1) + "</td><th id='table1name" + a + "'>" + name + "</th><td class='point' id='table1point_" + a + "'>0</td>" + s[1] + "</tr>");
            $("#table2").append("<tr><td>" + (a + 1) + "</td><th id='table2name" + a + "'>" + name + "</th><td class='point' id='table2point_" + a + "'>0</td>" + s[2] + "</tr>");
        }
        append_head(srces);
    }

    $("#log").empty();
    $("#table1").empty();
    $("#table2").empty();
    $("#table1").css("display", "block");
    $("#table2").css("display", "none");

    var srces_org = [
/*
        "Amazing Opossum.js",
        "Careless Rabbit.js",
        "Fashionable  Crocodile.js",
        "King Pangolin.js",
        "Monday Sparrow.js",
        "Stone Believer.js",
        "Ultimate Stone Slayer.js"
*/
        "24D.js",
        "alluser.js",
        "antimon2.js",
        "Anti_Predictor.js",
        "arthor.js",
        "carrotflakes.js",
        "Choco_bar.js",
        "ciel.js",
        "douglas.js",
        "EEL733.js",
        "ex02xx.js",
        "gogo.js",
        "Golden_Finger.js",
        "Gotch.js",
        "jangken_P01.js",
        "Jumping_Spider.js",
        "Kezy.js",
        "kksk.js",
        "KoukiMino.js",
        "mameta.js",
        "Mega_Charizard_X.js",
        "mijime.js",
        "MikeCAT.js",
        "Nikumo.js",
        "oda1979.js",
        "Opening_Middle_and_Final.js",
        "permil.js",
        "Prototype3.js",
        "ryosy383.js",
        "R_Fighter.js",
        "suppy193.js",
        "tbpgr.js",
        "Terrible_Gasbombe.js",
        "todaemon.js",
        "xlune.js",
        "yamato.js",
        "__proto__.js"
    ];
    
    var srces_add = [
        "tomwot.js"
    ];
    var srces = srces_org.concat(srces_add);
    build_table(srces);
    var plays = [];
    function startPlay(a, b) {
        play( [ {
            ix: a,
            fn: srces[a],
            self: (srces_add.indexOf(srces[a]) >= 0)
        }, {
            ix: b,
            fn: srces[b], 
            self: (srces_add.indexOf(srces[b]) >= 0)
        }
        ] );
    }
    var run = 0;
    for ( var a = 0 ; a < srces.length ; ++a ) {
        for ( var b = 0 ; b < a ; ++b ) {
            startPlay(a, b);
            run += 1;
        }
    }
}

