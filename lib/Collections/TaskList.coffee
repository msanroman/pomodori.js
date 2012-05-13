class PomoJS.Collections.TaskList extends Backbone.Collection

	url: '/tasks',
	model: PomoJS.Models.Task

	parse: (response) ->	return response.tasks