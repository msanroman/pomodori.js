describe 'Task', ->

  beforeEach ->
    @task = new PomoJS.Models.Task

  it "should exist", ->
    expect(PomoJS.Models.Task).toBeDefined()

  describe "default values for new tasks", ->
    it "should have an empty string as default name", ->
      expect(@task.get "name").toEqual ""

    it "shouldn't be completed", ->
      expect(@task.get "completed").toEqual false

    it "should have no pomodoros assigned as default estimation", ->
      expect(@task.get "estimation").toEqual 0

  describe "getters", ->

    describe "getId", ->

      it "should be defined", ->
        expect(@task.getId).toBeDefined()
      it "should return model's id", ->
        stub = sinon.stub(@task, 'get').returns 1

        expect(@task.getId()).toEqual 1
        expect(stub.calledWith('id')).toBeTruthy()

    describe "getName", ->

      it "should be defined", ->
        expect(@task.getName).toBeDefined()

      it "should return its name", ->
        spyOn(@task, 'get').andReturn 'Trololo!'

        expect(@task.getName()).toEqual 'Trololo!'
        expect(@task.get).toHaveBeenCalledWith('name')

    describe "isCompleted", ->

      it "should be defined", ->
        expect(@task.isCompleted).toBeDefined()
      it "should return value for the completed attribute", ->
        spyOn(@task, 'get').andReturn(false)

        expect(@task.isCompleted()).toEqual false
        expect(@task.get).toHaveBeenCalledWith('completed')

    describe "getEstimation", ->

      it "should be defined", ->
        expect(@task.getEstimation).toBeDefined()
      it "should return its estimation", ->
        spyOn(@task, 'get').andReturn 5

        expect(@task.getEstimation()).toEqual 5
        expect(@task.get).toHaveBeenCalledWith("estimation")

  describe "save", ->

    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    it 'sends valid data to the server', ->
      @task.save {name: 'new task name', estimation: 1}

      request = @server.requests[0]

      params = JSON.parse(request.requestBody)
      expect(params.task).toBeDefined()
      expect(params.task.name).toEqual 'new task name'
      expect(params.task.complete).toBeFalsy()
      expect(params.task.estimation).toEqual 1

    describe 'server requests', ->

      describe 'on create', ->

        beforeEach ->
          @task.id = null
          @task.save()
          @request = @server.requests[0]

        it 'should be POST', ->
          expect(@request.method).toEqual 'POST'

        it 'should have /tasks as url', ->
          expect(@request.url).toEqual '/tasks'

      describe 'on update', ->

        beforeEach ->
          @task.save(id: 13)
          @request = @server.requests[0]

        it 'should be PUT', ->
          expect(@request.method).toEqual 'PUT'

        it 'should have /tasks/13 as url', ->
          expect(@request.url).toEqual '/tasks/13'

    it "won't save with negative id", ->
      @task.set({id: -1})
      expect(@task.isValid()).toBeFalsy()

    it "won't save with negative estimation", ->
      @task.set({estimation: -2})
      expect(@task.isValid()).toBeFalsy()