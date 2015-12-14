puts readlines.sort_by{|filename|
  _, basename_no_lastnum, basename_lastnum, ext = *filename.match(/^(.*?)(\d*)\.(.+)$/)
  [
  basename_no_lastnum,
  basename_lastnum.to_i,
  basename_lastnum,
  ext,
  ]
}
