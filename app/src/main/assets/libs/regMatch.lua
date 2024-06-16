function regMatch(reg, str)
  local matcher = Pattern.compile(reg).matcher(str)
  local tab = {}
  while matcher.find() do
    local start = matcher.start()
    local ends = matcher.end()
    local text = String(str).substring(start, ends)
    local group1 = String(matcher.group(1))
    local group2 = String(matcher.group(2))
    tab[#tab+1] = {
      start=start,
      ends=ends,
      text=text,
      group1=group1,
      group2=group2,
    }
  end
  return tab
end
