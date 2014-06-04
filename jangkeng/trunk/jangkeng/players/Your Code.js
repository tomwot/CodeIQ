"use strict";

/*
PlayerName="tomwot" 
【感想・作戦・工夫した点など】
作戦：
相手の出す手の周期が検出出来たらその周期に合わせて勝てる手を出す。
それで負ける様だったら手を変える。
感想：
まずはお題相手に全勝出来た手で投稿してみます。
*/

// 文字列の周期を検出する。
function period(str) {
    var n = str.length;

    for( var s = 1 ; s < n ; ++s ) {
        if ( str.slice(0, n - s) == str.slice(s, n) ) {
            return s;
        }
    }
    return n;

}

var score_table = {
    GC: 17,
    CP: 10,
    PG: 10 
};


// 過去の勝敗によるスコア取得状況を照会
function score( hands, last ) {
    var r = [[], []];
    for ( var i = hands[0].length - last ; i < hands[0].length ; ++i ) {
        r[0].push( score_table[ hands[0][i] + hands[1][i] ] || 0);
        r[1].push( score_table[ hands[1][i] + hands[0][i] ] || 0);
    }
    return r;
}


function consecutive_lose( h, n ) {
    var s = score( h, n );
    var enemy_last_score = 0;
    var min_score = 9999;

    for (var key in score_table) {
        if ( min_score > score_table[key] ) {
            min_score = score_table[key];
        }
    }

    for ( var i = 0; i < n ; ++i ) {
        enemy_last_score += s[1][i];
    }

    return (enemy_last_score >= min_score * n);
}



var hand_ini = "PGCG";
var check_num = 8;
var calc_last_score = 2;

var looped = false;
var count = -1;
var win_hand = { G: "P", C: "G", P: "C" };

function play(h)
{
    count++;

    // 敵の手のループを検出
    var enemy_last_hand = h[1].slice(h[1].length - check_num, h[1].length);
    var prod = period(enemy_last_hand);
    if ( h[1].length * 2 > check_num && check_num > prod * 2 && !looped) {
        looped = count;
    }

    if ( !looped ) {
        return hand_ini[count%(hand_ini.length)];
    }

    var enemy_hand_estimate = enemy_last_hand[check_num % prod];
    // ループを検出して少し経つのに連敗しているときはパターンを変える。
    if ( count - looped > check_num && consecutive_lose( h, calc_last_score ) ) {
        enemy_hand_estimate = h[1][h[1].length - 1];
    }
    
    return win_hand[ enemy_hand_estimate ];
}

// イベントを受け取り、グーチョキパーのどれを出すかを返信するための仕組みです。
self.addEventListener('message', function(e) {
  self.postMessage( play(e.data.split(",")) );
}, false);
