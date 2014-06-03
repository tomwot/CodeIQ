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

// main.js からのデッドコピーに近しいもの
function score( hands, last ) {
    var r = [0, 0];
    var score_table = {
        GC: 17,
        CP: 10,
        PG: 10 
    };
    for ( var i = hands[0].length - last ; i < hands[0].length ; ++i ) {
        r[0] += score_table[ hands[0][i] + hands[1][i] ] || 0;
        r[1] += score_table[ hands[1][i] + hands[0][i] ] || 0;
    }
    return r;
}


var hand_ini = "PGCG";
var check_num = 8;

var looped = false;
var count = -1;

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

    var enemy_hand_estimate = "";
    var s = score( h, 2 );

    if ( count - looped > check_num && s[1] >= 20) {
        // ループを検出して少し経つのに連敗しているときは手を変える。
        enemy_hand_estimate = h[1][h[1].length - 1];
    } else {
        enemy_hand_estimate = enemy_last_hand[check_num % prod];
    }
    if ( enemy_hand_estimate == "P" ) {
        return "C";
    } else if ( enemy_hand_estimate == "G" ) {
        return "P";
    } else {
        return "G";
    }
}

// イベントを受け取り、グーチョキパーのどれを出すかを返信するための仕組みです。
self.addEventListener('message', function(e) {
  self.postMessage( play(e.data.split(",")) );
}, false);
