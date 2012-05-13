describe 'PomoJS.Routers.Router', ->

	beforeEach ->
		@router = new PomoJS.Routers.Router()
		@routerSpy = sinon.spy()
		try
			Backbone.history.start({silent:true})
		catch error
		@router.navigate("elsewhere")

	it 'should exist', ->
		expect(PomoJS.Routers.Router).toBeDefined()
	it 'should be instantiable', ->
		router = new PomoJS.Routers.Router()
		expect(router).not.toBeNull()


	it 'fires the index route with a blank hash', ->
		@router.on("route:index", @routerSpy)
		@router.navigate("", true)
		expect(@routerSpy.calledOnce).toBeTruthy()
		expect(@routerSpy.calledWith()).toBeTruthy()