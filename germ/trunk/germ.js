// 引数を展開
var w = arg.w;
var h = arg.h;
var cnt = arg.cnt;
var rngOut = arg.rngOut;	// 爆弾降下で見える視界範囲
var rngIn = arg.rngIn;		// 爆弾降下で敵を倒せる範囲
var saveDat   = arg.saveDat;
var hitEnemy  = arg.hitEnemy;
var viewEnemy = arg.viewEnemy;
// hitEnemy, viewEnemyは配列
// {x: num, y: num, hit: boolen}が格納

// 次回に引き継げる保存用データ
if (arg.saveDat == null) {saveDat = [];}

const TARGET = 30;

// 視界範囲内の倒していない敵の平均を算出
var arr = [];
var sumX = 0, sumY = 0;
for (var i = 0; i < viewEnemy.length; i ++) {
  var ene = viewEnemy[i];
  if (! ene.hit) {
    arr.push(ene);
    sumX += ene.x;
    sumY += ene.y;
  }
}

// 砲撃位置
var x, y;
var z = arg.x;
var w = arg.y;
var hit=0;
if (arr.length >= TARGET) {
  var avrX = sumX / arr.length;
  var avrY = sumY / arr.length;
  //  var st = Math.pow(avrY - y, 2) + Math.pow(avrX - x, 2);
  // 平均の高い方に移動
  var theta = Math.atan2(avrY - w, avrX - z);
HIT:
  for (var s=0; s < 6; s++){
    x = z + rngIn * 2 * Math.cos(theta + Math.PI/3*s);
    y = w + rngIn * 2 * Math.sin(theta + Math.PI/3*s);

    hit = 0;

    for (var i=0; i < arr.length; i++) {
      var ene = arr[i];
      if (Math.pow(ene.x - x, 2) + Math.pow(ene.y - y, 2) <= Math.pow(rngIn , 2)) {
        if (++hit >= TARGET) break HIT;
      }
    }
  }
}

// var found1 = false;
// if (cnt > 1) {
//   var old = saveDat[cnt-2];
//   if (Math.pow(old.x - x, 2) + Math.pow(old.y - y, 2) <= Math.pow(rngIn , 2)) {
//     found1 = true;
//   }
// }

var found2, old2;
// if (arr.length <= 20 || found1 || st < Math.pow(10, 2)) {
if (hit < TARGET) {
  do {
    found2 = false;
    x = Math.floor(Math.random() * (w - rngIn * 2)) + rngIn;
    y = Math.floor(Math.random() * (h - rngIn * 2)) + rngIn;
    for (var i = 0; i < cnt; i++) {
      old2 = saveDat[i];
      if (Math.pow(old2.x - x, 2) + Math.pow(old2.y - y, 2) < Math.pow(rngIn * 2, 2)) {
        found2 = true;
        break;
      }
    }
  }
  while (found2);
}

// 砲撃位置
arg.x = x;
arg.y = y;
saveDat.push({x: x, y: y});
arg.saveDat = saveDat;

// 最後の砲撃時に履歴出力
// if (cnt == 19) {
// 	for (var i = 0; i < arg.saveDat.length; i ++) {
// 		var dat = arg.saveDat[i];
// 		console.log(i + " " + dat.x + " " + dat.y);
// 	}
// 	console.log("----------");
// }

// 結果の配列を戻して終了
return arg;
