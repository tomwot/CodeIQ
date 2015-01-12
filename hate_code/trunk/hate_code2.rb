$strInput = ARGF.gets
$arrInput = $strInput.scan(/(.)/)

$arrInput.each_with_index{|arrA, intI|
Array['C'] == arrA ? $arrInput[0] = "Q" : Array[?d] == arrA ? $arrInput[2] = 'e' : Array["e"] == arrA ? $arrInput[3] = ?d : Array['I'] == arrA ? $arrInput[4] = "o" : Array[?o] == arrA ? $arrInput[1] = 'I' : Array["Q"] == arrA ? $arrInput[5] = ?C : nil
}

$strTmp = ""
$arrInput.each_with_index{|strI, intI|
$strTmp = $strTmp + strI[-1].capitalize + " "
}
$arrReturn = $strTmp.scan(/(.)/)
$arrReturn[11] = ""

puts $arrReturn.join("")
