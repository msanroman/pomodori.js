class PomoJS.Models.Task extends Backbone.Model

	url: ->
		url = "/tasks"
		url += "/#{@.getId()}" unless @.isNew()
		return url

	defaults: {
		name: '',
		completed: false,
		estimation: 0
	}

	getId: -> @.get 'id'

	getName: -> @.get 'name'

	isCompleted: -> @.get 'completed'

	getEstimation: -> @.get 'estimation'

	validate: (attributes) -> 
		if @.getId() < 0
			return 'invalid id'
		if @.getEstimation() < 0
			return 'invalid estimation'

	toJSON: -> {task: @.attributes}