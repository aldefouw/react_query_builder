def chosen_select(div, value)
	el = find(div)

	within(el) do
		find('a').click
		find('input.chosen-search-input').set(value).send_keys(:enter)
	end
end