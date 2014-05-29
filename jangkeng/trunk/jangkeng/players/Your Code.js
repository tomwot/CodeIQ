"use strict";

/*
PlayerName="ここにプレイヤー名を書いて下さい。使える文字は（いわゆる半角の）英数字、空白、下線 のみです。" 
【感想・作戦・工夫した点など】
《この行を削除し、感想・作戦・工夫した点などを書いて下さい。複数行でも構いません》
*/

function play(h)
{
  // この関数の実装を変更し、勝利を目指して下さい。
  // ちなみにこのコードは、「直前に相手がパーを出していたらチョキを出す。それ以外はグーを出す」という意味です。
  var last = h[1][h[1].length-1];
  return last ==="P" ? "C" : "G";
}

// イベントを受け取り、グーチョキパーのどれを出すかを返信するための仕組みです。
self.addEventListener('message', function(e) {
  self.postMessage( play(e.data.split(",")) );
}, false);
