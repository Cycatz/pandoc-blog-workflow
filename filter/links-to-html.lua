function Link(el)
	if el.target ~= "/" then
		el.target = el.target .. ".html"
	end
  return el
end
