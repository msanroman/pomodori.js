Backbone.history.start({silent:true, pushState: true})

describe 'PomoJS.Collections.TaskList', ->

	beforeEach ->
		@taskList = new PomoJS.Collections.TaskList()

	it 'should exist', ->
		expect(PomoJS.Collections.TaskList).toBeDefined()

	it 'should be instantiable', ->
		list = new PomoJS.Collections.TaskList();
		expect(list).not.toBeNull()

	describe '#fetch', ->

		beforeEach ->
			@server = sinon.fakeServer.create()

		afterEach ->
			@server.restore()

		it 'should have a request URL equal to /tasks', ->

			@taskList.fetch()
			expect(@server.requests[0].url).toEqual('/tasks')

		describe 'TaskList should parse fetch response and return a Task collection', ->

			taskResponse = { tasks: [
					{id: 1, name: "Write blog entry", completed: false, estimation: 3},
					{id: 2, name: "Rule the world", completed: true, estimation: 2}
				]}
			
			beforeEach ->
				@server.respondWith('GET', '/tasks', [
					200, {"Content-type": "application/json"}, JSON.stringify(taskResponse)
					])

				@taskList.fetch()
				@server.respond()

			it 'loads all tasks from the response', ->
				expect(@taskList.models.length).toEqual(2)

			it 'parses all tasks from the response into Task objects', ->
				task = @taskList.get(2)
				expect(task.getName()).toEqual("Rule the world")
				expect(task.isCompleted()).toBeTruthy()
				expect(task.getEstimation()).toEqual(2)


