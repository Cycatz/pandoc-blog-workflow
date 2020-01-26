function Link(el)
	if el.target ~= "/" and not string.find(el.target, "http") then
		el.target = el.target .. ".html"
	end
  return el
end
