// ˆø”‚ğ“WŠJ
var w = arg.w;
var h = arg.h;
var cnt = arg.cnt;
var rngOut = arg.rngOut;	// ”š’e~‰º‚ÅŒ©‚¦‚é‹ŠE”ÍˆÍ
var rngIn = arg.rngIn;		// ”š’e~‰º‚Å“G‚ğ“|‚¹‚é”ÍˆÍ
var saveDat   = arg.saveDat;
var hitEnemy  = arg.hitEnemy;
var viewEnemy = arg.viewEnemy;
// hitEnemy, viewEnemy‚Í”z—ñ
// {x: num, y: num, hit: boolen}‚ªŠi”[

// Ÿ‰ñ‚Éˆø‚«Œp‚°‚é•Û‘¶—pƒf[ƒ^
if (arg.saveDat == null) {saveDat = [];}

const TARGET = 30;

// ‹ŠE”ÍˆÍ“à‚Ì“|‚µ‚Ä‚¢‚È‚¢“G‚Ì•½‹Ï‚ğZo
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

// –CŒ‚ˆÊ’u
var x, y;
var z = arg.x;
var w = arg.y;
var hit=0;
if (arr.length >= TARGET) {
  var avrX = sumX / arr.length;
  var avrY = sumY / arr.length;
  //  var st = Math.pow(avrY - y, 2) + Math.pow(avrX - x, 2);
  // •½‹Ï‚Ì‚‚¢•û‚ÉˆÚ“®
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

// –CŒ‚ˆÊ’u
arg.x = x;
arg.y = y;
saveDat.push({x: x, y: y});
arg.saveDat = saveDat;

// ÅŒã‚Ì–CŒ‚‚É—š—ğo—Í
// if (cnt == 19) {
// 	for (var i = 0; i < arg.saveDat.length; i ++) {
// 		var dat = arg.saveDat[i];
// 		console.log(i + " " + dat.x + " " + dat.y);
// 	}
// 	console.log("----------");
// }

// Œ‹‰Ê‚Ì”z—ñ‚ğ–ß‚µ‚ÄI—¹
return arg;
