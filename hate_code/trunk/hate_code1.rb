$strInput = ARGF.gets
$arrInput = $strInput.scan(/(.)/)

$strTmp = ""
$arrInput.each_with_index do |arrA, intI|
  if Array['C'] == arrA
    $intIndex = 5
  elsif Array["d"] == arrA
    $intIndex = 3
  elsif Array['e'] == arrA
    $intIndex = 2
  elsif Array["I"] == arrA
    $intIndex = 1
  elsif Array['o'] == arrA
    $intIndex = 4
  elsif Array["Q"] == arrA
    $intIndex = 0
  end

  $strTmp = $strTmp + $arrInput[$intIndex][-1].capitalize + " "
end

$arrReturn = $strTmp.scan(/(.)/)
$arrReturn[11] = ""
puts $arrReturn.join("")
